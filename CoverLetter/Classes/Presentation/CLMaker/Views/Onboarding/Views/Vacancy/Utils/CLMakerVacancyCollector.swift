//
//  CLMakerVacancyCollector.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

final class CLMakerVacancyCollector {
    private var position: String?
    private var resource: String?
}

// MARK: Public
extension CLMakerVacancyCollector {
    func make() -> CLVacancy {
        CLVacancy(
            position: position,
            resource: resource
        )
    }
}

// MARK: CLMakerVacancyPositionViewDelegate
extension CLMakerVacancyCollector: CLMakerVacancyPositionViewDelegate {
    func position(_ position: String?) {
        self.position = position
    }
}

// MARK: CLMakerVacancyResourceViewDelegate
extension CLMakerVacancyCollector: CLMakerVacancyResourceViewDelegate {
    func resource(_ resource: String?) {
        self.resource = resource
    }
}
