//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://cvmaker.camplain-apps.com"
    static let apiKey = "Xn4QEjsgh4zE4kMZyA"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "52pXvkLAXBbRyk6x"
    
    static let countriesCitiesAPIKey = "eHlzeXRJVWViT3o1Rm9hM2V1UG1iS1ZKN00yQWtHWkFpaUhYcHhPSg=="
    
    static let applicationTag = "CV_MAKER"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    static let termsOfUseUrl = URL(string: "https://toiboto.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://toiboto.com/policy")!
    static let contactUsUrl = URL(string: "https://toiboto.com/#contact_us")!
    
    enum LinkedIn {
        static let clientId = "7792qc3r585vh5"
        static let clientShared = "KDFs4YQmsbY6rHRG"
        static let redirectUri = "https://cmmaker.callback"
    }
    
    // TODO
    enum Paygate {
        static let defaultLifetime = "cvmaker.endless"
        static let defaultMonthly = "cvmaker.monthly"
    }
}
