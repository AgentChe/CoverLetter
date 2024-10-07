//
//  CLTextBlock.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

struct CLTextBlock: Codable {
    let title: String?
    let text: String
}

// MARK: Public
extension CLTextBlock {
    static func map(response: Any) -> [CLTextBlock] {
        guard
            let json = response as? [String: Any],
            let body = json["body"] as? [[String: Any]]
        else { return [] }
        
        return body.compactMap { json -> CLTextBlock? in
            guard let text = json["content"] as? String else { return nil }
            
            return CLTextBlock(
                title: json["name"] as? String,
                text: text
            )
        }
    }
}
