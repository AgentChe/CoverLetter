//
//  GeneralInfo.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

struct GeneralInfo: Codable {
    let firstName: String?
    let lastName: String?
    let aboutYourself: String?
    let contactInfo: ContactInfo?
    let photoFileName: String?
}
