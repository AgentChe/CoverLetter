//
//  CVMLCollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMLCollectionView: UICollectionView {
    var didAddLanguage: (() -> Void)?
    var didChangeLevel: ((Language) -> Void)?
    
    lazy var elements = [CVMLCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMLCollectionView {
    func setup(elements: [CVMLCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CVMLCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .title:
            return dequeueReusableCell(withReuseIdentifier: String(describing: CVMLCollectionHeaderCell.self), for: indexPath)
        case .add:
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CVMLCollectionAddCell.self), for: indexPath) as! CVMLCollectionAddCell
            cell.didTap = didAddLanguage
            return cell
        case .language(let language):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CVMLCollectionLanguageCell.self), for: indexPath) as! CVMLCollectionLanguageCell
            cell.setup(element: language)
            cell.didTapLevel = { [weak self] in
                self?.didChangeLevel?(language)
            }
            return cell
        }
    }
}

// MARK: Private
private extension CVMLCollectionView {
    func initialize() {
        register(CVMLCollectionHeaderCell.self, forCellWithReuseIdentifier: String(describing: CVMLCollectionHeaderCell.self))
        register(CVMLCollectionAddCell.self, forCellWithReuseIdentifier: String(describing: CVMLCollectionAddCell.self))
        register(CVMLCollectionLanguageCell.self, forCellWithReuseIdentifier: String(describing: CVMLCollectionLanguageCell.self))
        
        dataSource = self
    }
}
