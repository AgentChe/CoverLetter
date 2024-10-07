//
//  CLMakerView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLMakerView: UIView {
    enum Flow: Int {
        case template
        case onboarding
        case textBlocks
        case preview
    }
    
    lazy var container = makeContainer()
    lazy var flowViews: [Flow: CLMakerFlowView] = [
        .template: templateView,
        .onboarding: onboardingView,
        .textBlocks: textBlocksView,
        .preview: previewView
    ]
    lazy var templateView = CLMakerTemplateView { [weak self] template in
        self?.didSelectTemplateTrigger.accept(template)
        self?.scroll(to: .onboarding)
        
    }
    lazy var onboardingView = CLMakerOnboardingView { [weak self] in
        self?.didCompleteOnboardingTrigger.accept(Void())
        self?.scroll(to: .textBlocks)
    }
    lazy var textBlocksView = CLMakerTextBlocksView { [weak self] textBlocks in
        self?.didCreatedTextBlocksTrigger.accept(textBlocks)
        self?.scroll(to: .preview)
    }
    lazy var previewView = CLMakerPreviewView()
    
    private lazy var didSelectTemplateTrigger = PublishRelay<CLTemplate>()
    private lazy var didCompleteOnboardingTrigger = PublishRelay<Void>()
    private lazy var didCreatedTextBlocksTrigger = PublishRelay<[CLTextBlock]>()
    
    private var flow = Flow.template
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        flowViews.forEach { flow, view in
            view.frame.size = container.bounds.size
        }
    }
}

// MARK: Public
extension CLMakerView {
    var didSelectTemplate: Signal<CLTemplate> {
        didSelectTemplateTrigger.asSignal()
    }
    
    var didCompleteOnboarding: Signal<Void> {
        didCompleteOnboardingTrigger.asSignal()
    }
    
    var didCreatedTextBlocks: Signal<[CLTextBlock]> {
        didCreatedTextBlocksTrigger.asSignal()
    }
}

// MARK: Private
private extension CLMakerView {
    func initialize() {
        backgroundColor = Appearance.main100
        
        flowViews
            .forEach { [weak self] flow, view in
                guard let self else { return }
                
                view.clipsToBounds = true
                
                if flow == self.flow {
                    container.addSubview(view)
                }
            }
    }
    
    func scroll(to newFlow: Flow) {
        let currentIndex = flow.rawValue
        let scrollToIndex = newFlow.rawValue
        
        guard scrollToIndex != currentIndex else {
            return
        }
        
        let direction = scrollToIndex > currentIndex ? 1 : -1
        
        guard
            let currentView = flowViews[flow],
            let scrollToView = flowViews[newFlow]
        else {
            return
        }
        
        scrollToView.frame.size = container.bounds.size
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
            
            self.flow = newFlow
            
            scrollToView.moveToThis()
        })
    }
}

// MARK: Make constraints
private extension CLMakerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
