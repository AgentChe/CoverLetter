//
//  CVTemplate.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

struct CVTemplate: Codable {
    enum Identifier: Int, Codable {
        case template1
        case template2
        case template3
        case template4
        case template5
        case template6
        case template7
        case template8
        case template9
        case template10
        case template11
        case template12
        case template13
        case template14
        case template15
        case template16
    }
    
    let identifier: Identifier
}
