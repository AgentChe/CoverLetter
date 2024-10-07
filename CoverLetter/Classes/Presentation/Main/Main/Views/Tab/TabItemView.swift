//
//  TabItemView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit

// TODO: add icons in assets
final class TabItemView: TapAreaButton {
    lazy var marked: Bool = false {
        didSet {
            update()
        }
    }
    
    lazy var iconView = makeImageView()
    
    private let tab: TabView.Tab
    
    init(tab: TabView.Tab) {
        self.tab = tab
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        update()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension TabItemView {
    func initialize() {
        backgroundColor = UIColor.clear
    }
    
    func update() {
        let (sName, dName) = tab.iconsNames
        
        iconView.image = UIImage(named: marked ? sName : dName)
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 24.scale),
            iconView.heightAnchor.constraint(equalToConstant: 24.scale),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension TabView.Tab {
    var iconsNames: (String, String) {
        switch self {
        case .cls:
            return ("Main.CLs.S", "Main.CLs.D")
        case .settings:
            return ("Main.Settings.S", "Main.Settings.D")
        }
    }
}
