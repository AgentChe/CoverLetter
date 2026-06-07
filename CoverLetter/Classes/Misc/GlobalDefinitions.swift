//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let domain = "https://cvmaker.thinkaboutapps.com"
    static let apiKey = "Xn4QEjsgh4zE4kMZyA"
    
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "7W8OVoaTlJmlPmlx"
    
    static let termsOfServiceUrl = URL(string: "https://thinkaboutapps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://thinkaboutapps.com/policy")!
    static let contactUsUrl = URL(string: "https://thinkaboutapps.com/contact")!
    
    enum Paygate {
        static let defaultLifetime = "coverletter.endless"
        static let defaultMonthly = "coverletter.monthly"
    }
}
