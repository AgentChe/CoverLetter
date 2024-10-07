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
    
    private lazy var didCreadtedCVTrigger = PublishRelay<CV>()
    private lazy var didCreadtedCLTrigger = PublishRelay<CL>()
    private lazy var didChangedGroupsTrigger = PublishRelay<Void>()
    private lazy var didRemovedCVTrigger = PublishRelay<String>()
    private lazy var didRemovedCLTrigger = PublishRelay<String>()
    private lazy var didEditedCVTrigger = PublishRelay<CV>()
    private lazy var didEditedCLTrigger = PublishRelay<CL>()
    private lazy var didEditedGroupTrigger = PublishRelay<ResumeGroup>()
    
    private init() {}
}

// MARK: Public
extension ResumeMediator {
    func created(cv: CV) {
        didCreadtedCVTrigger.accept(cv)
    }
    
    func created(cl: CL) {
        didCreadtedCLTrigger.accept(cl)
    }
    
    func changedGroups() {
        didChangedGroupsTrigger.accept(Void())
    }
    
    func removedCV(id: String) {
        didRemovedCVTrigger.accept(id)
    }
    
    func removedCL(id: String) {
        didRemovedCLTrigger.accept(id)
    }
    
    func edit(cv: CV) {
        didEditedCVTrigger.accept(cv)
    }
    
    func edit(cl: CL) {
        didEditedCLTrigger.accept(cl)
    }
    
    func edited(group: ResumeGroup) {
        didEditedGroupTrigger.accept(group)
    }
    
    var didCreadtedCV: Signal<CV> {
        didCreadtedCVTrigger.asSignal()
    }
    
    var didCreadtedCL: Signal<CL> {
        didCreadtedCLTrigger.asSignal()
    }
    
    var didChangedGroups: Signal<Void> {
        didChangedGroupsTrigger.asSignal()
    }
    
    var didRemovedCV: Signal<String> {
        didRemovedCVTrigger.asSignal()
    }
    
    var didRemovedCL: Signal<String> {
        didRemovedCLTrigger.asSignal()
    }
    
    var didEditedCV: Signal<CV> {
        didEditedCVTrigger.asSignal()
    }
    
    var didEditedCL: Signal<CL> {
        didEditedCLTrigger.asSignal()
    }
    
    var didEditedGroup: Signal<ResumeGroup> {
        didEditedGroupTrigger.asSignal()
    }
}
