//
//  ProfileInfoCell.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift

final class ProfileInfoCell: UITableViewCell {
    var didDelete: (() -> Void)?
    
    lazy var container = makeContainer()
    lazy var photoView = makePhotoView()
    lazy var stackView = makeStackView()
    lazy var deleteButton = makeDeleteButton()
    
    private lazy var nameAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.extraBold(size: 19.scale))
        .textAlignment(.center)
        .lineHeight(26.scale)
    private lazy var jobTitleAttrs = TextAttributes()
        .textColor(Appearance.mono200)
        .font(Fonts.Nunito.semiBold(size: 15.scale))
        .textAlignment(.center)
        .lineHeight(20.scale)
    
    private lazy var disposeBag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileInfoCell {
    func setup(element: ProfileTableInfoElement) {
        if let photoFileName = element.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
            photoView.image = image
        } else {
            photoView.image = UIImage(named: "Profile.PhotoPlaceholder")
        }
        
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let name: String? = {
            let parts = [element.firstName, element.lastName].compactMap { $0 }.joined(separator: " ")
            return parts.isEmpty ? nil : parts
        }()
        if let name {
            add(text: name, attrs: nameAttrs)
        }
        
        if let jobTitle = element.jobTitle {
            add(text: jobTitle, attrs: jobTitleAttrs)
        }
        
        layoutIfNeeded()
    }
}

// MARK: Private
private extension ProfileInfoCell {
    func initialize() {
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        
        selectionStyle = .none
        
        deleteButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.didDelete?()
            })
            .disposed(by: disposeBag)
    }
    
    func add(text: String, attrs: TextAttributes) {
        let view = UILabel()
        view.attributedText = text.attributed(with: attrs)
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        stackView.addArrangedSubview(view)
    }
}

// MARK: Make constraints
private extension ProfileInfoCell {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16.scale),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16.scale),
            container.topAnchor.constraint(equalTo: contentView.topAnchor),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12.scale)
        ])
        
        NSLayoutConstraint.activate([
            photoView.widthAnchor.constraint(equalToConstant: 100.scale),
            photoView.heightAnchor.constraint(equalToConstant: 100.scale),
            photoView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            photoView.topAnchor.constraint(equalTo: container.topAnchor, constant: 20.scale)
        ])
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16.scale),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16.scale),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 128.scale),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -20.scale)
        ])
        
        NSLayoutConstraint.activate([
            deleteButton.widthAnchor.constraint(equalToConstant: 20.scale),
            deleteButton.heightAnchor.constraint(equalToConstant: 20.scale),
            deleteButton.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12.scale),
            deleteButton.topAnchor.constraint(equalTo: container.topAnchor, constant: 12.scale)
        ])
    }
}

// MARK: Lazy initialization
private extension ProfileInfoCell {
    func makeContainer() -> UIView {
        let view = UIView()
        view.layer.cornerRadius = 16.scale
        view.layer.shadowColor = Appearance.mono200.withAlphaComponent(0.4).cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 4.scale
        view.backgroundColor = Appearance.mono100
        view.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(view)
        return view
    }
    
    func makePhotoView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = 50.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeStackView() -> UIStackView {
        let view = UIStackView()
        view.backgroundColor = UIColor.clear
        view.axis = .vertical
        view.spacing = 4.scale
        view.distribution = .fill
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
    
    func makeDeleteButton() -> TapAreaButton {
        let view = TapAreaButton()
        view.setImage(UIImage(named: "CVMaker.DeleteEntity"), for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(view)
        return view
    }
}
