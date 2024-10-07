//
//  ResumeGroupView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

//import UIKit
//
//final class ResumeGroupView: UIView {
//    lazy var collectionView = makeCollectionView()
//    lazy var addNewButton = makeAddNewButton()
//    lazy var shareButton = makeShareButton()
//    lazy var editButton = makeEditButton()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        
//        makeConstraints()
//        initialize()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//// MARK: Private
//private extension ResumeGroupView {
//    func initialize() {
//        backgroundColor = Appearance.main100
//    }
//}
//
//// MARK: Make constraints
//private extension ResumeGroupView {
//    func makeConstraints() {
//        NSLayoutConstraint.activate([
//            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            collectionView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
//            collectionView.bottomAnchor.constraint(equalTo: addNewButton.topAnchor)
//        ])
//        
//        NSLayoutConstraint.activate([
//            addNewButton.widthAnchor.constraint(equalToConstant: 221.scale),
//            addNewButton.heightAnchor.constraint(equalToConstant: 58.scale),
//            addNewButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
//            addNewButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -42.scale : -30.scale)
//        ])
//        
//        NSLayoutConstraint.activate([
//            shareButton.widthAnchor.constraint(equalToConstant: 52.scale),
//            shareButton.heightAnchor.constraint(equalToConstant: 58.scale),
//            shareButton.leadingAnchor.constraint(equalTo: addNewButton.trailingAnchor, constant: 10.scale),
//            shareButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -42.scale : -30.scale)
//        ])
//        
//        NSLayoutConstraint.activate([
//            editButton.widthAnchor.constraint(equalToConstant: 52.scale),
//            editButton.heightAnchor.constraint(equalToConstant: 58.scale),
//            editButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 10.scale),
//            editButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -42.scale : -30.scale)
//        ])
//    }
//}
//
//// MARK: Lazy initialization
//private extension ResumeGroupView {
//    func makeCollectionView() -> RSCollectionView {
//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 0
//        layout.minimumInteritemSpacing = 0
//        layout.scrollDirection = .horizontal
//        
//        let view = RSCollectionView(frame: .zero, collectionViewLayout: layout)
//        view.backgroundColor = UIColor.clear
//        view.isPagingEnabled = true
//        view.contentInset = UIEdgeInsets(vertical: 20.scale)
//        view.setContentOffset(CGPoint(x: 0, y: -20.scale), animated: false)
//        view.showsHorizontalScrollIndicator = false
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//    
//    func makeAddNewButton() -> UIButton {
//        let attrs = TextAttributes()
//            .textColor(Appearance.mono100)
//            .font(Fonts.Nunito.semiBold(size: 17.scale))
//        
//        let view = UIButton()
//        view.setAttributedTitle("ResumeGroup.AddNew".localized.attributed(with: attrs), for: .normal)
//        view.backgroundColor = Appearance.main200
//        view.layer.cornerRadius = 12.scale
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//    
//    func makeShareButton() -> UIButton {
//        let view = UIButton()
//        view.setImage(UIImage(named: "ResumeGroup.Share"), for: .normal)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//    
//    func makeEditButton() -> UIButton {
//        let view = UIButton()
//        view.setImage(UIImage(named: "ResumeGroup.Edit"), for: .normal)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(view)
//        return view
//    }
//}
