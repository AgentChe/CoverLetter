//
//  ISOLanguages.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

import Foundation

typealias ISOLanguages = [String]

extension ISOLanguages {
    static func map(resourceJSON: [String: Any]) -> ISOLanguages {
        var result = [String]()
        
        resourceJSON.forEach { key, value in
            guard let valueJSON = value as? [String: Any] else { return }
            
            if let name = valueJSON["name"] as? String {
                result.append(name)
            }
        }
        
        return result
    }
}
