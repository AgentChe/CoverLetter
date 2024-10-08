//
//  ClGroupMenuView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit

final class ClGroupMenuView: UIView {
    lazy var dimmedView = makeDimmedView()
    lazy var container = makeContainer()
    lazy var duplicateButton = makeButton(action: .duplicate)
    lazy var shareButton = makeButton(action: .share)
    lazy var deleteButton = makeButton(action: .delete)
    
    private lazy var containerYConstraint = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ClGroupMenuView {
    func animateShow() {
        containerYConstraint.isActive = false
        containerYConstraint = container.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0.6
            self?.layoutIfNeeded()
        })
    }
    
    func animateDismiss(completion: @escaping (() -> Void)) {
        containerYConstraint.isActive = false
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        containerYConstraint.isActive = true

        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.dimmedView.alpha = 0
            self?.layoutIfNeeded()
        }, completion: { result in
            completion()
        })
    }
}

// MARK: Make constraints
private extension ClGroupMenuView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            dimmedView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: trailingAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: bottomAnchor),
            dimmedView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        containerYConstraint = container.topAnchor.constraint(equalTo: bottomAnchor)
        NSLayoutConstraint.activate([
            containerYConstraint,
            container.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            duplicateButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            duplicateButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            duplicateButton.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            shareButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            shareButton.topAnchor.constraint(equalTo: duplicateButton.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            deleteButton.topAnchor.constraint(equalTo: shareButton.bottomAnchor),
            deleteButton.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension ClGroupMenuView {
    func makeDimmedView() -> UIView {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor.black
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor(integralRed: 223, green: 223, blue: 223)
        view.layer.cornerRadius = 12.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeButton(action: ClGroupMenuButton.Action) -> ClGroupMenuButton {
        let view = ClGroupMenuButton(action: action)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
