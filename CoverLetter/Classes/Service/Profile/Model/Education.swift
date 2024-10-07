//
//  Education.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct Education: Codable {
    let id: String
    let university: String?
    let fieldOfStudy: String?
    let degree: String?
    let startDate: Date?
    let endDate: Date?
    
    init(
        id: String = UUID().uuidString,
        university: String?,
        fieldOfStudy: String?,
        degree: String?,
        startDate: Date?,
        endDate: Date?)
    {
        self.id = id
        self.university = university
        self.fieldOfStudy = fieldOfStudy
        self.degree = degree
        self.startDate = startDate
        self.endDate = endDate
    }
}
