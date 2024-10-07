//
//  Country.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

struct Country: Codable {
    let name: String
    let iso2: String
}

// MARK: Public
extension Country {
    init?(json: [String: Any]) {
        guard 
            let name = json["name"] as? String,
            let iso2 = json["iso2"] as? String
        else {
            return nil
        }
        
        self.name = name
        self.iso2 = iso2
    }
    
    static func map(from response: Any) -> [Country] {
        guard let array = response as? [[String: Any]] else {
            return []
        }
        
        return array.compactMap { json -> Country? in
            Country(json: json)
        }
    }
}
