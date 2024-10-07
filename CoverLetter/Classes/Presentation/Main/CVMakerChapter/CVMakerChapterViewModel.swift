//
//  CVMakerChapterViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import RxSwift
import RxCocoa

final class CVMakerChapterViewModel {
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension CVMakerChapterViewModel {
    struct Input {
        let didSaveGeneralInfo: Signal<GeneralInfo>
        let didSaveWorkExperiences: Signal<[WorkExperience]>
        let didSaveEducations: Signal<[Education]>
        let didSaveProfessionalSkills: Signal<[ProfessionalSkill]>
        let didSaveLanguages: Signal<[Language]>
        let didSaveInterests: Signal<[Interest]>
        let didSaveCertificates: Signal<[Certificate]>
        let didSaveSocialMedia: Signal<SocialMedia>
        let didSaveReferences: Signal<[Reference]>
    }
    
    struct Output {
        let profile: Driver<Profile>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        Output(
            profile: makeProfile(),
            disposable: makeDisposable(
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
        )
    }
}

// MARK: Private
private extension CVMakerChapterViewModel {
    func makeProfile() -> Driver<Profile> {
        profileManager
            .obtainProfile()
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeDisposable(
        didSaveGeneralInfo: Signal<GeneralInfo>,
        didSaveWorkExperiences: Signal<[WorkExperience]>,
        didSaveEducations: Signal<[Education]>,
        didSaveProfessionalSkills: Signal<[ProfessionalSkill]>,
        didSaveLanguages: Signal<[Language]>,
        didSaveInterests: Signal<[Interest]>,
        didSaveCertificates: Signal<[Certificate]>,
        didSaveSocialMedia: Signal<SocialMedia>,
        didSaveReferences: Signal<[Reference]>
    ) -> Disposable {
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
            references
        ])
    }
}
