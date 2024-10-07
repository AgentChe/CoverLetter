//
//  CVMakerViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import RxSwift
import RxCocoa

final class CVMakerViewModel {
    enum Route {
        case cancelFlow, preview(CV), share(CV), paygate
    }
    
    private lazy var profileManager = ProfileManager()
    private lazy var resumeManager = ResumeManager()
    
    private var profileGenerator: CVMakerProfileGenerator!
}

// MARK: Public
extension CVMakerViewModel {
    struct Input {
        let mode: CVMakerViewController.Mode
        let didSelectTemplate: Signal<CVTemplate>
        let didSaveGeneralInfo: Signal<GeneralInfo>
        let didSaveWorkExperiences: Signal<[WorkExperience]>
        let didSaveEducations: Signal<[Education]>
        let didSaveProfessionalSkills: Signal<[ProfessionalSkill]>
        let didSaveLanguages: Signal<[Language]>
        let didSaveInterests: Signal<[Interest]>
        let didSaveCertificates: Signal<[Certificate]>
        let didSaveSocialMedia: Signal<SocialMedia>
        let didSaveReferences: Signal<[Reference]>
        let didCreateCV: Signal<Void>
        let didTapPreview: Signal<Void>
        let didShareCV: Signal<Void>
        let didCancelFlow: Signal<Void>
    }
    
    struct Output {
        let profile: Driver<Profile>
        let templatesElements: Driver<[CVMTemplatesCollectionElement]>
        let route: Driver<Route>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let cv = makeCV(
            mode: input.mode,
            didCreateCV: input.didCreateCV,
            didSelectTemplate: input.didSelectTemplate
        )
        
        let profile = makeProfile(mode: input.mode)
        
        profileGenerator = CVMakerProfileGenerator(
            initialProfile: profile,
            didSaveGeneralInfo: input.didSaveGeneralInfo,
            didSaveWorkExperiences: input.didSaveWorkExperiences,
            didSaveEducations: input.didSaveEducations,
            didSaveProfessionalSkills: input.didSaveProfessionalSkills,
            didSaveLanguages: input.didSaveLanguages,
            didSaveInterests: input.didSaveInterests,
            didSaveCertificates: input.didSaveCertificates,
            didSaveSocialMedia: input.didSaveSocialMedia,
            didSaveReferences: input.didSaveReferences
        )
        
        return Output(
            profile: profile,
            templatesElements: makeTemplatesElements(mode: input.mode),
            route: makeRoute(
                didCancelFlow: input.didCancelFlow,
                didTapPreview: input.didTapPreview,
                didShareCV: input.didShareCV,
                cv: cv
            ),
            disposable: makeDisposable(
                mode: input.mode,
                didSaveGeneralInfo: input.didSaveGeneralInfo,
                didSaveWorkExperiences: input.didSaveWorkExperiences,
                didSaveEducations: input.didSaveEducations,
                didSaveProfessionalSkills: input.didSaveProfessionalSkills,
                didSaveLanguages: input.didSaveLanguages,
                didSaveInterests: input.didSaveInterests,
                didSaveCertificates: input.didSaveCertificates,
                didSaveSocialMedia: input.didSaveSocialMedia,
                didSaveReferences: input.didSaveReferences,
                createCV: cv
            )
        )
    }
}

// MARK: Private
private extension CVMakerViewModel {
    func makeCV(
        mode: CVMakerViewController.Mode,
        didCreateCV: Signal<Void>,
        didSelectTemplate: Signal<CVTemplate>
    ) -> Driver<CV> {
        didCreateCV
            .withLatestFrom(didSelectTemplate)
            .flatMapLatest { [weak self] template -> Driver<CV> in
                guard let self else { return .never() }
                
                let profile = self.profileGenerator.make()
                
                switch mode {
                case .create:
                    return self.resumeManager
                        .createCV(template: template, profile: profile)
                        .asDriver(onErrorDriveWith: .never())
                case .edit(let cv):
                    let updatedCV = CV(
                        id: cv.id,
                        template: template,
                        profile: profile,
                        created: cv.created,
                        edited: Date()
                    )
                    
                    return self.resumeManager
                        .edit(cv: updatedCV)
                        .asDriver(onErrorDriveWith: .never())
                }
            }
    }
    
    func makeProfile(mode: CVMakerViewController.Mode) -> Driver<Profile> {
        switch mode {
        case .create:
            return profileManager
                .obtainProfile()
                .asDriver(onErrorDriveWith: .never())
        case .edit(let cv):
            return .deferred { .just(cv.profile) }
        }
    }
    
    func makeTemplatesElements(mode: CVMakerViewController.Mode) -> Driver<[CVMTemplatesCollectionElement]> {
        resumeManager
            .obtainCVTemplates()
            .asDriver(onErrorJustReturn: [])
            .map { templates -> [CVMTemplatesCollectionElement] in
                [.header] + templates.enumerated().map { index, template -> CVMTemplatesCollectionElement in
                    let marked: Bool = {
                        switch mode {
                        case .create:
                            return index == 0
                        case .edit(let cv):
                            return template.identifier == cv.template.identifier
                        }
                    }()
                    
                    let element = CVMTemplatesCollectionTemplateElement(
                        template: template,
                        marked: marked
                    )
                    return .template(element)
                }
            }
    }
    
    func makeRoute(
        didCancelFlow: Signal<Void>,
        didTapPreview: Signal<Void>,
        didShareCV: Signal<Void>,
        cv: Driver<CV>
    ) -> Driver<Route> {
        let cancelFlow = didCancelFlow
            .map { Route.cancelFlow }
            .asDriver(onErrorDriveWith: .never())
        
        let preview = didTapPreview
            .withLatestFrom(cv)
            .asDriver(onErrorDriveWith: .never())
            .map { Route.preview($0) }
        
        let shareOrPaygate = didShareCV
            .withLatestFrom(cv)
            .asDriver(onErrorDriveWith: .never())
            .map { cv -> Route in
                SessionManager().hasActiveSubscriptions() ? Route.share(cv) : Route.paygate
            }
        
        return Driver
            .merge(cancelFlow, preview, shareOrPaygate)
    }
    
    func makeDisposable(
        mode: CVMakerViewController.Mode,
        didSaveGeneralInfo: Signal<GeneralInfo>,
        didSaveWorkExperiences: Signal<[WorkExperience]>,
        didSaveEducations: Signal<[Education]>,
        didSaveProfessionalSkills: Signal<[ProfessionalSkill]>,
        didSaveLanguages: Signal<[Language]>,
        didSaveInterests: Signal<[Interest]>,
        didSaveCertificates: Signal<[Certificate]>,
        didSaveSocialMedia: Signal<SocialMedia>,
        didSaveReferences: Signal<[Reference]>,
        createCV: Driver<CV>
    ) -> Disposable {
        switch mode {
        case .create:
            let generalInfo = didSaveGeneralInfo
                .flatMapLatest { [weak self] generalInfo -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(generalInfo: generalInfo)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let workExperiences = didSaveWorkExperiences
                .flatMapLatest { [weak self] workExperiences -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(workExperiences: workExperiences)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let educations = didSaveEducations
                .flatMapLatest { [weak self] educations -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(educations: educations)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let professionalSkills = didSaveProfessionalSkills
                .flatMapLatest { [weak self] skills -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(professionalSkills: skills)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let languages = didSaveLanguages
                .flatMapLatest { [weak self] languages -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(languages: languages)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let interests = didSaveInterests
                .flatMapLatest { [weak self] interests -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(interests: interests)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let certificates = didSaveCertificates
                .flatMapLatest { [weak self] certificates -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(certificates: certificates)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let socialMedia = didSaveSocialMedia
                .flatMapLatest { [weak self] socialMedia -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(socialMedia: socialMedia)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            let references = didSaveReferences
                .flatMapLatest { [weak self] references -> Signal<Void> in
                    guard let self else { return .never() }
                    
                    return self.profileManager
                        .set(references: references)
                        .asSignal(onErrorSignalWith: .never())
                }
                .emit()
            
            return Disposables.create([
                generalInfo,
                workExperiences,
                educations,
                professionalSkills,
                languages,
                interests,
                certificates,
                socialMedia,
                references,
                createCV.drive()
            ])
        case .edit:
            return Disposables.create([createCV.drive()])
        }
    }
}
