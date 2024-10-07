//
//  CLTemplate.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

struct CLTemplate: Codable {
    enum Identifier: Int, Codable {
        case template1
        case template2
        case template3
        case template4
        case template5
        case template6
        case template7
    }
    
    let identifier: Identifier
}
