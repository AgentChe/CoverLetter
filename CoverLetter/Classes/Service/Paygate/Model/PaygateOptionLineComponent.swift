//
//  PaygateOptionLineComponent.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import UIKit

struct PaygateOptionLineComponent: Codable, Hashable {
    enum Component: Codable, Hashable {
        case text(String)
        case price(Int)
        case promo(String)
    }
    
    enum Weight: Codable, Hashable {
        case bold(CGFloat)
        case semiBold(CGFloat)
        case regular(CGFloat)
    }
    
    let component: Component
    let weight: Weight
}
