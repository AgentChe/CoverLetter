//
//  Certificate.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct Certificate: Codable {
    let id: String
    let organizationName: String?
    let startDate: Date?
    let endDate: Date?
    let description: String?
    
    init(
        id: String = UUID().uuidString,
        organizationName: String?,
        startDate: Date?,
        endDate: Date?,
        description: String?
    ) {
        self.id = id
        self.organizationName = organizationName
        self.startDate = startDate
        self.endDate = endDate
        self.description = description
    }
}
