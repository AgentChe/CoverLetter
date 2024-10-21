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
    static let otterScaleApiKey = "7W8OVoaTlJmlPmlx"
    
    static let applicationTag = "COVER_LETTER"
    static let amplitudeApiKey = "d433d2c66723aeefd10c5b65f91c1fa3"
    
    static let termsOfUseUrl = URL(string: "https://toiboto.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://toiboto.com/policy")!
    static let contactUsUrl = URL(string: "https://toiboto.com/#contact_us")!
    
    enum Paygate {
        static let defaultLifetime = "coverletter.endless"
        static let defaultMonthly = "coverletter.monthly"
    }
}
