//
//  CVMakerCraftingView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit
import Lottie

final class CVMakerCraftingView: CVMakerFlowView {
    lazy var container = makeContainer()
    lazy var animationView = makeAnimationView()
    lazy var label = makeLabel()
    
    private let finished: (() -> Void)
    
    init(finished: @escaping (() -> Void)) {
        self.finished = finished
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func moveToThis() {
        super.moveToThis()
        
        animationView.animation = LottieAnimation.named("CVMaker.Crafting.Animation")
        animationView.play { [weak self] result in
            self?.finished()
        }
    }
}

// MARK: Make constraints
private extension CVMakerCraftingView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: 130.scale)
        ])
        
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: 280.scale),
            animationView.heightAnchor.constraint(equalToConstant: 280.scale),
            animationView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            animationView.topAnchor.constraint(equalTo: container.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: animationView.bottomAnchor, constant: 32.scale),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerCraftingView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeAnimationView() -> LottieAnimationView {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .playOnce
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let titleAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Bitter.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        let subTitleAttrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
            .lineHeight(23.scale)
            .textAlignment(.center)
        
        let result = NSMutableAttributedString()
        result.append("CVMaker.Crafting.Title".localized.attributed(with: titleAttrs))
        result.append("CVMaker.Crafting.SubTitle".localized.attributed(with: subTitleAttrs))
        
        let view = UILabel()
        view.attributedText = result
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
