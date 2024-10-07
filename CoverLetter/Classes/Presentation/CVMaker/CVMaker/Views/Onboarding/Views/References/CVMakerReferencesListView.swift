//
//  CVMakerReferencesListView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMakerReferencesListView: UIView {
    lazy var tableView = makeTableView()
    lazy var continueButton = makeContinueButton()
    
    private let didDelete: ((CVMakerReferencesListView, Reference) -> Void)
    private let didAddMore: (CVMakerReferencesListView) -> Void
    private let didContinue: () -> Void
    
    init(
        didDelete: @escaping ((CVMakerReferencesListView, Reference) -> Void),
        didAddMore: @escaping (CVMakerReferencesListView) -> Void,
        didContinue: @escaping () -> Void
    ) {
        self.didDelete = didDelete
        self.didAddMore = didAddMore
        self.didContinue = didContinue
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerReferencesListView {
    func setup(references: [Reference]) {
        let elements: [CVMRTableElement] = [.title] + references.map { .reference($0) } + [.addMore]
        tableView.setup(elements: elements)
    }
}

// MARK: Private
private extension CVMakerReferencesListView {
    func initialize() {
        tableView.didDelete = { [weak self] reference in
            guard let self else { return }
            
            self.didDelete(self, reference)
        }
        
        tableView.didAddMore = { [weak self] in
            guard let self else { return }
            
            self.didAddMore(self)
        }
    }
    
    @objc
    func continueTapped() {
        didContinue()
    }
}

// MARK: Make constraints
private extension CVMakerReferencesListView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: topAnchor),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
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
private extension CVMakerReferencesListView {
    func makeTableView() -> CVMRTableView {
        let view = CVMRTableView()
        view.backgroundColor = UIColor.clear
        view.separatorStyle = .none
        view.showsVerticalScrollIndicator = false
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
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
