//
//  TabItemView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 07.10.2024.
//

import UIKit

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
        iconView.alpha = marked ? 1 : 0.2
    }
}

// MARK: Make constraints
private extension TabItemView {
    func makeConstraints() {
        let size = tab.iconSize
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: size.width),
            iconView.heightAnchor.constraint(equalToConstant: size.height),
            iconView.centerXAnchor.constraint(equalTo: centerXAnchor),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 7.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension TabItemView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.image = UIImage(named: tab.iconName)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}

// MARK: Additional
private extension TabView.Tab {
    var iconName: String {
        switch self {
        case .cls:
            return "Main.CLs"
        case .settings:
            return "Main.Settings"
        }
    }
    
    var iconSize: CGSize {
        switch self {
        case .cls:
            return CGSize(width: 18.scale, height: 23.scale)
        case .settings:
            return CGSize(width: 30.scale, height: 24.scale)
        }
    }
}
