//
//  SelectProfessionalSkillViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit
import RxSwift

final class SelectProfessionalSkillViewController: UIViewController {
    private lazy var mainView = SelectProfessionalSkillView()
    
    private lazy var viewModel = SelectProfessionalSkillViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let select: ((SelectProfessionalSkillViewController, ProfessionalSkill) -> Void)
    
    private init(select: @escaping (SelectProfessionalSkillViewController, ProfessionalSkill) -> Void) {
        self.select = select
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let output = viewModel.configure(input: SelectProfessionalSkillViewModel.Input(
            filter: mainView.searchField.rx.text.compactMap { $0 }.asSignal(onErrorSignalWith: .never()),
            didSelect: mainView.tableView.didSelect
        ))
        
        output.skills
            .drive(Binder(mainView.tableView) { base, skills in
                base.setup(elements: skills)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension SelectProfessionalSkillViewController {
    static func make(select: @escaping (SelectProfessionalSkillViewController, ProfessionalSkill) -> Void) -> SelectProfessionalSkillViewController {
        let vc = SelectProfessionalSkillViewController(select: select)
        vc.navigationItem.title = "SelectProfessionalSkill.Title".localized
        return vc
    }
}

// MARK: Private
private extension SelectProfessionalSkillViewController {
    func route(_ route: SelectProfessionalSkillViewModel.Route) {
        switch route {
        case .selected(let professionalSkill):
            select(self, professionalSkill)
        }
    }
}
