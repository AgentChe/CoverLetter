//
//  PaygateOptionConfig.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

struct PaygateOptionConfig: Codable, Hashable {
    let productId: String
    let line1: [PaygateOptionLineComponent]?
    let line2: [PaygateOptionLineComponent]?
    let line3: [PaygateOptionLineComponent]?
    let line4: [PaygateOptionLineComponent]?
    let line5: [PaygateOptionLineComponent]?
}
