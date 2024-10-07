//
//  CVMPSCollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMPSCollectionView: UICollectionView {
    var didAddSkill: (() -> Void)?
    var didDeleteSkill: ((ProfessionalSkill) -> Void)?
    
    lazy var elements = [CVMPSCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMPSCollectionView {
    func setup(elements: [CVMPSCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CVMPSCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withReuseIdentifier: String(describing: CVMPSCollectionTitleCell.self), for: indexPath)
        case .add(let text):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CVMPSCollectionAddCell.self), for: indexPath) as! CVMPSCollectionAddCell
            cell.setup(text: text)
            cell.didTap = didAddSkill
            return cell
        case .skill(let skill):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CVMPSCollectionSkillCell.self), for: indexPath) as! CVMPSCollectionSkillCell
            cell.setup(element: skill)
            cell.didTapDelete = { [weak self] in
                self?.didDeleteSkill?(skill)
            }
            return cell
        }
    }
}

// MARK: Private
private extension CVMPSCollectionView {
    func initialize() {
        register(CVMPSCollectionTitleCell.self, forCellWithReuseIdentifier: String(describing: CVMPSCollectionTitleCell.self))
        register(CVMPSCollectionAddCell.self, forCellWithReuseIdentifier: String(describing: CVMPSCollectionAddCell.self))
        register(CVMPSCollectionSkillCell.self, forCellWithReuseIdentifier: String(describing: CVMPSCollectionSkillCell.self))
        
        dataSource = self
    }
}
