//
//  SelectCityViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectCityViewController: UIViewController {
    private lazy var mainView = SelectCityView()
    
    private lazy var viewModel = SelectCityViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let flow: SelectCityViewModel.Flow
    private let selectedCountry: ((UIViewController, Country) -> Void)?
    private let completeFlow: ((UIViewController, SelectCityViewModel.FlowResult) -> Void)?
    
    private init(
        flow: SelectCityViewModel.Flow, 
        selectedCountry: ((UIViewController, Country) -> Void)?,
        completeFlow: ((UIViewController, SelectCityViewModel.FlowResult) -> Void)?
    ) {
        self.flow = flow
        self.selectedCountry = selectedCountry
        self.completeFlow = completeFlow
        
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
        
        let output = viewModel.configure(input: SelectCityViewModel.Input(
            flow: flow,
            filter: mainView.searchField.rx.text
                .compactMap { $0 }
                .asSignal(onErrorSignalWith: .never()),
            didSelect: mainView.tableView.didSelect
        ))
        
        output.activity
            .drive(Binder(mainView.preloader) { base, activity in
                activity ? base.startAnimating() : base.stopAnimating()
            })
            .disposed(by: disposeBag)
        
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
extension SelectCityViewController {
    static func make(
        flow: SelectCityViewModel.Flow = .selectCountry,
        selectedCountry: ((UIViewController, Country) -> Void)? = nil,
        completeFlow: ((UIViewController, SelectCityViewModel.FlowResult) -> Void)? = nil
    ) -> SelectCityViewController {
        let vc = SelectCityViewController(
            flow: flow,
            selectedCountry: selectedCountry,
            completeFlow: completeFlow
        )
        switch flow {
        case .selectCountry:
            vc.navigationItem.title = "SelectCity.Country".localized
        case .selectCity:
            vc.navigationItem.title = "SelectCity.City".localized
        }
        return vc
    }
}

// MARK: Private
private extension SelectCityViewController {
    func route(_ route: SelectCityViewModel.Route) {
        switch route {
        case .selectedCountry(let country):
            selectedCountry?(self, country)
        case .completeFlow(let flowResult):
            completeFlow?(self, flowResult)
        }
    }
}
