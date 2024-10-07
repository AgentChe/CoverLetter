//
//  Profile.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 20.05.2024.
//

import Foundation

struct Profile: Codable {
    let generalInfo: GeneralInfo?
    let workExperiences: [WorkExperience]?
    let educations: [Education]?
    let professionalSkills: [ProfessionalSkill]?
    let languages: [Language]?
    let interests: [Interest]?
    let certificates: [Certificate]?
    let socialMedia: SocialMedia?
    let references: [Reference]?
}
