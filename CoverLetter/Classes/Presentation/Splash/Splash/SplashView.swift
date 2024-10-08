//
//  SplashView.swift
//  Soccer
//
//  Created by Андрей Чернышев on 05.07.2022.
//

import UIKit

// TODO: animate
final class SplashView: UIView {
    lazy var imageView = makeImageView()
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
            imageView.widthAnchor.constraint(equalToConstant: 216.scale),
            imageView.heightAnchor.constraint(equalToConstant: 271.scale),
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 240.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloaderLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloaderLabel.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension SplashView {
    func makeImageView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "Splash.Image")
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
