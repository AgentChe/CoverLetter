//
//  MainCoordinator.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit

final class MainCoordinator {
    weak var parentVC: MainViewController?
    
    lazy var clsAccount = NavigationController(rootViewController: CLsGroupsViewController.make())
    lazy var settingsVC = SettingsViewController.make()
    
    private var previousVC: UIViewController?
    
    init(parentVC: MainViewController) {
        self.parentVC = parentVC
    }
    
    func change(tab: TabView.Tab) {
        parentVC?.mainView.tabView.selectedTab = tab
        
        switch tab {
        case .cls:
            changeVC(on: clsAccount)
        case .settings:
            changeVC(on: settingsVC)
        }
    }
}

// MARK: Private
private extension MainCoordinator {
    func changeVC(on vc: UIViewController) {
        if let previousVC = self.previousVC {
            previousVC.willMove(toParent: nil)
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()
        }
    
        self.previousVC = vc
        
        guard let parentVC = self.parentVC else {
            return
        }
    
        parentVC.addChild(vc)
        vc.view.frame = parentVC.mainView.container.bounds
        parentVC.mainView.container.addSubview(vc.view)
        vc.willMove(toParent: parentVC)
    }
}
