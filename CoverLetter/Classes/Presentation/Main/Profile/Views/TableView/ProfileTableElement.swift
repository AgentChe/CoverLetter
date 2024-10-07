//
//  ProfileTableElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 28.08.2024.
//

enum ProfileTableElement {
    case info(ProfileTableInfoElement)
    case cvMakerChapter(ProfileTableCVMakerChapterElement)
}

struct ProfileTableInfoElement {
    let photoFileName: String?
    let firstName: String?
    let lastName: String?
    let jobTitle: String?
}

enum ProfileTableCVMakerChapterElement {
    case generalInfo
    case workExperience
    case education
    case professionalSkills
    case languages
    case interests
    case certificates
    case socialMedia
    case references
}
