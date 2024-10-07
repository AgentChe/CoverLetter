//
//  City.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

typealias City = String

extension City {
    static func map(from response: Any) -> [City] {
        guard let array = response as? [[String: Any]] else {
            return []
        }
        
        return array.compactMap { json -> City? in
            json["name"] as? City
        }
    }
}
