//
//  ProfileTableView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class ProfileTableView: UITableView {
    lazy var elements = [ProfileTableElement]()
    
    private lazy var didDeleteTrigger = PublishRelay<Void>()
    private lazy var didSelectTrigger = PublishRelay<ProfileTableCVMakerChapterElement>()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension ProfileTableView {
    func setup(elements: [ProfileTableElement]) {
        self.elements = elements
        
        reloadData()
    }
    
    var didDelete: Signal<Void> {
        didDeleteTrigger.asSignal()
    }
    
    var didSelect: Signal<ProfileTableCVMakerChapterElement> {
        didSelectTrigger.asSignal()
    }
}

// MARK: UITableViewDataSource
extension ProfileTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch elements[indexPath.row] {
        case .info(let info):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileInfoCell.self), for: indexPath) as! ProfileInfoCell
            cell.setup(element: info)
            cell.didDelete = { [weak self] in
                self?.didDeleteTrigger.accept(Void())
            }
            return cell
        case .cvMakerChapter(let chapter):
            let cell = dequeueReusableCell(withIdentifier: String(describing: ProfileCVMakerChapterCell.self), for: indexPath) as! ProfileCVMakerChapterCell
            cell.setup(element: chapter)
            return cell
        }
    }
}

// MARK: UITableViewDelegate
extension ProfileTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard case let .cvMakerChapter(chapter) = elements[indexPath.row] else { return }
        
        didSelectTrigger.accept(chapter)
    }
}

// MARK: Private
private extension ProfileTableView {
    func initialize() {
        register(ProfileInfoCell.self, forCellReuseIdentifier: String(describing: ProfileInfoCell.self))
        register(ProfileCVMakerChapterCell.self, forCellReuseIdentifier: String(describing: ProfileCVMakerChapterCell.self))
        
        dataSource = self
        delegate = self
    }
}
