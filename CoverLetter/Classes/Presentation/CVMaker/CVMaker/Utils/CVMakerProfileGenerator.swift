//
//  CVMakerProfileGenerator.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import RxSwift
import RxCocoa

final class CVMakerProfileGenerator {
    private var generalInfo: GeneralInfo?
    private var workExperience: [WorkExperience]?
    private var educations: [Education]?
    private var professionalSkills: [ProfessionalSkill]?
    private var languages: [Language]?
    private var interests: [Interest]?
    private var certificates: [Certificate]?
    private var socialMedia: SocialMedia?
    private var references: [Reference]?
    
    private lazy var disposeBag = DisposeBag()
    
    init(
        initialProfile: Driver<Profile>,
        didSaveGeneralInfo: Signal<GeneralInfo>,
        didSaveWorkExperiences: Signal<[WorkExperience]>,
        didSaveEducations: Signal<[Education]>,
        didSaveProfessionalSkills: Signal<[ProfessionalSkill]>,
        didSaveLanguages: Signal<[Language]>,
        didSaveInterests: Signal<[Interest]>,
        didSaveCertificates: Signal<[Certificate]>,
        didSaveSocialMedia: Signal<SocialMedia>,
        didSaveReferences: Signal<[Reference]>
    ) {
        initialProfile
            .drive(Binder(self) { base, profile in
                base.generalInfo = profile.generalInfo
                base.workExperience = profile.workExperiences
                base.educations = profile.educations
                base.professionalSkills = profile.professionalSkills
                base.languages = profile.languages
                base.interests = profile.interests
                base.certificates = profile.certificates
                base.socialMedia = profile.socialMedia
                base.references = profile.references
            })
            .disposed(by: disposeBag)
        
        didSaveGeneralInfo
            .emit(to: Binder(self) { base, generalInfo in
                base.generalInfo = generalInfo
            })
            .disposed(by: disposeBag)
        
        didSaveWorkExperiences
            .emit(to: Binder(self) { base, workExperience in
                base.workExperience = workExperience
            })
            .disposed(by: disposeBag)
        
        didSaveEducations
            .emit(to: Binder(self) { base, educations in
                base.educations = educations
            })
            .disposed(by: disposeBag)
        
        didSaveProfessionalSkills
            .emit(to: Binder(self) { base, professionalSkills in
                base.professionalSkills = professionalSkills
            })
            .disposed(by: disposeBag)
        
        didSaveLanguages
            .emit(to: Binder(self) { base, languages in
                base.languages = languages
            })
            .disposed(by: disposeBag)
        
        didSaveInterests
            .emit(to: Binder(self) { base, interests in
                base.interests = interests
            })
            .disposed(by: disposeBag)
        
        didSaveCertificates
            .emit(to: Binder(self) { base, certificates in
                base.certificates = certificates
            })
            .disposed(by: disposeBag)
        
        didSaveSocialMedia
            .emit(to: Binder(self) { base, socialMedia in
                base.socialMedia = socialMedia
            })
            .disposed(by: disposeBag)
        
        didSaveReferences
            .emit(to: Binder(self) { base, references in
                base.references = references
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CVMakerProfileGenerator {
    func make() -> Profile {
        Profile(
            generalInfo: generalInfo,
            workExperiences: workExperience,
            educations: educations,
            professionalSkills: professionalSkills,
            languages: languages,
            interests: interests,
            certificates: certificates,
            socialMedia: socialMedia,
            references: references
        )
    }
}
