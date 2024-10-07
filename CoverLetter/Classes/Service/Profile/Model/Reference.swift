//
//  Reference.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct Reference: Codable {
    let id: String
    let name: String?
    let jobTitle: String?
    let phone: String?
    let email: String?
    
    init(
        id: String = UUID().uuidString,
        name: String?,
        jobTitle: String?,
        phone: String?,
        email: String?
    ) {
        self.id = id
        self.name = name
        self.jobTitle = jobTitle
        self.phone = phone
        self.email = email
    }
}
