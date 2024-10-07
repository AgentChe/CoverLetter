//
//  CLMakerHiringManagerStepView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

protocol CLMakerHiringManagerStepViewDelegate: AnyObject {
    func slideViewDidNext(from step: CLMakerHiringManagerView.Step)
    func slideViewDidBack(from step: CLMakerHiringManagerView.Step)
}

class CLMakerHiringManagerStepView: UIView {
    let step: CLMakerHiringManagerView.Step
    
    weak var delegate: CLMakerHiringManagerStepViewDelegate?
    
    init(step: CLMakerHiringManagerView.Step) {
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
