//
//  CVMakerGeneralInfoPhotoView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

protocol CVMakerGeneralInfoPhotoViewDelegate: AnyObject {
    func generalInfo(photoFileName: String?)
}

final class CVMakerGeneralInfoPhotoView: CVMakerGeneralInfoFlowView {
    lazy var titleLabel = makeTitleLabel()
    lazy var subTitleLabel = makeSubTitleLabel()
    lazy var photoView = makePhotoView()
    lazy var continueButton = makeContinueButton()
    
    private lazy var imagePicker: ImagePicker? = {
        guard let vc else { return nil }
        
        return ImagePicker(presentationController: vc, delegate: self)
    }()
    
    private var photoFileName: String?
    
    private weak var vc: UIViewController?
    private weak var mainDelegate: CVMakerGeneralInfoPhotoViewDelegate?
    
    init(
        vc: UIViewController?,
        mainDelegate: CVMakerGeneralInfoPhotoViewDelegate?
    ) {
        self.vc = vc
        self.mainDelegate = mainDelegate
        
        super.init(step: .photo)
        
        makeConstraints()
        setup(photoFileName: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: ImagePickerDelegate
extension CVMakerGeneralInfoPhotoView: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        guard
            let image,
            let filePath = DocumentsDirectory.saveImageToDocumentsDirectory(image: image, fileName: DocumentsDirectory.ReserveNames.cvPhoto)
        else {
            return
        }
        
        let fileName = filePath.lastPathComponent
        setup(photoFileName: fileName)
    }
}

// MARK: Public
extension CVMakerGeneralInfoPhotoView {
    func setup(photoFileName: String?) {
        self.photoFileName = photoFileName
        
        photoView.setup(photoFileName: photoFileName)
    }
}

// MARK: Private
private extension CVMakerGeneralInfoPhotoView {
    @objc
    func uploadTapped() {
        imagePicker?.present(from: self)
    }
    
    @objc
    func deleteTapped() {
        setup(photoFileName: nil)
        DocumentsDirectory.deleteImageFromDocumentsDirectory(fileName: DocumentsDirectory.ReserveNames.cvPhoto)
    }
    
    @objc
    func continueTapped() {
        mainDelegate?.generalInfo(photoFileName: photoFileName)
        
        onNext()
    }
}

// MARK: Make constraints
private extension CVMakerGeneralInfoPhotoView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12.scale)
        ])
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            photoView.topAnchor.constraint(equalTo: subTitleLabel.bottomAnchor, constant: 32.scale),
            photoView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMakerGeneralInfoPhotoView {
    func makeTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.bold(size: 30.scale))
            .lineHeight(34.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CVMaker.Photo.Title".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSubTitleLabel() -> UILabel {
        let attrs = TextAttributes()
            .textColor(Appearance.mono200)
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(20.29.scale)
            .textAlignment(.center)
        
        let view = UILabel()
        view.numberOfLines = 0
        view.attributedText = "CVMaker.Photo.SubTitle".localized.attributed(with: attrs)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePhotoView() -> CVMGIPhotoContainer {
        let view = CVMGIPhotoContainer()
        view.uploadPhotoButton.addTarget(self, action: #selector(uploadTapped), for: .touchUpInside)
        view.deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 12.scale
        view.backgroundColor = Appearance.main200
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
