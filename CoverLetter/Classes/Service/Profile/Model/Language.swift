//
//  Language.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct Language: Codable, Equatable {
    enum Level: Codable, Equatable {
        case beginner
        case preIntermediate
        case intermediate
        case upperIntermediate
        case advanced
        case proficient
    }
    
    let name: String
    let level: Level
}
