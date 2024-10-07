//
//  SelectCityTableElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

enum SelectCityTableElement {
    case country(Country)
    case city(City)
}

// MARK: Public
extension SelectCityTableElement {
    var name: String {
        switch self {
        case .country(let country):
            return country.name
        case .city(let city):
            return city
        }
    }
}
