//
//  ResumeMediator.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import RxSwift
import RxCocoa

final class ResumeMediator {
    static let shared = ResumeMediator()
    
    private lazy var didCreadtedCLTrigger = PublishRelay<CL>()
    private lazy var didChangedGroupsTrigger = PublishRelay<Void>()
    private lazy var didRemovedCLTrigger = PublishRelay<String>()
    private lazy var didEditedCLTrigger = PublishRelay<CL>()
    private lazy var didEditedGroupTrigger = PublishRelay<ResumeGroup>()
    
    private init() {}
}

// MARK: Public
extension ResumeMediator {
    func created(cl: CL) {
        didCreadtedCLTrigger.accept(cl)
    }
    
    func changedGroups() {
        didChangedGroupsTrigger.accept(Void())
    }
    
    func removedCL(id: String) {
        didRemovedCLTrigger.accept(id)
    }
    
    func edit(cl: CL) {
        didEditedCLTrigger.accept(cl)
    }
    
    func edited(group: ResumeGroup) {
        didEditedGroupTrigger.accept(group)
    }
    
    var didCreadtedCL: Signal<CL> {
        didCreadtedCLTrigger.asSignal()
    }
    
    var didChangedGroups: Signal<Void> {
        didChangedGroupsTrigger.asSignal()
    }
    
    var didRemovedCL: Signal<String> {
        didRemovedCLTrigger.asSignal()
    }
    
    var didEditedCL: Signal<CL> {
        didEditedCLTrigger.asSignal()
    }
    
    var didEditedGroup: Signal<ResumeGroup> {
        didEditedGroupTrigger.asSignal()
    }
}
