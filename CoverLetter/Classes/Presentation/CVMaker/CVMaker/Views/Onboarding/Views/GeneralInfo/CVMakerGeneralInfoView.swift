//
//  CVMakerGeneralInfoView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

import UIKit

final class CVMakerGeneralInfoView: UIView {
    enum Step: Int {
        case name, aboutYourself, contactInfo, photo
    }
    
    lazy var progressView = makeProgressView()
    lazy var container = makeContainer()
    lazy var flowViews: [CVMakerGeneralInfoFlowView] = [
        nameView,
        aboutYourselfView,
        contactInfoView,
        photoView
    ]
    lazy var nameView = CVMakerGeneralInfoNameView(mainDelegate: collector)
    lazy var aboutYourselfView = CVMakerGeneralInfoAboutYourselfView(mainDelegate: collector)
    lazy var contactInfoView = CVMakerGeneralInfoContactInfoView(vc: vc, mainDelegate: collector)
    lazy var photoView = CVMakerGeneralInfoPhotoView(vc: vc, mainDelegate: collector)
    
    private lazy var step = Step.name
    
    private lazy var collector = CVMakerGeneralInfoCollector()
    
    private weak var vc: UIViewController?
    private let flowFinished: ((GeneralInfo) -> Void)
    
    init(vc: UIViewController?, flowFinished: @escaping ((GeneralInfo) -> Void)) {
        self.vc = vc
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
        
        flowViews.forEach { flowView in
            flowView.frame.size = container.bounds.size
        }
    }
}

// MARK: Public
extension CVMakerGeneralInfoView {
    func setup(generalInfo: GeneralInfo?) {
        nameView.setup(firstName: generalInfo?.firstName)
        nameView.setup(lastName: generalInfo?.lastName)
        aboutYourselfView.setup(aboutYourself: generalInfo?.aboutYourself)
        contactInfoView.setup(contactInfo: generalInfo?.contactInfo)
        photoView.setup(photoFileName: generalInfo?.photoFileName)
    }
}

// MARK: CVMakerGeneralInfoFlowViewDelegate
extension CVMakerGeneralInfoView: CVMakerGeneralInfoFlowViewDelegate {
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
private extension CVMakerGeneralInfoView {
    func initialize() {
        flowViews
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
        
        let indices = flowViews.indices
        
        guard indices.contains(currentIndex), indices.contains(scrollToIndex) else {
            return
        }

        let currentView = flowViews[currentIndex]
        let scrollToView = flowViews[scrollToIndex]
        
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
private extension CVMakerGeneralInfoView {
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
private extension CVMakerGeneralInfoView {
    func makeProgressView() -> CVMakerChapterProgressView {
        let view = CVMakerChapterProgressView(count: flowViews.count)
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
