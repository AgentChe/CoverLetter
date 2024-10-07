//
//  CVMakerViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CVMakerViewController: UIViewController {
    enum Mode {
        case create, edit(CV)
    }
    
    enum StepAfterCancelFlow {
        case main
        case dismiss
    }
    
    private lazy var mainView = CVMakerView(vc: self)
    
    private lazy var viewModel = CVMakerViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private let mode: Mode
    private let stepAfterCancelFlow: StepAfterCancelFlow
    
    private init(mode: Mode, stepAfterCancelFlow: StepAfterCancelFlow) {
        self.mode = mode
        self.stepAfterCancelFlow = stepAfterCancelFlow
        
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
        
        let output = viewModel.configure(input: CVMakerViewModel.Input(
            mode: mode,
            didSelectTemplate: mainView.didSelectTemplate,
            didSaveGeneralInfo: mainView.onboardingView.didCollectedGeneralInfo,
            didSaveWorkExperiences: mainView.onboardingView.didCollectedWorkExperience,
            didSaveEducations: mainView.onboardingView.didCollectedEducations,
            didSaveProfessionalSkills: mainView.onboardingView.didCollectedProfessionalSkills,
            didSaveLanguages: mainView.onboardingView.didCollectedLanguages,
            didSaveInterests: mainView.onboardingView.didCollectedInterests,
            didSaveCertificates: mainView.onboardingView.didCollectedCertificates,
            didSaveSocialMedia: mainView.onboardingView.didCollectedSocialMedia,
            didSaveReferences: mainView.onboardingView.didCollectedReferences,
            didCreateCV: mainView.didCreateCV,
            didTapPreview: mainView.previewView.previewButton.rx.tap.asSignal(),
            didShareCV: mainView.previewView.shareButton.rx.tap.asSignal(),
            didCancelFlow: mainView.previewView.closeButton.rx.tap.asSignal()
        ))
        
        output.profile
            .drive(Binder(mainView) { base, profile in
                base.onboardingView.generalInfoView.setup(generalInfo: profile.generalInfo)
                base.onboardingView.workExperienceView.setup(workExperiences: profile.workExperiences ?? [])
                base.onboardingView.educationsView.setup(educations: profile.educations ?? [])
                base.onboardingView.professionalSkillsView.setup(professionalSkills: profile.professionalSkills ?? [])
                base.onboardingView.languagesView.setup(languages: profile.languages ?? [])
                base.onboardingView.interestsView.setup(interests: profile.interests ?? [])
                base.onboardingView.certificatesView.setup(certificates: profile.certificates ?? [])
                base.onboardingView.socialMediaView.setup(socialMedia: profile.socialMedia)
                base.onboardingView.referencesView.setup(references: profile.references ?? [])
            })
            .disposed(by: disposeBag)
        
        output.templatesElements
            .drive(Binder(mainView.templateView) { base, elements in
                base.setup(elements: elements)
            })
            .disposed(by: disposeBag)
        
        output.route
            .drive(Binder(self) { base, route in
                base.route(route)
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
extension CVMakerViewController {
    static func make(mode: Mode, stepAfterCancelFlow: StepAfterCancelFlow) -> CVMakerViewController {
        let vc = CVMakerViewController(mode: mode, stepAfterCancelFlow: stepAfterCancelFlow)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CVMakerViewController {
    func route(_ route: CVMakerViewModel.Route) {
        switch route {
        case .cancelFlow:
            switch stepAfterCancelFlow {
            case .dismiss:
                dismiss(animated: true)
            case .main:
                UIApplication.shared.keyWindow?.rootViewController = NavigationController(rootViewController: MainViewController.make())
            }
        case .preview(let cv):
            let pdf = PDFFactory.createCV(cv: cv)
            let vc = PDFViewController(pdf: pdf)
            present(vc, animated: true)
        case .share(let cv):
            let pdf = PDFFactory.createCV(cv: cv)
            let vc = UIActivityViewController(activityItems: [pdf], applicationActivities: nil)
            present(vc, animated: true)
        case .paygate:
            let vc = PaygateViewController.make()
            present(vc, animated: true)
        }
    }
}
