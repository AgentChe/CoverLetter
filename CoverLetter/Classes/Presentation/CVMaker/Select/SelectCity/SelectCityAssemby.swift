//
//  SelectCityAssemby.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class SelectCityAssemby {
    func startFlow(from vc: UIViewController, result: @escaping ((SelectCityViewModel.FlowResult) -> Void)) {
        let selectCountryVC = SelectCityViewController.make(flow: .selectCountry, selectedCountry: { selectCountryVC, country in
            let selectCityVC = SelectCityViewController.make(flow: .selectCity(country), completeFlow: { selectCityVC, flowResult in
                selectCityVC.navigationController?.dismiss(animated: true) {
                    result(flowResult)
                }
            })
            selectCountryVC.navigationController?.pushViewController(selectCityVC, animated: true)
        })
        let nc = NavigationController(rootViewController: selectCountryVC)
        vc.present(nc, animated: true)
    }
}
