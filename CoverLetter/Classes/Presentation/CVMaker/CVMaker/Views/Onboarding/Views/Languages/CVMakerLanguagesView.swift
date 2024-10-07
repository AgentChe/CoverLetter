//
//  CVMakerLanguagesView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMakerLanguagesView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var continueButton = makeContinueButton()
    
    private weak var vc: UIViewController?
    private let bind: (([Language]) -> Void)
    private let flowFinished: (() -> Void)
    
    private lazy var languages = [Language]()
    
    private lazy var selectLanguageAssembly = SelectLanguageAssembly()
    
    init(
        vc: UIViewController?,
        bind: @escaping (([Language]) -> Void),
        flowFinished: @escaping (() -> Void)
    ) {
        self.vc = vc
        self.bind = bind
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        reload()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerLanguagesView {
    func setup(languages: [Language]) {
        self.languages = languages
        
        reload()
    }
}

// MARK: Private
private extension CVMakerLanguagesView {
    func initialize() {
        collectionView.didAddLanguage = { [weak self] in
            guard let self, let vc else { return }
            
            selectLanguageAssembly.startFlow(from: vc) { [weak self] isoLanguage in
                guard let self else { return }
                
                let language = Language(name: isoLanguage, level: .beginner)
                self.languages.append(language)
                
                self.reload()
            }
        }
        
        collectionView.didChangeLevel = { [weak self] language in
            guard let self, let vc else { return }
            
            let alert = UIAlertController(title: "CVMaker.Languages.SelectLevel".localized, message: nil, preferredStyle: .actionSheet)
            
            func select(level: Language.Level) {
                if let index = languages.firstIndex(of: language) {
                    let newLanguage = Language(name: language.name, level: level)
                    languages[index] = newLanguage
                    
                    reload()
                }
            }
            
            let beginner = UIAlertAction(title: "Language.Beginner".localized, style: .default) { action in
                select(level: .beginner)
            }
            alert.addAction(beginner)
            
            let preIntermediate = UIAlertAction(title: "Language.PreIntermediate".localized, style: .default) { action in
                select(level: .preIntermediate)
            }
            alert.addAction(preIntermediate)
            
            let intermediate = UIAlertAction(title: "Language.Intermediate".localized, style: .default) { action in
                select(level: .intermediate)
            }
            alert.addAction(intermediate)
            
            let upperIntermediate = UIAlertAction(title: "Language.UpperIntermediate".localized, style: .default) { action in
                select(level: .upperIntermediate)
            }
            alert.addAction(upperIntermediate)
            
            let advanced = UIAlertAction(title: "Language.Advanced".localized, style: .default) { action in
                select(level: .advanced)
            }
            alert.addAction(advanced)
            
            let proficient = UIAlertAction(title: "Language.Proficient".localized, style: .default) { action in
                select(level: .proficient)
            }
            alert.addAction(proficient)
            
            let cancel = UIAlertAction(title: "Cancel".localized, style: .cancel)
            alert.addAction(cancel)
            
            vc.present(alert, animated: true)
        }
    }
    
    func reload() {
        let elements: [CVMLCollectionElement] = [.title] + languages.map { .language($0) } + [.add]
        collectionView.setup(elements: elements)
    }
    
    @objc
    func continueTapped() {
        bind(languages)
        flowFinished()
    }
}

// MARK: Make constraints
private extension CVMakerLanguagesView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
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
private extension CVMakerLanguagesView {
    func makeCollectionView() -> CVMLCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = CVMLCollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets(vertical: 32.scale, horizontal: 16.scale)
        view.setContentOffset(CGPoint(x: 0, y: -32.scale), animated: false)
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
