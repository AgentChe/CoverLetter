//
//  CLMakerPreviewView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMakerPreviewView: CLMakerFlowView {
    lazy var closeButton = makeCloseButton()
    lazy var templateView = makeTemplateView()
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var previewButton = makePreviewButton()
    lazy var shareButton = makeShareButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerPreviewView {
    func setup(template: CLTemplate) {
        let imageName = "CLTemplate.\(template.identifier.rawValue + 1)"
        templateView.image = UIImage(named: imageName)
    }
}

// MARK: Private
private extension CLMakerPreviewView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension CLMakerPreviewView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            closeButton.widthAnchor.constraint(equalToConstant: 16.scale),
            closeButton.heightAnchor.constraint(equalToConstant: 16.scale),
            closeButton.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 12.scale),
            closeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            templateView.widthAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 301.scale : 240.8.scale),
            templateView.heightAnchor.constraint(equalToConstant: ScreenSize.isIphoneXFamily ? 426.scale : 340.8.scale),
            templateView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 43.scale),
            templateView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: templateView.bottomAnchor, constant: 40.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.scale)
        ])
        
        NSLayoutConstraint.activate([
            previewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            previewButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            previewButton.heightAnchor.constraint(equalToConstant: 58.scale),
            previewButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            shareButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            shareButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            shareButton.heightAnchor.constraint(equalToConstant: 58.scale),
            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerPreviewView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CLMaker.Close"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTemplateView() -> UIImageView {
        let view = UIImageView()
        view.layer.cornerRadius = 24.scale
        view.layer.masksToBounds = true
        view.contentMode = .scaleAspectFill
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.Bitter.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CLMaker.Preview.Title".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.attributedText = "CLMaker.Preview.SubTitle".localized.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreviewButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CLMaker.Preview.Preview".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.main200
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeShareButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("CLMaker.Preview.Share".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
