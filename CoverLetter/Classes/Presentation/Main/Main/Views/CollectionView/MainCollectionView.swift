//
//  MainCollectionView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class MainCollectionView: UICollectionView {
    lazy var elements = [ResumeGroup]()
    
    private lazy var didTapMenuTrigger = PublishRelay<ResumeGroup>()
    private lazy var didSelectTrigger = PublishRelay<ResumeGroup>()
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension MainCollectionView {
    func setup(elements: [ResumeGroup]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didTapMenu: Signal<ResumeGroup> {
        didTapMenuTrigger.asSignal()
    }
    
    var didSelect: Signal<ResumeGroup> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UICollectionViewDataSource
extension MainCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        elements.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionCell.self), for: indexPath) as! MainCollectionCell
        cell.setup(resumeGroup: elements[indexPath.row])
        cell.didTapMenu = { [weak self] in
            guard let self else { return }
            didTapMenuTrigger.accept(elements[indexPath.row])
        }
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension MainCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let element = elements[indexPath.row]
        didSelectTrigger.accept(element)
    }
}

// MARK: Private
private extension MainCollectionView {
    func initialize() {
        register(MainCollectionCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionCell.self))
        
        dataSource = self
        delegate = self
    }
}
