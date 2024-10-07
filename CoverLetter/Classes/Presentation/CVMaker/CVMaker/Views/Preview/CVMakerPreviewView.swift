//
//  CVMakerPreviewView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMakerPreviewView: CVMakerFlowView {
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
extension CVMakerPreviewView {
    func setup(template: CVTemplate) {
        let imageName = "CVTemplate.\(template.identifier.rawValue + 1)"
        templateView.image = UIImage(named: imageName)
    }
}

// MARK: Private
private extension CVMakerPreviewView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension CVMakerPreviewView {
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
private extension CVMakerPreviewView {
    func makeCloseButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CVMaker.DeleteEntity2"), for: .normal)
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
        view.attributedText = "CVMaker.Preview.Title".localized.attributed(with: attrs)
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
        view.attributedText = "CVMaker.Preview.SubTitle".localized.attributed(with: attrs)
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
        view.setAttributedTitle("CVMaker.Preview.PreviewAction".localized.attributed(with: attrs), for: .normal)
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
        view.setAttributedTitle("CVMaker.Preview.ShareAction".localized.attributed(with: attrs), for: .normal)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
