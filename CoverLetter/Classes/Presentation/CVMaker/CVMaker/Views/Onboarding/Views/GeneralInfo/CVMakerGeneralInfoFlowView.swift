//
//  CVMakerGeneralInfoFlowView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

protocol CVMakerGeneralInfoFlowViewDelegate: AnyObject {
    func slideViewDidNext(from step: CVMakerGeneralInfoView.Step)
    func slideViewDidBack(from step: CVMakerGeneralInfoView.Step)
}

class CVMakerGeneralInfoFlowView: UIView {
    let step: CVMakerGeneralInfoView.Step
    
    weak var delegate: CVMakerGeneralInfoFlowViewDelegate?
    
    init(step: CVMakerGeneralInfoView.Step) {
        self.step = step
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func moveToThis() {}
    
    @objc
    func onNext() {
        delegate?.slideViewDidNext(from: step)
    }
    
    @objc
    func onBack() {
        delegate?.slideViewDidBack(from: step)
    }
}
