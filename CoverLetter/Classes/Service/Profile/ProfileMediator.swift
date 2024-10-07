//
//  ProfileMediator.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import RxSwift
import RxCocoa

final class ProfileMediator {
    static let shared = ProfileMediator()
    
    private init() {}
    
    private lazy var didChangeGeneralInfoTrigger = PublishRelay<GeneralInfo>()
    private lazy var didChangeWorkExperiencesTrigger = PublishRelay<[WorkExperience]>()
    private lazy var didChangeEducationsTrigger = PublishRelay<[Education]>()
    private lazy var didChangeProfessionalSkillsTrigger = PublishRelay<[ProfessionalSkill]>()
    private lazy var didChangeLanguagesTrigger = PublishRelay<[Language]>()
    private lazy var didChangeInterestsTrigger = PublishRelay<[Interest]>()
    private lazy var didChangeCertificatesTrigger = PublishRelay<[Certificate]>()
    private lazy var didChangeSocialMediaTrigger = PublishRelay<SocialMedia>()
    private lazy var didChangeReferencesTrigger = PublishRelay<[Reference]>()
    private lazy var didDeleteEntityTrigger = PublishRelay<ProfileManager.Entity>()
    private lazy var didDeleteProfileTrigger = PublishRelay<Void>()
}

// MARK: Public
extension ProfileMediator {
    func change(generalInfo: GeneralInfo) {
        didChangeGeneralInfoTrigger.accept(generalInfo)
    }
    
    func change(workExperiences: [WorkExperience]) {
        didChangeWorkExperiencesTrigger.accept(workExperiences)
    }
    
    func change(educations: [Education]) {
        didChangeEducationsTrigger.accept(educations)
    }
    
    func change(professionalSkills: [ProfessionalSkill]) {
        didChangeProfessionalSkillsTrigger.accept(professionalSkills)
    }
    
    func change(languages: [Language]) {
        didChangeLanguagesTrigger.accept(languages)
    }
    
    func change(interests: [Interest]) {
        didChangeInterestsTrigger.accept(interests)
    }
    
    func change(certificates: [Certificate]) {
        didChangeCertificatesTrigger.accept(certificates)
    }
    
    func change(socialMedia: SocialMedia) {
        didChangeSocialMediaTrigger.accept(socialMedia)
    }
    
    func change(references: [Reference]) {
        didChangeReferencesTrigger.accept(references)
    }
    
    func delete(entity: ProfileManager.Entity) {
        didDeleteEntityTrigger.accept(entity)
    }
    
    func deleteProfile() {
        didDeleteProfileTrigger.accept(Void())
    }
    
    var didChangeGeneralInfo: Signal<GeneralInfo> {
        didChangeGeneralInfoTrigger.asSignal()
    }
    
    var didChangeWorkExperiences: Signal<[WorkExperience]> {
        didChangeWorkExperiencesTrigger.asSignal()
    }
    
    var didChangeEducations: Signal<[Education]> {
        didChangeEducationsTrigger.asSignal()
    }
    
    var didChangeProfessionalSkills: Signal<[ProfessionalSkill]> {
        didChangeProfessionalSkillsTrigger.asSignal()
    }
    
    var didChangeLanguages: Signal<[Language]> {
        didChangeLanguagesTrigger.asSignal()
    }
    
    var didChangeInterests: Signal<[Interest]> {
        didChangeInterestsTrigger.asSignal()
    }
    
    var didChangeCertificates: Signal<[Certificate]> {
        didChangeCertificatesTrigger.asSignal()
    }
    
    var didChangeSocialMedia: Signal<SocialMedia> {
        didChangeSocialMediaTrigger.asSignal()
    }
    
    var didChangeReferences: Signal<[Reference]> {
        didChangeReferencesTrigger.asSignal()
    }
    
    var didDeleteEntity: Signal<ProfileManager.Entity> {
        didDeleteEntityTrigger.asSignal()
    }
    
    var didDeleteProfile: Signal<Void> {
        didDeleteProfileTrigger.asSignal()
    }
}
