//
//  CLInfo.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

struct CLInfo: Codable {
    let personalInfo: CLPersonalInfo?
    let company: CLCompany?
    let hiringManager: CLHiringManager?
    let vacancy: CLVacancy?
    let toneOfVoice: CLToneOfVoice?
    let textBlocks: [CLTextBlock]?
}
