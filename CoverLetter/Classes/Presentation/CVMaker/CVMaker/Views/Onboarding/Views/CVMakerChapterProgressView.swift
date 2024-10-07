//
//  CVMakerChapterProgressView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class CVMakerChapterProgressView: UIView {
    var back: (() -> Void)?
    
    lazy var backButton = makeBackButton()
    lazy var label = makeLabel()
    lazy var progressView = makeProgressView()
    
    private lazy var attrs = TextAttributes()
        .textColor(Appearance.main300)
        .font(Fonts.SFPro.regular(size: 17.scale))
        .lineHeight(20.29.scale)
        .textAlignment(.center)
    
    private let count: Int
    
    init(count: Int) {
        self.count = count
        
        super.init(frame: .zero)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerChapterProgressView {
    func setup(step: Int) {
        let title = String(format: "SelectCity.Progress".localized, step, count)
        label.attributedText = title.attributed(with: attrs)
        
        progressView.progress = Float(step) / Float(count)
    }
}

// MARK: Private
private extension CVMakerChapterProgressView {
    @objc
    func backTapped() {
        back?()
    }
}

// MARK: Make constraints
private extension CVMakerChapterProgressView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            backButton.widthAnchor.constraint(equalToConstant: 13.scale),
            backButton.heightAnchor.constraint(equalToConstant: 22.scale),
            backButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            backButton.centerYAnchor.constraint(equalTo: label.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: 2.scale),
            progressView.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale),
            progressView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerChapterProgressView {
    func makeBackButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CVMaker.Back"), for: .normal)
        view.addTarget(self, action: #selector(backTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeLabel() -> UILabel {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeProgressView() -> UIProgressView {
        let view = UIProgressView()
        view.trackTintColor = Appearance.main300.withAlphaComponent(0.2)
        view.progressTintColor = Appearance.main300
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
