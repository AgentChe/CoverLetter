//
//  CVMakerChapterViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

import UIKit
import RxSwift
import RxCocoa

final class CVMakerChapterViewController: UIViewController {
    private let chapter: CVMakerOnboardingView.Chapter
    
    private lazy var mainView: UIView = {
        switch chapter {
        case .generalInfo:
            return CVMakerGeneralInfoView(vc: self, flowFinished: { [weak self] generalInfo in
                self?.didCollectedGeneralInfoTrigger.accept(generalInfo)
                self?.dismiss(animated: true)
            })
        case .workExperience:
            return CVMakerWorkExperienceView(vc: self, bind: { [weak self] workExperience in
                self?.didCollectedWorkExperienceTrigger.accept(workExperience)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .education:
            return CVMakerEducationView(vc: self, bind: { [weak self] educations in
                self?.didCollectedEducationsTrigger.accept(educations)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .professionalSkills:
            return CVMakerProfessionalSkillsView(vc: self, bind: { [weak self] professionalSkills in
                self?.didCollectedProfessionalSkillsTrigger.accept(professionalSkills)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .languages:
            return CVMakerLanguagesView(vc: self, bind: { [weak self] languages in
                self?.didCollectedLanguagesTrigger.accept(languages)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .interests:
            return CVMakerInterestsView(bind: { [weak self] interests in
                self?.didCollectedInterestsTrigger.accept(interests)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .certificates:
            return CVMakerCertificatesView(vc: self, bind: { [weak self] certificates in
                self?.didCollectedCertificatesTrigger.accept(certificates)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .socialMedia:
            return CVMakerSocialMediaView(bind: { [weak self] socialMedia in
                self?.didCollectedSocialMediaTrigger.accept(socialMedia)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        case .references:
            return CVMakerReferencesView(vc: self, bind: { [weak self] references in
                self?.didCollectedReferencesTrigger.accept(references)
            }, flowFinished: { [weak self] in
                self?.dismiss(animated: true)
            })
        }
    }()
    
    private lazy var viewModel = CVMakerChapterViewModel()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var didCollectedGeneralInfoTrigger = PublishRelay<GeneralInfo>()
    private lazy var didCollectedWorkExperienceTrigger = PublishRelay<[WorkExperience]>()
    private lazy var didCollectedEducationsTrigger = PublishRelay<[Education]>()
    private lazy var didCollectedProfessionalSkillsTrigger = PublishRelay<[ProfessionalSkill]>()
    private lazy var didCollectedLanguagesTrigger = PublishRelay<[Language]>()
    private lazy var didCollectedInterestsTrigger = PublishRelay<[Interest]>()
    private lazy var didCollectedCertificatesTrigger = PublishRelay<[Certificate]>()
    private lazy var didCollectedSocialMediaTrigger = PublishRelay<SocialMedia>()
    private lazy var didCollectedReferencesTrigger = PublishRelay<[Reference]>()
    
    private init(chapter: CVMakerOnboardingView.Chapter) {
        self.chapter = chapter
        
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
        
        mainView.backgroundColor = Appearance.main100
        
        let output = viewModel.configure(input: CVMakerChapterViewModel.Input(
            didSaveGeneralInfo: didCollectedGeneralInfoTrigger.asSignal(),
            didSaveWorkExperiences: didCollectedWorkExperienceTrigger.asSignal(),
            didSaveEducations: didCollectedEducationsTrigger.asSignal(),
            didSaveProfessionalSkills: didCollectedProfessionalSkillsTrigger.asSignal(),
            didSaveLanguages: didCollectedLanguagesTrigger.asSignal(),
            didSaveInterests: didCollectedInterestsTrigger.asSignal(),
            didSaveCertificates: didCollectedCertificatesTrigger.asSignal(),
            didSaveSocialMedia: didCollectedSocialMediaTrigger.asSignal(),
            didSaveReferences: didCollectedReferencesTrigger.asSignal()
        ))
        
        output.profile
            .drive(Binder(self) { base, profile in
                base.setup(profile: profile)
            })
            .disposed(by: disposeBag)
        
        output.disposable
            .disposed(by: disposeBag)
        
        addCloseButton()
    }
}

// MARK: Public
extension CVMakerChapterViewController {
    static func make(chapter: CVMakerOnboardingView.Chapter) -> CVMakerChapterViewController {
        let vc = CVMakerChapterViewController(chapter: chapter)
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
}

// MARK: Private
private extension CVMakerChapterViewController {
    func addCloseButton() {
        let button = TapAreaButton()
        button.backgroundColor = UIColor.clear
        button.setImage(UIImage(named: "Paygate.Close"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        mainView.addSubview(button)
        
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 24.scale),
            button.heightAnchor.constraint(equalToConstant: 24.scale),
            button.trailingAnchor.constraint(equalTo: mainView.trailingAnchor, constant: -16.scale),
            button.topAnchor.constraint(equalTo: mainView.safeAreaLayoutGuide.topAnchor)
        ])
        
        button.rx.tap
            .bind(to: Binder(self) { base, void in
                base.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    func setup(profile: Profile) {
        if let generalInfoView = mainView as? CVMakerGeneralInfoView {
            generalInfoView.setup(generalInfo: profile.generalInfo)
        } else if let workExperienceView = mainView as? CVMakerWorkExperienceView {
            workExperienceView.setup(workExperiences: profile.workExperiences)
        } else if let educationView = mainView as? CVMakerEducationView {
            educationView.setup(educations: profile.educations)
        } else if let professionalSkillsView = mainView as? CVMakerProfessionalSkillsView {
            professionalSkillsView.setup(professionalSkills: profile.professionalSkills ?? [])
        } else if let languagesView = mainView as? CVMakerLanguagesView {
            languagesView.setup(languages: profile.languages ?? [])
        } else if let interestsView = mainView as? CVMakerInterestsView {
            interestsView.setup(interests: profile.interests ?? [])
        } else if let certificatesView = mainView as? CVMakerCertificatesView {
            certificatesView.setup(certificates: profile.certificates)
        } else if let socialMediaView = mainView as? CVMakerSocialMediaView {
            socialMediaView.setup(socialMedia: profile.socialMedia)
        } else if let referencesView = mainView as? CVMakerReferencesView {
            referencesView.setup(references: profile.references)
        }
    }
}
