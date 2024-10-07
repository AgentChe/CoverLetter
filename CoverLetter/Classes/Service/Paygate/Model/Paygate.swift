//
//  Paygate.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

struct Paygate: Codable, Hashable {
    let leftOptionConfig: PaygateOptionConfig
    let rightOptionConfig: PaygateOptionConfig
}
