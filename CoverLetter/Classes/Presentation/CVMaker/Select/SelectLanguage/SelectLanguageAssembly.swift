//
//  SelectLanguageAssembly.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class SelectLanguageAssembly {
    func startFlow(from vc: UIViewController, result: @escaping (String) -> Void) {
        let selectVC = SelectLanguageViewController.make { selectVC, isoLanguage in
            selectVC.navigationController?.dismiss(animated: true) {
                result(isoLanguage)
            }
        }
        let nc = NavigationController(rootViewController: selectVC)
        vc.present(nc, animated: true)
    }
}
