//
//  SelectProfessionalSkillView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class SelectProfessionalSkillView: UIView {
    lazy var searchField = makeSearchField()
    lazy var searchIconView = makeSearchIconView()
    lazy var tableView = makeTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: UITextFieldDelegate
extension SelectProfessionalSkillView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: Private
private extension SelectProfessionalSkillView {
    func initialize() {
        backgroundColor = Appearance.main100
    }
}

// MARK: Make constraints
private extension SelectProfessionalSkillView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            searchField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            searchField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            searchField.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10.scale)
        ])
        
        NSLayoutConstraint.activate([
            searchIconView.widthAnchor.constraint(equalToConstant: 16.scale),
            searchIconView.heightAnchor.constraint(equalToConstant: 16.scale),
            searchIconView.leadingAnchor.constraint(equalTo: searchField.leadingAnchor, constant: 8.scale),
            searchIconView.centerYAnchor.constraint(equalTo: searchField.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 15.scale),
            tableView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension SelectProfessionalSkillView {
    func makeSearchField() -> PaddingTextField {
        let placeholderAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 60, green: 60, blue: 67, alpha: 0.6))
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
            .letterSpacing(-0.3.scale)
        let textAttrs = TextAttributes()
            .textColor(UIColor(integralRed: 60, green: 60, blue: 67))
            .font(Fonts.SFPro.regular(size: 17.scale))
            .lineHeight(22.scale)
            .textAlignment(.left)
            .letterSpacing(-0.3.scale)
        
        let view = PaddingTextField()
        view.delegate = self
        view.returnKeyType = .done
        view.defaultTextAttributes = textAttrs.dictionary
        view.attributedPlaceholder = "SelectProfessionalSkill.Search".localized.attributed(with: placeholderAttrs)
        view.textPadding = UIEdgeInsets(t: 7.scale, l: 32.scale, b: 7.scale, r: 8.scale)
        view.backgroundColor = UIColor(integralRed: 118, green: 118, blue: 128, alpha: 0.12)
        view.layer.cornerRadius = 10.scale
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeSearchIconView() -> UIImageView {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        view.image = UIImage(named: "CVMaker.Search")
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeTableView() -> SelectProfessionalSkillTableView {
        let view = SelectProfessionalSkillTableView()
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.backgroundColor = UIColor.clear
        view.separatorInset = UIEdgeInsets(l: 16.scale)
        view.separatorColor = Appearance.mono200.withAlphaComponent(0.1)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
