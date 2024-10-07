//
//  CVMGIPhotoContainer.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.05.2024.
//

import UIKit

final class CVMGIPhotoContainer: UIView {
    lazy var uploadPhotoButton = makeUploadPhotoButton()
    lazy var photoView = makePhotoView()
    lazy var deleteButton = makeDeleteButton()
    
    private lazy var dottedLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = Appearance.main200.cgColor
        shapeLayer.lineWidth = 2.scale
        shapeLayer.lineJoin = .round
        shapeLayer.lineDashPattern = [
            NSNumber(floatLiteral: 6.scale),
            NSNumber(floatLiteral: 3.scale)
        ]
        return shapeLayer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dottedLayer.bounds = bounds
        dottedLayer.position = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        dottedLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 12.scale).cgPath
    }
}

// MARK: Public
extension CVMGIPhotoContainer {
    func setup(photoFileName: String?) {
        if let photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
            dottedLayer.removeFromSuperlayer()
            uploadPhotoButton.isHidden = true
            photoView.image = image
            photoView.isHidden = false
            deleteButton.isHidden = false
        } else {
            layer.addSublayer(dottedLayer)
            uploadPhotoButton.isHidden = false
            photoView.image = nil
            photoView.isHidden = true
            deleteButton.isHidden = true
        }
    }
}

// MARK: Make constraints
private extension CVMGIPhotoContainer {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            uploadPhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            uploadPhotoButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            photoView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            photoView.topAnchor.constraint(equalTo: topAnchor),
            photoView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 36.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 36.scale),
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 12.scale),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension CVMGIPhotoContainer {
    func makeUploadPhotoButton() -> UIButton {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        let iconView = UIImageView()
        iconView.contentMode = .scaleAspectFit
        iconView.image = UIImage(named: "CVMaker.AddPhoto")
        iconView.clipsToBounds = true
        iconView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(iconView)
        
        NSLayoutConstraint.activate([
            iconView.widthAnchor.constraint(equalToConstant: 30.scale),
            iconView.heightAnchor.constraint(equalToConstant: 32.scale),
            iconView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            iconView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        let attrs = TextAttributes()
            .textColor(Appearance.main200)
            .font(Fonts.Nunito.semiBold(size: 17.scale))
            .lineHeight(23.19.scale)
            .textAlignment(.center)
        
        let label = UILabel()
        label.attributedText = "CVMaker.Photo.UploadPhoto".localized.attributed(with: attrs)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 36.scale),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        return view
    }
    
    func makePhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 12.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CVMaker.DeletePhoto"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
