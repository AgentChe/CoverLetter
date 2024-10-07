//
//  ProfileManager.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import RxSwift

protocol ProfileManagerProtocol {
    func obtainProfile() -> Single<Profile>
    func set(generalInfo: GeneralInfo) -> Single<Void>
    func set(workExperiences: [WorkExperience]) -> Single<Void>
    func set(educations: [Education]) -> Single<Void>
    func set(professionalSkills: [ProfessionalSkill]) -> Single<Void>
    func set(languages: [Language]) -> Single<Void>
    func set(interests: [Interest]) -> Single<Void>
    func set(certificates: [Certificate]) -> Single<Void>
    func set(socialMedia: SocialMedia) -> Single<Void>
    func set(references: [Reference]) -> Single<Void>
    func delete(entity: ProfileManager.Entity) -> Single<Void>
    func deleteProfile() -> Single<Void>
}

final class ProfileManager {
    enum Entity: String {
        case generalInfo = "generalInfo"
        case workExperiences = "workExperience"
        case educations = "educations"
        case professionalSkills = "professionalSkills"
        case languages = "languages"
        case interests = "interests"
        case certificates = "certificates"
        case socialMedia = "socialMedia"
        case references = "references"
    }
}

// MARK: ProfileManagerProtocol
extension ProfileManager: ProfileManagerProtocol {
    func obtainProfile() -> Single<Profile> {
        Single<Profile>.create { [weak self] single in
            guard let self else {
                return Disposables.create()
            }
            
            let profile = Profile(
                generalInfo: cached(entity: .generalInfo),
                workExperiences: cached(entity: .workExperiences),
                educations: cached(entity: .educations),
                professionalSkills: cached(entity: .professionalSkills),
                languages: cached(entity: .languages),
                interests: cached(entity: .interests),
                certificates: cached(entity: .certificates),
                socialMedia: cached(entity: .socialMedia),
                references: cached(entity: .references)
            )
            
            single(.success(profile))
            
            return Disposables.create()
        }
    }
    
    func set(generalInfo: GeneralInfo) -> Single<Void> {
        store(object: generalInfo, entity: .generalInfo) { generalInfo in
            ProfileMediator.shared.change(generalInfo: generalInfo)
        }
    }
    
    func set(workExperiences: [WorkExperience]) -> Single<Void> {
        store(object: workExperiences, entity: .workExperiences) { workExperiences in
            ProfileMediator.shared.change(workExperiences: workExperiences)
        }
    }
    
    func set(educations: [Education]) -> Single<Void> {
        store(object: educations, entity: .educations) { educations in
            ProfileMediator.shared.change(educations: educations)
        }
    }
    
    func set(professionalSkills: [ProfessionalSkill]) -> Single<Void> {
        store(object: professionalSkills, entity: .professionalSkills) { professionalSkills in
            ProfileMediator.shared.change(professionalSkills: professionalSkills)
        }
    }
    
    func set(languages: [Language]) -> Single<Void> {
        store(object: languages, entity: .languages) { languages in
            ProfileMediator.shared.change(languages: languages)
        }
    }
    
    func set(interests: [Interest]) -> Single<Void> {
        store(object: interests, entity: .interests) { interests in
            ProfileMediator.shared.change(interests: interests)
        }
    }
    
    func set(certificates: [Certificate]) -> Single<Void> {
        store(object: certificates, entity: .certificates) { certificates in
            ProfileMediator.shared.change(certificates: certificates)
        }
    }
    
    func set(socialMedia: SocialMedia) -> Single<Void> {
        store(object: socialMedia, entity: .socialMedia) { socialMedia in
            ProfileMediator.shared.change(socialMedia: socialMedia)
        }
    }
    
    func set(references: [Reference]) -> Single<Void> {
        store(object: references, entity: .references) { references in
            ProfileMediator.shared.change(references: references)
        }
    }
    
    func delete(entity: ProfileManager.Entity) -> Single<Void> {
        Single<Void>.create { single in
            UserDefaults.standard.removeObject(forKey: entity.rawValue)
            
            single(.success(Void()))
            
            ProfileMediator.shared.delete(entity: entity)
            
            return Disposables.create()
        }
    }
    
    func deleteProfile() -> Single<Void> {
        Single<Void>.create { single in
            let userDefaults = UserDefaults.standard
            userDefaults.removeObject(forKey: Entity.generalInfo.rawValue)
            userDefaults.removeObject(forKey: Entity.workExperiences.rawValue)
            userDefaults.removeObject(forKey: Entity.educations.rawValue)
            userDefaults.removeObject(forKey: Entity.professionalSkills.rawValue)
            userDefaults.removeObject(forKey: Entity.languages.rawValue)
            userDefaults.removeObject(forKey: Entity.interests.rawValue)
            userDefaults.removeObject(forKey: Entity.certificates.rawValue)
            userDefaults.removeObject(forKey: Entity.socialMedia.rawValue)
            userDefaults.removeObject(forKey: Entity.references.rawValue)
            
            single(.success(Void()))
            
            ProfileMediator.shared.deleteProfile()
            
            return Disposables.create()
        }
    }
}

// MARK: Private
private extension ProfileManager {
    func store<T: Codable>(object: T, entity: Entity, notify: @escaping (T) -> Void) -> Single<Void> {
        Single<Void>.create { single in
            if let data = try? JSONEncoder().encode(object) {
                UserDefaults.standard.set(data, forKey: entity.rawValue)
            }
            
            single(.success(Void()))
            
            notify(object)
            
            return Disposables.create()
        }
    }
    
    func cached<T: Decodable>(entity: Entity) -> T? {
        guard let data = UserDefaults.standard.data(forKey: entity.rawValue) else {
            return nil
        }
        
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
