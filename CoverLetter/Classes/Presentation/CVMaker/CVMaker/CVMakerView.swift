//
//  CVMakerView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CVMakerView: UIView {
    enum Flow: Int {
        case template
        case onboarding
        case crafting
        case preview
    }
    
    lazy var container = makeContainer()
    lazy var flowViews: [Flow: CVMakerFlowView] = [
        .template: templateView,
        .onboarding: onboardingView,
        .crafting: craftingView,
        .preview: previewView
    ]
    lazy var templateView = CVMakerTemplateView { [weak self] template in
        self?.didSelectTemplateTrigger.accept(template)
        self?.scroll(to: .onboarding)
    }
    lazy var onboardingView = CVMakerOnboardingView(vc: vc) { [weak self] in
        self?.scroll(to: .crafting)
    }
    lazy var craftingView = CVMakerCraftingView { [weak self] in
        self?.didCreateCVTrigger.accept(Void())
        self?.scroll(to: .preview)
    }
    lazy var previewView = CVMakerPreviewView()
    
    private lazy var didSelectTemplateTrigger = PublishRelay<CVTemplate>()
    private lazy var didCreateCVTrigger = PublishRelay<Void>()
    
    private var flow = Flow.template
    
    private weak var vc: UIViewController?
    
    init(vc: UIViewController?) {
        self.vc = vc
        
        super.init(frame: .zero)
        
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
extension CVMakerView {
    var didSelectTemplate: Signal<CVTemplate> {
        didSelectTemplateTrigger.asSignal()
    }
    
    var didCreateCV: Signal<Void> {
        didCreateCVTrigger.asSignal()
    }
}

// MARK: Private
private extension CVMakerView {
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
private extension CVMakerView {
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
private extension CVMakerView {
    func makeContainer() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
