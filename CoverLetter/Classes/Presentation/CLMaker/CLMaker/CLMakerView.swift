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
    
    lazy var progressView = makeProgressView()
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
    
    private lazy var didCancelFlowTrigger = PublishRelay<Void>()
    private lazy var didSelectTemplateTrigger = PublishRelay<CLTemplate>()
    private lazy var didCompleteOnboardingTrigger = PublishRelay<Void>()
    private lazy var didCreatedTextBlocksTrigger = PublishRelay<[CLTextBlock]>()
    
    private var flow = Flow.template
    
    private lazy var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
        initialize()
        updateProgress(at: flow)
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
    var didCancelFlow: Signal<Void> {
        Signal
            .merge(
                didCancelFlowTrigger.asSignal(),
                previewView.closeButton.rx.tap.asSignal()
            )
    }
    
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
        backgroundColor = Appearance.mono100
        
        flowViews
            .forEach { [weak self] flow, view in
                guard let self else { return }
                
                view.clipsToBounds = true
                
                if flow == self.flow {
                    container.addSubview(view)
                }
            }
        
        onboardingView.didChangeChapter = { [weak self] chapter in
            guard let self else { return }
            
            updateProgress(at: flow)
        }
        
        progressView
            .backButton.rx.tap
            .bind(to: Binder(self) { base, void in
                base.movePositionBack()
            })
            .disposed(by: disposeBag)
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
            
            updateProgress(at: newFlow)
        })
    }
    
    func updateProgress(at flow: Flow) {
        let position = currentPosition()
        progressView.move(to: position)
    }
    
    func movePositionBack() {
        guard let position = currentPosition() else { return }
        
        switch position {
        case .templates:
            didCancelFlowTrigger.accept(Void())
        case .personalInfo:
            scroll(to: .template)
        case .companyInfo:
            onboardingView.move(to: .personalInfo)
        case .hiringManager:
            onboardingView.move(to: .companyInfo)
        case .vacancy:
            onboardingView.move(to: .hiringManager)
        case .toneOnVoice:
            onboardingView.move(to: .vacancy)
        case .textBlocks:
            scroll(to: .onboarding)
        }
    }
    
    func currentPosition() -> CLMakerProgressView.Position? {
        switch flow {
        case .template:
            return .templates
        case .onboarding:
            switch onboardingView.chapter {
            case .personalInfo:
                return .personalInfo
            case .companyInfo:
                return .companyInfo
            case .hiringManager:
                return .hiringManager
            case .vacancy:
                return .vacancy
            case .toneOnVoice:
                return .toneOnVoice
            }
        case .textBlocks:
            return .textBlocks
        case .preview:
            return nil
        }
    }
}

// MARK: Make constraints
private extension CLMakerView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            progressView.leadingAnchor.constraint(equalTo: leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: container.topAnchor, constant: -15.scale),
            progressView.heightAnchor.constraint(equalToConstant: 24.scale)
        ])
        
        NSLayoutConstraint.activate([
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.topAnchor.constraint(equalTo: topAnchor, constant: ScreenSize.isIphoneXFamily ? 93.scale : 48.scale),
            container.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerView {
    func makeProgressView() -> CLMakerProgressView {
        let view = CLMakerProgressView()
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContainer() -> GradientView {
        let view = GradientView()
        view.gradientLayer.colors = [
            Appearance.custom_f7f3ed.cgColor,
            Appearance.mono100.cgColor
        ]
        view.gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        view.gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        view.layer.cornerRadius = 30.scale
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
