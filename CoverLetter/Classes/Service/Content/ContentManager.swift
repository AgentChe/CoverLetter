//
//  ContentManager.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import RxSwift

protocol ContentManagerProtocol {
    func obtainCountries() -> Single<[Country]>
    func obtainCities(iso2: String) -> Single<[City]>
    func obtainProfessionalSkills() -> Single<[ProfessionalSkill]>
    func obtainLanguages() -> Single<ISOLanguages>
    func obtainInterests() -> Single<[Interest]>
}

final class ContentManager {
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: ContentManagerProtocol
extension ContentManager: ContentManagerProtocol {
    func obtainCountries() -> Single<[Country]> {
        restApiTransport
            .callServerApi(requestBody: GetCountriesRequest())
            .map { Country.map(from: $0) }
    }
    
    func obtainCities(iso2: String) -> Single<[City]> {
        let request = GetCitiesRequest(iso2: iso2)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { City.map(from: $0) }
    }
    
    func obtainProfessionalSkills() -> Single<[ProfessionalSkill]> {
        Single<[ProfessionalSkill]>.create { single in
            let result: [ProfessionalSkill] = {
                guard
                    let url = Bundle.main.url(forResource: "ProfessionalSkills", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let array = try? JSONDecoder().decode([String].self, from: data)
                else { return [] }
                
                return array.map { ProfessionalSkill(name: $0) }
            }()
            single(.success(result))
            
            return Disposables.create()
        }
    }
    
    func obtainLanguages() -> Single<ISOLanguages> {
        Single<ISOLanguages>.create { single in
            let result: ISOLanguages = {
                guard
                    let url = Bundle.main.url(forResource: "Languages", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
                else { return [] }
                
                return ISOLanguages.map(resourceJSON: json)
            }()
            single(.success(result))
            
            return Disposables.create()
        }
    }
    
    func obtainInterests() -> Single<[Interest]> {
        Single<[Interest]>.create { single in
            let result: [Interest] = {
                guard 
                    let url = Bundle.main.url(forResource: "Interests", withExtension: "json"),
                    let data = try? Data(contentsOf: url),
                    let array = try? JSONDecoder().decode([String].self, from: data)
                else { return [] }
                
                return array.map { Interest(name: $0) }
            }()
            single(.success(result))
            
            return Disposables.create()
        }
    }
}
