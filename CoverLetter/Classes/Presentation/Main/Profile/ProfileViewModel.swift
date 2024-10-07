//
//  ProfileViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import RxSwift
import RxCocoa

final class ProfileViewModel {
    enum Route {
        case settings
        case changeCVMakerChapter(ProfileTableCVMakerChapterElement)
    }
    
    enum Action {
        case confirmDeleteProfile
    }
    
    private lazy var profileManager = ProfileManager()
}

// MARK: Public
extension ProfileViewModel {
    struct Input {
        let didTapSettings: Signal<Void>
        let didTapDeleteProfile: Signal<Void>
        let didConfirmedDeleteProfile: Signal<Void>
        let didSelectCVMakerChapter: Signal<ProfileTableCVMakerChapterElement>
    }
    
    struct Output {
        let elements: Driver<[ProfileTableElement]>
        let route: Driver<Route>
        let actions: Driver<Action>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let profile = makeProfle()
        
        return Output(
            elements: makeElements(profile: profile),
            route: makeRoute(
                didTapSettings: input.didTapSettings,
                didSelectCVMakerChapter: input.didSelectCVMakerChapter
            ),
            actions: makeActions(didTapDeleteProfile: input.didTapDeleteProfile),
            disposable: makeDisposable(didConfirmedDeleteProfile: input.didConfirmedDeleteProfile)
        )
    }
}

// MARK: Private
private extension ProfileViewModel {
    func makeElements(profile: Driver<Profile>) -> Driver<[ProfileTableElement]> {
        profile
            .map { profile -> [ProfileTableElement] in
                var result = [ProfileTableElement]()
                
                let info = ProfileTableInfoElement(
                    photoFileName: profile.generalInfo?.photoFileName,
                    firstName: profile.generalInfo?.firstName,
                    lastName: profile.generalInfo?.lastName,
                    jobTitle: profile.workExperiences?.last?.jobTitle
                )
                result.append(.info(info))
                
                result.append(contentsOf: [
                    .cvMakerChapter(.generalInfo),
                    .cvMakerChapter(.workExperience),
                    .cvMakerChapter(.education),
                    .cvMakerChapter(.professionalSkills),
                    .cvMakerChapter(.languages),
                    .cvMakerChapter(.interests),
                    .cvMakerChapter(.certificates),
                    .cvMakerChapter(.socialMedia),
                    .cvMakerChapter(.references)
                ])
                
                return result
            }
    }
    
    func makeProfle() -> Driver<Profile> {
        let triggers = Signal
            .merge(
                ProfileMediator.shared.didChangeGeneralInfo.map { _ in Void() },
                ProfileMediator.shared.didChangeWorkExperiences.map { _ in Void() },
                ProfileMediator.shared.didChangeEducations.map { _ in Void() },
                ProfileMediator.shared.didChangeProfessionalSkills.map { _ in Void() },
                ProfileMediator.shared.didChangeLanguages.map { _ in Void() },
                ProfileMediator.shared.didChangeInterests.map { _ in Void() },
                ProfileMediator.shared.didChangeCertificates.map { _ in Void() },
                ProfileMediator.shared.didChangeSocialMedia.map { _ in Void() },
                ProfileMediator.shared.didChangeReferences.map { _ in Void() },
                ProfileMediator.shared.didDeleteEntity.map { _ in Void() },
                ProfileMediator.shared.didDeleteProfile.map { _ in Void() }
            )
            .startWith(())
        
        return triggers
            .flatMapLatest { [weak self] void -> Signal<Profile> in
                guard let self else { return .never() }
                
                return profileManager
                    .obtainProfile()
                    .asSignal(onErrorSignalWith: .never())
            }
            .asDriver(onErrorDriveWith: .never())
    }
    
    func makeRoute(
        didTapSettings: Signal<Void>,
        didSelectCVMakerChapter: Signal<ProfileTableCVMakerChapterElement>
    ) -> Driver<Route> {
        let settings = didTapSettings
            .map { Route.settings }
            .asDriver(onErrorDriveWith: .never())
        
        let changeCVMakerChapter = didSelectCVMakerChapter
            .map { Route.changeCVMakerChapter($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver.merge(settings, changeCVMakerChapter)
    }
    
    func makeActions(didTapDeleteProfile: Signal<Void>) -> Driver<Action> {
        let confirmDelete = didTapDeleteProfile
            .map { Action.confirmDeleteProfile }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(confirmDelete)
    }
    
    func makeDisposable(didConfirmedDeleteProfile: Signal<Void>) -> Disposable {
        let deleteProfile = didConfirmedDeleteProfile
            .flatMapLatest { [weak self] void -> Signal<Void> in
                guard let self else { return .never() }
                
                return profileManager
                    .deleteProfile()
                    .asSignal(onErrorSignalWith: .never())
            }
            .emit()
        
        return Disposables.create([deleteProfile])
    }
}
