//
//  CVMICollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import UIKit

final class CVMICollectionView: UICollectionView {
    lazy var elements = [CVMICollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMICollectionView {
    func setup(elements: [CVMICollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CVMICollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .header:
            return dequeueReusableCell(withReuseIdentifier: String(describing: CVMICollectionHeaderCell.self), for: indexPath)
        case .interest(let interest):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CVMICollectionInterestCell.self), for: indexPath) as! CVMICollectionInterestCell
            cell.setup(element: interest)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CVMICollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case let .interest(interest) = elements[indexPath.row] else { return }
        interest.marked.toggle()
        
        reloadItems(at: [indexPath])
    }
}

// MARK: Private
private extension CVMICollectionView {
    func initialize() {
        register(CVMICollectionHeaderCell.self, forCellWithReuseIdentifier: String(describing: CVMICollectionHeaderCell.self))
        register(CVMICollectionInterestCell.self, forCellWithReuseIdentifier: String(describing: CVMICollectionInterestCell.self))
        
        dataSource = self
        delegate = self
    }
}
