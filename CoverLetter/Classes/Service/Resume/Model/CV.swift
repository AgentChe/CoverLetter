//
//  CV.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import Foundation

struct CV: Codable {
    let id: String
    let template: CVTemplate
    let profile: Profile
    let created: Date
    let edited: Date?
}
