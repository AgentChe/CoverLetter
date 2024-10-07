//
//  CLMakerVacancyStepView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

protocol CLMakerVacancyStepViewDelegate: AnyObject {
    func slideViewDidNext(from step: CLMakerVacancyView.Step)
    func slideViewDidBack(from step: CLMakerVacancyView.Step)
}

class CLMakerVacancyStepView: UIView {
    let step: CLMakerVacancyView.Step
    
    weak var delegate: CLMakerVacancyStepViewDelegate?
    
    init(step: CLMakerVacancyView.Step) {
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
