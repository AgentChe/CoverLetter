//
//  CLMakerHiringManagerCollector.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

final class CLMakerHiringManagerCollector {
    private var firstName: String?
    private var lastName: String?
    private var phoneNumber: String?
    private var email: String?
    private var gender: CLHiringManager.Gender?
}

// MARK: Public
extension CLMakerHiringManagerCollector {
    func make() -> CLHiringManager {
        CLHiringManager(
            firstName: firstName,
            lastName: lastName,
            phoneNumber: phoneNumber,
            email: email,
            gender: gender
        )
    }
}

// MARK: CLMakerHMWhoIsViewDelegate
extension CLMakerHiringManagerCollector: CLMakerHMWhoIsViewDelegate {
    func whoIs(firstName: String?, lastName: String?, phoneNumber: String?, email: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.phoneNumber = phoneNumber
        self.email = email
    }
}

// MARK: CLMakerHMGenderViewDelegate
extension CLMakerHiringManagerCollector: CLMakerHMGenderViewDelegate {
    func genderView(gender: CLHiringManager.Gender?) {
        self.gender = gender
    }
}
