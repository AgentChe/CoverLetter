//
//  CLMakerViewModel.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import RxSwift
import RxCocoa

final class CLMakerViewModel {
    enum Route {
        case cancelFlow
        case preview(CL)
        case share(CL)
        case paygate
    }
    
    enum Action {
        case analyzeData(CLMakerAnalyzeData)
    }
    
    private lazy var resumeManager = ResumeManager()
    
    private var analyzeDataGenerator: CLMakerAnalyzeDataGenerator!
}

// MARK: Public
extension CLMakerViewModel {
    struct Input {
        let mode: CLMakerViewController.Mode
        let didSelectTemplate: Signal<CLTemplate>
        let didCollectedPersonalInfo: Signal<CLPersonalInfo>
        let didCollectedCompany: Signal<CLCompany>
        let didCollectedHiringManager: Signal<CLHiringManager>
        let didCollectedVacancy: Signal<CLVacancy>
        let didCollectedToneOfVoice: Signal<CLToneOfVoice>
        let didCompleteOnboarding: Signal<Void>
        let didCreatedTextBlocks: Signal<[CLTextBlock]>
        let didTapPreview: Signal<Void>
        let didShareCL: Signal<Void>
        let didCancelFlow: Signal<Void>
    }
    
    struct Output {
        let templatesElements: Driver<[CLMTemplatesCollectionElement]>
        let prepareOnboardingData: Driver<CLMakerPrepareOnboardingData>
        let route: Driver<Route>
        let actions: Driver<Action>
        let disposable: Disposable
    }
    
    func configure(input: Input) -> Output {
        let prepareOnboardingData = makePrepareOnboardingData(mode: input.mode)
        
        analyzeDataGenerator = CLMakerAnalyzeDataGenerator(
            prepareOnboardingData: prepareOnboardingData,
            didCollectedPersonalInfo: input.didCollectedPersonalInfo,
            didCollectedCompany: input.didCollectedCompany,
            didCollectedHiringManager: input.didCollectedHiringManager,
            didCollectedVacancy: input.didCollectedVacancy,
            didCollectedToneOfVoice: input.didCollectedToneOfVoice
        )
        
        let cl = makeCL(
            mode: input.mode,
            didSelectTemplate: input.didSelectTemplate,
            didCreatedTextBlocks: input.didCreatedTextBlocks
        )
        
        return Output(
            templatesElements: makeTemplatesElements(mode: input.mode),
            prepareOnboardingData: prepareOnboardingData,
            route: makeRoute(
                didCancelFlow: input.didCancelFlow,
                didTapPreview: input.didTapPreview,
                didShareCL: input.didShareCL,
                cl: cl
            ),
            actions: makeActions(didCompleteOnboarding: input.didCompleteOnboarding),
            disposable: makeDisposable(createCL: cl)
        )
    }
}

// MARK: Private
private extension CLMakerViewModel {
    func makeCL(
        mode: CLMakerViewController.Mode,
        didSelectTemplate: Signal<CLTemplate>,
        didCreatedTextBlocks: Signal<[CLTextBlock]>
    ) -> Driver<CL> {
        didCreatedTextBlocks
            .withLatestFrom(didSelectTemplate) { ($0, $1) }
            .asDriver(onErrorDriveWith: .never())
            .flatMapLatest { [weak self] textBlocks, template -> Driver<CL> in
                guard let self else { return .never() }
                
                let analyzeData = self.analyzeDataGenerator.make()
                
                let clInfo = CLInfo(
                    personalInfo: analyzeData.personalInfo,
                    company: analyzeData.company,
                    hiringManager: analyzeData.hiringManager,
                    vacancy: analyzeData.vacancy,
                    toneOfVoice: analyzeData.toneOfVoice,
                    textBlocks: textBlocks
                )
                
                switch mode {
                case .create:
                    return self.resumeManager
                        .createCL(template: template, info: clInfo)
                        .asDriver(onErrorDriveWith: .never())
                case .edit(let cl):
                    let updatedCL = CL(
                        id: cl.id,
                        template: template,
                        info: clInfo,
                        created: cl.created,
                        edited: Date()
                    )
                    
                    return self.resumeManager
                        .edit(cl: updatedCL)
                        .asDriver(onErrorDriveWith: .never())
                }
            }
    }
    
    func makePrepareOnboardingData(mode: CLMakerViewController.Mode) -> Driver<CLMakerPrepareOnboardingData> {
        switch mode {
        case .create:
            let prepareData = CLMakerPrepareOnboardingData(
                personalInfo: nil,
                company: nil,
                hiringManager: nil,
                vacancy: nil,
                toneOfVoice: nil
            )
            return .deferred { .just(prepareData) }
        case .edit(let cl):
            let prepareData = CLMakerPrepareOnboardingData(
                personalInfo: cl.info.personalInfo,
                company: cl.info.company,
                hiringManager: cl.info.hiringManager,
                vacancy: cl.info.vacancy,
                toneOfVoice: cl.info.toneOfVoice
            )
            return .deferred { .just(prepareData) }
        }
    }
    
    func makeTemplatesElements(mode: CLMakerViewController.Mode) -> Driver<[CLMTemplatesCollectionElement]> {
        resumeManager
            .obtainCLTemplates()
            .asDriver(onErrorJustReturn: [])
            .map { templates -> [CLMTemplatesCollectionElement] in
                [.header] + templates.enumerated().map { index, template -> CLMTemplatesCollectionElement in
                    let marked: Bool = {
                        switch mode {
                        case .create:
                            return index == 0
                        case .edit(let cv):
                            return template.identifier == cv.template.identifier
                        }
                    }()
                    
                    let element = CLMTemplatesCollectionTemplateElement(
                        template: template,
                        marked: marked
                    )
                    return .template(element)
                }
            }
    }
    
    func makeRoute(
        didCancelFlow: Signal<Void>,
        didTapPreview: Signal<Void>,
        didShareCL: Signal<Void>,
        cl: Driver<CL>
    ) -> Driver<Route> {
        let cancelFlow = didCancelFlow
            .map { Route.cancelFlow }
            .asDriver(onErrorDriveWith: .never())
        
        let preview = didTapPreview
            .withLatestFrom(cl)
            .asDriver(onErrorDriveWith: .never())
            .map { Route.preview($0) }
        
        let shareOrPaygate = didShareCL
            .withLatestFrom(cl)
            .asDriver(onErrorDriveWith: .never())
            .map { cl -> Route in
                SessionManager().hasActiveSubscriptions() ? Route.share(cl) : Route.paygate
            }
        
        return Driver
            .merge(cancelFlow, preview, shareOrPaygate)
    }
    
    func makeActions(didCompleteOnboarding: Signal<Void>) -> Driver<Action> {
        let analyzeData = didCompleteOnboarding
            .compactMap { [weak self] void -> CLMakerAnalyzeData? in
                self?.analyzeDataGenerator.make()
            }
            .map { Action.analyzeData($0) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(analyzeData)
    }
    
    func makeDisposable(createCL: Driver<CL>) -> Disposable {
        createCL.drive()
    }
}
