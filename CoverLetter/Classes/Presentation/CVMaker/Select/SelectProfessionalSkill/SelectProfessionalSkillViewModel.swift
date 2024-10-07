//
//  SelectProfessionalSkillViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import RxSwift
import RxCocoa

final class SelectProfessionalSkillViewModel {
    enum Route {
        case selected(ProfessionalSkill)
    }
    
    private lazy var contentManager = ContentManager()
}

// MARK: Public
extension SelectProfessionalSkillViewModel {
    struct Input {
        let filter: Signal<String>
        let didSelect: Signal<ProfessionalSkill>
    }
    
    struct Output {
        let skills: Driver<[ProfessionalSkill]>
        let route: Driver<Route>
    }
    
    func configure(input: Input) -> Output {
        Output(
            skills: makeSkills(filter: input.filter),
            route: makeRoute(didSelect: input.didSelect)
        )
    }
}

// MARK: Private
private extension SelectProfessionalSkillViewModel {
    func makeSkills(filter: Signal<String>) -> Driver<[ProfessionalSkill]> {
        let skills = contentManager
            .obtainProfessionalSkills()
            .asSignal(onErrorJustReturn: [])
        
        return Signal
            .combineLatest(skills, filter) { skills, filter -> [ProfessionalSkill] in
                guard !filter.isEmpty else { return skills }
                
                return skills.filter { $0.name.range(of: filter, options: .caseInsensitive) != nil }
            }
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(didSelect: Signal<ProfessionalSkill>) -> Driver<Route> {
        didSelect
            .map { Route.selected($0) }
            .asDriver(onErrorDriveWith: .never())
    }
}
