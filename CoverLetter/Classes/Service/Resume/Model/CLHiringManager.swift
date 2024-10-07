//
//  CLHiringManager.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

struct CLHiringManager: Codable {
    enum Gender: Int, Codable {
        case male, female
    }
    
    let firstName: String?
    let lastName: String?
    let phoneNumber: String?
    let email: String?
    let gender: Gender?
}
