//
//  CLMakerViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CLMakerViewController: UIViewController {
    enum Mode {
        case create, edit(CL)
    }
    
    private lazy var mainView = CLMakerView()
    
    private lazy var viewModel = CLMakerViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let mode: Mode
    
    private init(mode: Mode) {
        self.mode = mode
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.didSelectTemplate
            .emit(to: Binder(mainView.previewView) { base, template in
                base.setup(template: template)
            })
            .disposed(by: disposeBag)
        
        let output = viewModel.configure(input: CLMakerViewModel.Input(
            mode: mode,
            didSelectTemplate: mainView.didSelectTemplate,
            didCollectedPersonalInfo: mainView.onboardingView.didCollectedPersonalInfo,
            didCollectedCompany: mainView.onboardingView.didCollectedCompany,
            didCollectedHiringManager: mainView.onboardingView.didCollectedHiringManager,
            didCollectedVacancy: mainView.onboardingView.didCollectedVacancy,
            didCollectedToneOfVoice: mainView.onboardingView.didCollectedToneOfVoice,
            didCompleteOnboarding: mainView.didCompleteOnboarding,
            didCreatedTextBlocks: mainView.didCreatedTextBlocks,
            didTapPreview: mainView.previewView.previewButton.rx.tap.asSignal(),
            didShareCL: mainView.previewView.shareButton.rx.tap.asSignal(),
            didCancelFlow: mainView.previewView.closeButton.rx.tap.asSignal()
        ))
        
        output.templatesElements
            .drive(Binder(mainView.templateView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.prepareOnboardingData
            .drive(Binder(mainView.onboardingView) { base, prepareData in
                base.personalInfoView.setup(personalInfo: prepareData.personalInfo)
                base.companyInfoView.setup(company: prepareData.company)
                base.hiringManagerView.setup(hiringManager: prepareData.hiringManager)
                base.vacancyView.setup(vacancy: prepareData.vacancy)
                base.toneOnVoiceView.setup(toneOfVoice: prepareData.toneOfVoice)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
            })
            .disposed(by: disposeBag)
        
        output.actions
            .drive(Binder(self) { base, action in
                base.action(action)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .darkContent
    }
}

// MARK: Public
extension CLMakerViewController {
    static func make(mode: Mode) -> CLMakerViewController {
        let vc = CLMakerViewController(mode: mode)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CLMakerViewController {
    func route(_ route: CLMakerViewModel.Route) {
        switch route {
        case .cancelFlow:
            dismiss(animated: true)
        case .preview(let cl):
            let pdf = PDFFactory.createCL(cl: cl)
            let vc = PDFViewController(pdf: pdf)
            present(vc, animated: true)
        case .share(let cl):
            let pdf = PDFFactory.createCL(cl: cl)
            let vc = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
            present(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
    
    func action(_ action: CLMakerViewModel.Action) {
        switch action {
        case .analyzeData(let analyzeData):
            mainView.textBlocksView.analyze(analyzeData: analyzeData)
        }
    }
}
