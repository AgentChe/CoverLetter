//
//  CL.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import Foundation

struct CL: Codable {
    let id: String
    let template: CLTemplate
    let info: CLInfo
    let created: Date
    let edited: Date?
}
