//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit
import Lottie

final class SplashView: UIView {
    lazy var animateView = makeAnimateView()
    lazy var preloaderLabel = makePreloaderLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Private
private extension SplashView {
    func initialize() {
        backgroundColor = Appearance.custom_ed6f00
    }
}

// MARK: Make constraints
private extension SplashView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            animateView.widthAnchor.constraint(equalToConstant: 216.scale),
            animateView.heightAnchor.constraint(equalToConstant: 271.scale),
            animateView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animateView.topAnchor.constraint(equalTo: topAnchor, constant: 240.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloaderLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeAnimateView() -> LottieAnimationView {
        let view = LottieAnimationView()
        view.contentMode = .scaleAspectFit
        view.loopMode = .loop
        view.animation = LottieAnimation.named("Splash.Animate")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloaderLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.SFPro.semiBold(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "Splash.Preloader".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
