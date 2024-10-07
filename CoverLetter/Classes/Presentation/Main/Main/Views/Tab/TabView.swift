//
//  TabView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit

final class TabView: UIView {
    enum Tab {
        case cls, settings
    }
    
    lazy var clsButton = makeButton(tab: .cls)
    lazy var settingsButton = makeButton(tab: .settings)
    
    var selectedTab = Tab.cls {
        didSet {
            update()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabView {
    func update() {
        clsButton.marked = selectedTab == .cls
        settingsButton.marked = selectedTab == .settings
    }
}

// MARK: Make constraints
private extension TabView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            clsButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            clsButton.trailingAnchor.constraint(equalTo: centerXAnchor),
            clsButton.topAnchor.constraint(equalTo: topAnchor),
            clsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            settingsButton.leadingAnchor.constraint(equalTo: centerXAnchor),
            settingsButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            settingsButton.topAnchor.constraint(equalTo: topAnchor),
            settingsButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension TabView {
    func makeButton(tab: Tab) -> TabItemView {
        let view = TabItemView(tab: tab)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
