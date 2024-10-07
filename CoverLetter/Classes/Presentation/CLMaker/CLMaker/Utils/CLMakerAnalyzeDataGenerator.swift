//
//  CLMakerAnalyzeDataGenerator.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

import RxSwift
import RxCocoa

struct CLMakerAnalyzeData {
    let personalInfo: CLPersonalInfo?
    let company: CLCompany?
    let hiringManager: CLHiringManager?
    let vacancy: CLVacancy?
    let toneOfVoice: CLToneOfVoice?
}

final class CLMakerAnalyzeDataGenerator {
    private var personalInfo: CLPersonalInfo?
    private var company: CLCompany?
    private var hiringManager: CLHiringManager?
    private var vacancy: CLVacancy?
    private var toneOfVoice: CLToneOfVoice?
    
    private lazy var disposeBag = DisposeBag()
    
    init(
        prepareOnboardingData: Driver<CLMakerPrepareOnboardingData>,
        didCollectedPersonalInfo: Signal<CLPersonalInfo>,
        didCollectedCompany: Signal<CLCompany>,
        didCollectedHiringManager: Signal<CLHiringManager>,
        didCollectedVacancy: Signal<CLVacancy>,
        didCollectedToneOfVoice: Signal<CLToneOfVoice>
    ) {
        prepareOnboardingData
            .drive(Binder(self) { base, prepareData in
                base.personalInfo = prepareData.personalInfo
                base.company = prepareData.company
                base.hiringManager = prepareData.hiringManager
                base.vacancy = prepareData.vacancy
                base.toneOfVoice = prepareData.toneOfVoice
            })
            .disposed(by: disposeBag)
        
        didCollectedPersonalInfo
            .emit(to: Binder(self) { base, personalInfo in
                base.personalInfo = personalInfo
            })
            .disposed(by: disposeBag)
        
        didCollectedCompany
            .emit(to: Binder(self) { base, company in
                base.company = company
            })
            .disposed(by: disposeBag)
        
        didCollectedHiringManager
            .emit(to: Binder(self) { base, hiringManager in
                base.hiringManager = hiringManager
            })
            .disposed(by: disposeBag)
        
        didCollectedVacancy
            .emit(to: Binder(self) { base, vacancy in
                base.vacancy = vacancy
            })
            .disposed(by: disposeBag)
        
        didCollectedToneOfVoice
            .emit(to: Binder(self) { base, toneOfVoice in
                base.toneOfVoice = toneOfVoice
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Public
extension CLMakerAnalyzeDataGenerator {
    func make() -> CLMakerAnalyzeData {
        CLMakerAnalyzeData(
            personalInfo: personalInfo,
            company: company,
            hiringManager: hiringManager,
            vacancy: vacancy,
            toneOfVoice: toneOfVoice
        )
    }
}
