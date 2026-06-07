//
//  PaygateViewModel.swift
//  Soccer
//
//  Created by Андрей Чернышев on 02.09.2022.
//

import RxSwift
import RxCocoa

final class PaygateViewModel {
    enum Route {
        case dismiss
        case error
        case open(URL)
    }
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var iapManager = IAPManager()
    private lazy var purchaseInteractor = PaygateInteractor()
}

// MARK: Public
extension PaygateViewModel {
    struct Input {
        let didTapClose: Signal<Void>
        let didTapBuy: Signal<String>
        let didTapRestore: Signal<Void>
        let didTapTermsOfUse: Signal<Void>
        let didTapPrivacyPolicy: Signal<Void>
    }
    
    struct Output {
        let activity: Driver<Bool>
        let route: Driver<Route>
        let products: Driver<[PaygateOptionInfo]>
    }
    
    func configure(input: Input) -> Output {
        Output(
            activity: activity.asDriver(),
            route: makeRoute(
                didTapClose: input.didTapClose,
                didTapBuy: input.didTapBuy,
                didTapRestore: input.didTapRestore,
                didTapTermsOfUse: input.didTapTermsOfUse,
                didTapPrivacyPolicy: input.didTapPrivacyPolicy
            ),
            products: makeProducts()
        )
    }
}

// MARK: Private
private extension PaygateViewModel {
    func makeProducts() -> Driver<[PaygateOptionInfo]> {
        iapManager
            .obtainPrices(for: [
                GlobalDefinitions.Paygate.defaultLifetime,
                GlobalDefinitions.Paygate.defaultMonthly
            ])
            .map { [weak self] prices -> [PaygateOptionInfo] in
                guard let self, let paygate = Paygate(prices: prices) else {
                    return []
                }
                
                return [
                    self.info(config: paygate.leftOptionConfig, prices: prices),
                    self.info(config: paygate.rightOptionConfig, prices: prices)
                ].compactMap { $0 }
            }
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
    }
    
    func makeRoute(
        didTapClose: Signal<Void>,
        didTapBuy: Signal<String>,
        didTapRestore: Signal<Void>,
        didTapTermsOfUse: Signal<Void>,
        didTapPrivacyPolicy: Signal<Void>
    ) -> Driver<Route> {
        let dismiss = didTapClose
            .map { Route.dismiss }
            .asDriver(onErrorDriveWith: .never())
        let buy = makeBuyed(didTapBuy: didTapBuy)
            .map { $0 ? Route.dismiss : Route.error }
        let restore = makeRestored(didTapRestore: didTapRestore)
            .map { $0 ? Route.dismiss : Route.error }
        let termsOfUse = didTapTermsOfUse
            .map { Route.open(GlobalDefinitions.termsOfServiceUrl) }
            .asDriver(onErrorDriveWith: .never())
        let privacyPolicy = didTapPrivacyPolicy
            .map { Route.open(GlobalDefinitions.privacyPolicyUrl) }
            .asDriver(onErrorDriveWith: .never())
        
        return Driver
            .merge(dismiss, buy, restore, termsOfUse, privacyPolicy)
    }
    
    func makeBuyed(didTapBuy: Signal<String>) -> Driver<Bool> {
        didTapBuy
            .flatMapLatest { [weak self] productId -> Driver<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .buy(productId))
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: false)
            }
    }
    
    func makeRestored(didTapRestore: Signal<Void>) -> Driver<Bool> {
        didTapRestore
            .flatMapLatest { [weak self] void -> Driver<Bool> in
                guard let self = self else {
                    return .never()
                }
                
                return self.purchaseInteractor
                    .makeActiveSubscription(by: .restore)
                    .map { result -> Bool in
                        switch result {
                        case .completed(let response):
                            return response
                        case .cancelled:
                            return false
                        }
                    }
                    .trackActivity(self.activity)
                    .asDriver(onErrorJustReturn: false)
            }
    }
}

// MARK: Private (Additional)
private extension PaygateViewModel {
    func info(config: PaygateOptionConfig, prices: [ProductPrice]) -> PaygateOptionInfo? {
        guard let price = prices.first(where: { $0.id == config.productId }) else {
            return nil
        }
        
        return PaygateOptionInfo(config: config,
                                 price: price)
    }
}
