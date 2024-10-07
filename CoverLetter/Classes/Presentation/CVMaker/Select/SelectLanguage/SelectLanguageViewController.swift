//
//  SelectLanguageViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit
import RxSwift

final class SelectLanguageViewController: UIViewController {
    private lazy var mainView = SelectLanguageView()
    
    private lazy var viewModel = SelectLanguageViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let select: (SelectLanguageViewController, String) -> Void
    
    private init(select: @escaping (SelectLanguageViewController, String) -> Void) {
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
        
        let output = viewModel.configure(input: SelectLanguageViewModel.Input(
            filter: mainView.searchField.rx.text.compactMap { $0 }.asSignal(onErrorSignalWith: .never()),
            didSelect: mainView.tableView.didSelect
        ))
        
        output.elements
            .drive(Binder(mainView.tableView) { base, elements in
                base.setup(elements: elements)
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
extension SelectLanguageViewController {
    static func make(select: @escaping (SelectLanguageViewController, String) -> Void) -> SelectLanguageViewController {
        let vc = SelectLanguageViewController(select: select)
        vc.navigationItem.title = "SelectLanguage.Title".localized
        return vc
    }
}

// MARK: Private
private extension SelectLanguageViewController {
    func route(_ route: SelectLanguageViewModel.Route) {
        switch route {
        case .selected(let isoLanguage):
            select(self, isoLanguage)
        }
    }
}
