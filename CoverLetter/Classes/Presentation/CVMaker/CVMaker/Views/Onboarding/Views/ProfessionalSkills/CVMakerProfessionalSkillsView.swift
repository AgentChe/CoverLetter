//
//  CVMakerProfessionalSkillsView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMakerProfessionalSkillsView: UIView {
    lazy var collectionView = makeCollectionView()
    lazy var continueButton = makeContinueButton()
    
    private weak var vc: UIViewController?
    private let bind: (([ProfessionalSkill]) -> Void)
    private let flowFinished: (() -> Void)
    
    private lazy var skills = [ProfessionalSkill]()
    
    private lazy var selectSkillAssembly = SelectProfessionalSkillAssembly()
    
    init(
        vc: UIViewController?,
        bind: @escaping (([ProfessionalSkill]) -> Void),
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
extension CVMakerProfessionalSkillsView {
    func setup(professionalSkills: [ProfessionalSkill]) {
        self.skills = professionalSkills
        
        reload()
    }
}

// MARK: Private
private extension CVMakerProfessionalSkillsView {
    func initialize() {
        collectionView.didAddSkill = { [weak self] in
            guard let self, let vc else { return }
            
            selectSkillAssembly.startFlow(from: vc) { [weak self] skill in
                guard let self else { return }
                
                self.skills.append(skill)
                self.reload()
            }
        }
        
        collectionView.didDeleteSkill = { [weak self] skill in
            guard let self else { return }
            
            self.skills.removeAll(where: { $0.name == skill.name })
            self.reload()
        }
    }
    
    func reload() {
        let elements: [CVMPSCollectionElement] = [.title] + skills.map { .skill($0) } + [.add(skills.isEmpty ? "CVMaker.ProfessionalSkills.AddSkiils".localized : "CVMaker.ProfessionalSkills.AddOneMore".localized)]
        collectionView.setup(elements: elements)
    }
    
    @objc
    func continueTapped() {
        bind(skills)
        flowFinished()
    }
}

// MARK: Make constraints
private extension CVMakerProfessionalSkillsView {
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
private extension CVMakerProfessionalSkillsView {
    func makeCollectionView() -> CVMPSCollectionView {
        let layout = CVMPSCollectionLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12.scale
        layout.minimumInteritemSpacing = 12.scale
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let view = CVMPSCollectionView(frame: .zero, collectionViewLayout: layout)
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
