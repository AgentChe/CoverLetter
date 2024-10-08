//
//  CLGroupCollectionView.swift
//  CoverLetter
//
//  Created by Андрей Чернышев on 08.10.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLGroupCollectionView: UICollectionView {
    private lazy var elements = [CL]()
    
    private lazy var didSelectCLTrigger = PublishRelay<CL>()
    private lazy var didMenuTapTrigger = PublishRelay<CL>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLGroupCollectionView {
    func setup(elements: [CL]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didSelectCL: Signal<CL> {
        didSelectCLTrigger.asSignal()
    }
    
    var didMenuTap: Signal<CL> {
        didMenuTapTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension CLGroupCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: CLGroupCollectionCell.self), for: indexPath) as! CLGroupCollectionCell
        cell.setup(element: elements[indexPath.row])
        cell.didMenuTap = { [weak self] in
            guard let self else { return }
            didMenuTapTrigger.accept(elements[indexPath.row])
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension CLGroupCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectCLTrigger.accept(elements[indexPath.row])
    }
}

// MARK: Private
private extension CLGroupCollectionView {
    func initialize() {
        register(CLGroupCollectionCell.self, forCellWithReuseIdentifier: String(describing: CLGroupCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
