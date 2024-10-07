//
//  SelectProfessionalSkillAssembly.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class SelectProfessionalSkillAssembly {
    func startFlow(from vc: UIViewController, result: @escaping (ProfessionalSkill) -> Void) {
        let selectVC = SelectProfessionalSkillViewController.make { selectVC, skill in
            selectVC.navigationController?.dismiss(animated: true) {
                result(skill)
            }
        }
        let nc = NavigationController(rootViewController: selectVC)
        vc.present(nc, animated: true)
    }
}
