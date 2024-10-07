//
//  WorkExperience.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct WorkExperience: Codable {
    let id: String
    let jobTitle: String?
    let companyName: String?
    let startDate: Date?
    let endDate: Date?
    let results: String?
    
    init(
        id: String = UUID().uuidString,
        jobTitle: String?,
        companyName: String?, 
        startDate: Date?,
        endDate: Date?,
        results: String?)
    {
        self.id = id
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.startDate = startDate
        self.endDate = endDate
        self.results = results
    }
}
