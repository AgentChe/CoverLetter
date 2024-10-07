//
//  RSCollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class RSCollectionView: UICollectionView {
    lazy var elements = [RSCollectionElement]()
    
    private lazy var didScrollToTrigger = PublishRelay<RSCollectionElement>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension RSCollectionView {
    func setup(elements: [RSCollectionElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didScrollTo: Signal<RSCollectionElement> {
        didScrollToTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension RSCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: RSCollectionCell.self), for: indexPath) as! RSCollectionCell
        cell.setup(element: elements[indexPath.row])
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension RSCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        bounds.size
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1)
        
        guard let element = elements[safe: page] else { return }
        
        didScrollToTrigger.accept(element)
    }
}

// MARK: Private
private extension RSCollectionView {
    func initialize() {
        register(RSCollectionCell.self, forCellWithReuseIdentifier: String(describing: RSCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
