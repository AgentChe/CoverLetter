//
//  CLMakerVacancyView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import UIKit

final class CLMakerVacancyView: UIView {
    enum Step: Int {
        case position
        case resource
    }
    
    lazy var progressView = makeProgressView()
    lazy var container = makeContainer()
    lazy var stepsViews: [CLMakerVacancyStepView] = [
        positionView,
        resourceView
    ]
    lazy var positionView = CLMakerVacancyPositionView(mainDelegate: collector)
    lazy var resourceView = CLMakerVacancyResourceView(mainDelegate: collector)
    
    private lazy var step = Step.position
    
    private lazy var collector = CLMakerVacancyCollector()
    
    private let flowFinished: (CLVacancy) -> Void
    
    init(flowFinished: @escaping (CLVacancy) -> Void) {
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
        updateProgress(newStep: step)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stepsViews.forEach { stepView in
            stepView.frame.size = container.bounds.size
        }
    }
}

// MARK: Public
extension CLMakerVacancyView {
    func setup(vacancy: CLVacancy?) {
        positionView.setup(position: vacancy?.position)
        resourceView.setup(resource: vacancy?.resource)
    }
}

// MARK: CVMakerGeneralInfoFlowViewDelegate
extension CLMakerVacancyView: CLMakerVacancyStepViewDelegate {
    func slideViewDidNext(from step: Step) {
        let nextRawValue = step.rawValue + 1
        
        guard let nextStep = Step(rawValue: nextRawValue) else {
            flowFinished(collector.make())
            
            return
        }
        
        updateProgress(newStep: nextStep)
        scroll(to: nextStep)
    }
    
    func slideViewDidBack(from step: Step) {
        let previousRawValue = step.rawValue - 1
        
        guard let previousStep = Step(rawValue: previousRawValue) else {
            return
        }
        
        updateProgress(newStep: previousStep)
        scroll(to: previousStep)
    }
}

// MARK: Private
private extension CLMakerVacancyView {
    func initialize() {
        stepsViews
            .enumerated()
            .forEach { [weak self] index, view in
                guard let self else { return }
                
                view.clipsToBounds = true
                view.delegate = self
                
                if index == 0 {
                    container.addSubview(view)
                    
                    view.moveToThis()
                }
            }
        
        progressView.back = { [weak self] in
            guard let self else { return }
            
            self.slideViewDidBack(from: step)
        }
    }
    
    func updateProgress(newStep: Step) {
        progressView.backButton.isHidden = newStep.rawValue == 0
        
        let index = newStep.rawValue + 1
        progressView.setup(step: index)
    }
    
    func scroll(to newStep: Step) {
        let currentIndex = step.rawValue
        let scrollToIndex = newStep.rawValue
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        let indices = stepsViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = stepsViews[currentIndex]
        let scrollToView = stepsViews[scrollToIndex]
        
        scrollToView.frame.origin = CGPoint(x: 393.scale * CGFloat(direction), y: 0)
        
        container.addSubview(scrollToView)
        
        UIView.animate(withDuration: 0.3, animations: {
            currentView.frame.origin = CGPoint(x: 393.scale * CGFloat(-direction), y: 0)
            scrollToView.frame.origin = CGPoint(x: 0, y: 0)
        }, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            currentView.removeFromSuperview()
            
            scrollToView.moveToThis()
            
            self.step = newStep
        })
    }
}

// MARK: Make constraints
private extension CLMakerVacancyView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            progressView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 32.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 2.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerVacancyView {
    func makeProgressView() -> CLMakerChapterProgressView {
        let view = CLMakerChapterProgressView(count: stepsViews.count)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
