//
//  CLMakerVacancyCollector.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

final class CLMakerVacancyCollector {
    private var link: String?
    private var position: String?
    private var description: String?
    private var resource: String?
}

// MARK: Public
extension CLMakerVacancyCollector {
    func make() -> CLVacancy {
        CLVacancy(
            link: link,
            position: position,
            description: description,
            resource: resource
        )
    }
}

// MARK: CLMakerVacancyPositionViewDelegate
extension CLMakerVacancyCollector: CLMakerVacancyPositionViewDelegate {
    func position(link: String?, position: String?, description: String?) {
        self.link = link
        self.position = position
        self.description = description
    }
}

// MARK: CLMakerVacancyResourceViewDelegate
extension CLMakerVacancyCollector: CLMakerVacancyResourceViewDelegate {
    func resource(_ resource: String?) {
        self.resource = resource
    }
}
