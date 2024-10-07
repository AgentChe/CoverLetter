//
//  CVMakerGeneralInfoCollector.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 21.05.2024.
//

final class CVMakerGeneralInfoCollector {
    private var firstName: String?
    private var lastName: String?
    private var aboutYourself: String?
    private var contactInfo: ContactInfo?
    private var photoFileName: String?
}

// MARK: Public
extension CVMakerGeneralInfoCollector {
    func make() -> GeneralInfo {
        GeneralInfo(
            firstName: firstName,
            lastName: lastName,
            aboutYourself: aboutYourself,
            contactInfo: contactInfo,
            photoFileName: photoFileName
        )
    }
}

// MARK: CVMakerGeneralInfoNameViewDelegate
extension CVMakerGeneralInfoCollector: CVMakerGeneralInfoNameViewDelegate {
    func generalInfo(firstName: String, lastName: String) {
        self.firstName = firstName
        self.lastName = lastName
    }
}

// MARK: CVMakerGeneralInfoAboutYourselfViewDelegate
extension CVMakerGeneralInfoCollector: CVMakerGeneralInfoAboutYourselfViewDelegate {
    func generalInfo(aboutYourself: String?) {
        self.aboutYourself = aboutYourself
    }
}

// MARK: CVMakerGeneralInfoContactInfoViewDelegate
extension CVMakerGeneralInfoCollector: CVMakerGeneralInfoContactInfoViewDelegate {
    func generalInfo(contactInfo: ContactInfo) {
        self.contactInfo = contactInfo
    }
}

// MARK: CVMakerGeneralInfoPhotoViewDelegate
extension CVMakerGeneralInfoCollector: CVMakerGeneralInfoPhotoViewDelegate {
    func generalInfo(photoFileName: String?) {
        self.photoFileName = photoFileName
    }
}
