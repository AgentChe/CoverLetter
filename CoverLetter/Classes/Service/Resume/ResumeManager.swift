//
//  ResumeManager.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import RxSwift
import RxCocoa

protocol ResumeManagerProtocol {
    func obtainCVTemplates() -> Single<[CVTemplate]>
    func obtainCLTemplates() -> Single<[CLTemplate]>
    func obtainCVs() -> Single<[CV]>
    func obtainCLs() -> Single<[CL]>
    func obtainGroups() -> Single<[ResumeGroup]>
    func createCV(template: CVTemplate, profile: Profile) -> Single<CV>
    func createCL(template: CLTemplate, info: CLInfo) -> Single<CL>
    func removeCV(id: String) -> Single<Void>
    func removeCL(id: String) -> Single<Void>
    func removeGroup(id: String) -> Single<Void>
    func edit(cv: CV) -> Single<CV>
    func edit(cl: CL) -> Single<CL>
    func edit(resumeGroup: ResumeGroup) -> Single<ResumeGroup>
    func analyzeCL(qa: [[String: String]], resumeStyle: String?) -> Single<[CLTextBlock]>
}

final class ResumeManager {
    enum Constants {
        static let cvKey = "resume_manager_cv_key"
        static let clKey = "resume_manager_cl_key"
        static let groupKey = "resume_manager_group_key"
    }
    
    private lazy var restApiTransport = RestAPITransport()
}

// MARK: ResumeManagerProtocol
extension ResumeManager: ResumeManagerProtocol {
    func obtainCVTemplates() -> Single<[CVTemplate]> {
        Single<[CVTemplate]>.create { single in
            let templates: [CVTemplate] = [
                CVTemplate(identifier: .template1),
                CVTemplate(identifier: .template2),
                CVTemplate(identifier: .template3),
                CVTemplate(identifier: .template4),
                CVTemplate(identifier: .template5),
                CVTemplate(identifier: .template6),
                CVTemplate(identifier: .template7),
                CVTemplate(identifier: .template8),
                CVTemplate(identifier: .template9),
                CVTemplate(identifier: .template10),
                CVTemplate(identifier: .template11),
                CVTemplate(identifier: .template12),
                CVTemplate(identifier: .template13),
                CVTemplate(identifier: .template14),
                CVTemplate(identifier: .template15),
                CVTemplate(identifier: .template16)
            ]
            single(.success(templates))
            
            return Disposables.create()
        }
    }
    
    func obtainCLTemplates() -> Single<[CLTemplate]> {
        Single<[CLTemplate]>.create { single in
            let templates: [CLTemplate] = [
                CLTemplate(identifier: .template1),
                CLTemplate(identifier: .template2),
                CLTemplate(identifier: .template3),
                CLTemplate(identifier: .template4),
                CLTemplate(identifier: .template5),
                CLTemplate(identifier: .template6),
                CLTemplate(identifier: .template7)
            ]
            single(.success(templates))
            
            return Disposables.create()
        }
    }
    
    func obtainCVs() -> Single<[CV]> {
        Single<[CV]>.create { single in
            let cvs: [CV] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cvKey) else { return [] }
                let array = try? JSONDecoder().decode([CV].self, from: data)
                return array ?? []
            }()
            
            single(.success(cvs))
            
            return Disposables.create()
        }
    }
    
    func obtainCLs() -> Single<[CL]> {
        Single<[CL]>.create { single in
            let cls: [CL] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.clKey) else { return [] }
                let array = try? JSONDecoder().decode([CL].self, from: data)
                return array ?? []
            }()
            
            single(.success(cls))
            
            return Disposables.create()
        }
    }
    
    func obtainGroups() -> Single<[ResumeGroup]> {
        Single<[ResumeGroup]>.create { single in
            let groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            single(.success(groups))
            
            return Disposables.create()
        }
    }
    
    func createCV(template: CVTemplate, profile: Profile) -> Single<CV> {
        Single<CV>.create { single in
            var cvs: [CV] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cvKey) else { return [] }
                let array = try? JSONDecoder().decode([CV].self, from: data)
                return array ?? []
            }()
            
            let cv = CV(
                id: UUID().uuidString,
                template: template,
                profile: profile,
                created: Date(),
                edited: nil
            )
            cvs.append(cv)
            
            if let data = try? JSONEncoder().encode(cvs) {
                UserDefaults.standard.setValue(data, forKey: Constants.cvKey)
            }
            
            var groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let companyName = cv.profile.workExperiences?.last?.companyName ?? "ResumeGroup.DefaultName".localized
            
            if let index = groups.firstIndex(where: { $0.name == companyName }) {
                let group = groups[index]
                
                let newGroup = ResumeGroup(
                    id: group.id,
                    name: group.name,
                    cvs: group.cvs + [cv],
                    cls: group.cls
                )
                groups[index] = newGroup
            } else {
                let newGroup = ResumeGroup(
                    id: UUID().uuidString,
                    name: companyName,
                    cvs: [cv],
                    cls: []
                )
                groups.append(newGroup)
            }
            
            if let data = try? JSONEncoder().encode(groups) {
                UserDefaults.standard.setValue(data, forKey: Constants.groupKey)
            }
            
            single(.success(cv))
            
            ResumeMediator.shared.created(cv: cv)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func createCL(template: CLTemplate, info: CLInfo) -> Single<CL> {
        Single<CL>.create { single in
            var cls: [CL] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.clKey) else { return [] }
                let array = try? JSONDecoder().decode([CL].self, from: data)
                return array ?? []
            }()
            
            let cl = CL(
                id: UUID().uuidString,
                template: template,
                info: info,
                created: Date(),
                edited: nil
            )
            cls.append(cl)
            
            if let data = try? JSONEncoder().encode(cls) {
                UserDefaults.standard.setValue(data, forKey: Constants.clKey)
            }
            
            var groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let companyName = cl.info.company?.name ?? "ResumeGroup.DefaultName".localized
            
            if let index = groups.firstIndex(where: { $0.name == companyName }) {
                let group = groups[index]
                
                let newGroup = ResumeGroup(
                    id: group.id,
                    name: group.name,
                    cvs: group.cvs,
                    cls: group.cls + [cl]
                )
                groups[index] = newGroup
            } else {
                let newGroup = ResumeGroup(
                    id: UUID().uuidString,
                    name: companyName,
                    cvs: [],
                    cls: [cl]
                )
                groups.append(newGroup)
            }
            
            if let data = try? JSONEncoder().encode(groups) {
                UserDefaults.standard.setValue(data, forKey: Constants.groupKey)
            }
            
            single(.success(cl))
            
            ResumeMediator.shared.created(cl: cl)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func removeCV(id: String) -> Single<Void> {
        Single<Void>.create { single in
            var cvs: [CV] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cvKey) else { return [] }
                let array = try? JSONDecoder().decode([CV].self, from: data)
                return array ?? []
            }()
            
            cvs.removeAll(where: { $0.id == id })
            
            if let data = try? JSONEncoder().encode(cvs) {
                UserDefaults.standard.setValue(data, forKey: Constants.cvKey)
            }
            
            let groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let updatedGroups = groups
                .map { group -> ResumeGroup in
                    ResumeGroup(
                        id: group.id,
                        name: group.name,
                        cvs: group.cvs.filter { $0.id != id },
                        cls: group.cls
                    )
                }
                .filter { !($0.cvs.isEmpty && $0.cls.isEmpty) }
            
            if let data = try? JSONEncoder().encode(updatedGroups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(Void()))
            
            ResumeMediator.shared.removedCV(id: id)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func removeCL(id: String) -> Single<Void> {
        Single<Void>.create { single in
            var cls: [CL] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.clKey) else { return [] }
                let array = try? JSONDecoder().decode([CL].self, from: data)
                return array ?? []
            }()
            
            cls.removeAll(where: { $0.id == id })
            
            if let data = try? JSONEncoder().encode(cls) {
                UserDefaults.standard.setValue(data, forKey: Constants.clKey)
            }
            
            let groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let updatedGroups = groups
                .map { group -> ResumeGroup in
                    ResumeGroup(
                        id: group.id,
                        name: group.name,
                        cvs: group.cvs,
                        cls: group.cls.filter { $0.id != id }
                    )
                }
                .filter { !($0.cvs.isEmpty && $0.cls.isEmpty) }
            
            if let data = try? JSONEncoder().encode(updatedGroups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(Void()))
        
            ResumeMediator.shared.removedCL(id: id)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func removeGroup(id: String) -> Single<Void> {
        Single<Void>.create { single in
            var groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            guard let group = groups.first(where: { $0.id == id }) else {
                return Disposables.create()
            }
            
            var cvs: [CV] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cvKey) else { return [] }
                let array = try? JSONDecoder().decode([CV].self, from: data)
                return array ?? []
            }()
            
            var cls: [CL] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.clKey) else { return [] }
                let array = try? JSONDecoder().decode([CL].self, from: data)
                return array ?? []
            }()
            
            group.cvs.forEach { cv in
                cvs.removeAll(where: { $0.id == cv.id })
            }
            
            group.cls.forEach { cl in
                cls.removeAll(where: { $0.id == cl.id })
            }
            
            groups.removeAll(where: { $0.id == group.id })
            
            if let data = try? JSONEncoder().encode(cvs) {
                UserDefaults.standard.set(data, forKey: Constants.cvKey)
            }
            
            if let data = try? JSONEncoder().encode(cls) {
                UserDefaults.standard.set(data, forKey: Constants.clKey)
            }
            
            if let data = try? JSONEncoder().encode(groups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(Void()))
            
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func edit(cv: CV) -> Single<CV> {
        Single<CV>.create { single in
            var cvs: [CV] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.cvKey) else { return [] }
                let array = try? JSONDecoder().decode([CV].self, from: data)
                return array ?? []
            }()
            
            if let index = cvs.firstIndex(where: { $0.id == cv.id }) {
                cvs[index] = cv
            }
            
            if let data = try? JSONEncoder().encode(cvs) {
                UserDefaults.standard.setValue(data, forKey: Constants.cvKey)
            }
            
            let groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let updatedGroups = groups
                .map { group -> ResumeGroup in
                    let cvs = group.cvs.map { item -> CV in
                        item.id == cv.id ? cv : item
                    }
                    return ResumeGroup(
                        id: group.id,
                        name: group.name,
                        cvs: cvs,
                        cls: group.cls
                    )
                }
                .filter { !($0.cvs.isEmpty && $0.cls.isEmpty) }
            
            if let data = try? JSONEncoder().encode(updatedGroups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(cv))
            
            ResumeMediator.shared.edit(cv: cv)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func edit(cl: CL) -> Single<CL> {
        Single<CL>.create { single in
            var cls: [CL] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.clKey) else { return [] }
                let array = try? JSONDecoder().decode([CL].self, from: data)
                return array ?? []
            }()
            
            if let index = cls.firstIndex(where: { $0.id == cl.id }) {
                cls[index] = cl
            }
            
            if let data = try? JSONEncoder().encode(cls) {
                UserDefaults.standard.setValue(data, forKey: Constants.clKey)
            }
            
            let groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            let updatedGroups = groups
                .map { group -> ResumeGroup in
                    let cls = group.cls.map { item -> CL in
                        item.id == cl.id ? cl : item
                    }
                    return ResumeGroup(
                        id: group.id,
                        name: group.name,
                        cvs: group.cvs,
                        cls: cls
                    )
                }
                .filter { !($0.cvs.isEmpty && $0.cls.isEmpty) }
            
            if let data = try? JSONEncoder().encode(updatedGroups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(cl))
            
            ResumeMediator.shared.edit(cl: cl)
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func edit(resumeGroup: ResumeGroup) -> Single<ResumeGroup> {
        Single<ResumeGroup>.create { single in
            var groups: [ResumeGroup] = {
                guard let data = UserDefaults.standard.data(forKey: Constants.groupKey) else { return [] }
                let array = try? JSONDecoder().decode([ResumeGroup].self, from: data)
                return array ?? []
            }()
            
            if let index = groups.firstIndex(where: { $0.id == resumeGroup.id }) {
                groups[index] = resumeGroup
            }
            
            if let data = try? JSONEncoder().encode(groups) {
                UserDefaults.standard.set(data, forKey: Constants.groupKey)
            }
            
            single(.success(resumeGroup))
            
            ResumeMediator.shared.changedGroups()
            
            return Disposables.create()
        }
    }
    
    func analyzeCL(qa: [[String: String]], resumeStyle: String?) -> Single<[CLTextBlock]> {
        let request = CLAssistantAnalyzeRequest(qa: qa, resumeStyle: resumeStyle)
        
        return restApiTransport
            .callServerApi(requestBody: request)
            .map { CLTextBlock.map(response: $0) }
    }
}
