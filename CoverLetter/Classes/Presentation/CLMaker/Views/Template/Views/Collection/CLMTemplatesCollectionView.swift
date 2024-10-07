//
//  CLMTemplatesCollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMTemplatesCollectionView: UICollectionView {
    lazy var elements = [CLMTemplatesCollectionElement]()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMTemplatesCollectionView {
    func setup(elements: [CLMTemplatesCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
}

// MARK: UICollectionViewDataSource
extension CLMTemplatesCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch elements[indexPath.row] {
        case .header:
            return dequeueReusableCell(withReuseIdentifier: String(describing: CLMTemplatesCollectionHeaderCell.self), for: indexPath)
        case .template(let element):
            let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CLMTemplatesCollectionCell.self), for: indexPath) as! CLMTemplatesCollectionCell
            cell.setup(element: element)
            return cell
        }
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CLMTemplatesCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard case let .template(selectedElement) = elements[indexPath.row] else { return }
        
        elements.forEach { element in
            guard case let .template(iterationElement) = element else { return }
            iterationElement.marked = false
            
            selectedElement.marked = true
        }
        
        reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch elements[indexPath.row] {
        case .header:
            return CGSize(width: 360.scale, height: 111.scale)
        case .template:
            return CGSize(width: 172.scale, height: 242.scale)
        }
    }
}

// MARK: Private
private extension CLMTemplatesCollectionView {
    func initialize() {
        register(CLMTemplatesCollectionHeaderCell.self, forCellWithReuseIdentifier: String(describing: CLMTemplatesCollectionHeaderCell.self))
        register(CLMTemplatesCollectionCell.self, forCellWithReuseIdentifier: String(describing: CLMTemplatesCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
