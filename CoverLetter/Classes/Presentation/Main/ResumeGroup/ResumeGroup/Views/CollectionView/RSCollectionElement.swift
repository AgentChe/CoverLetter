//
//  RSCollectionElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 29.08.2024.
//

import Foundation

struct RSCollectionElement {
    enum Entity {
        case cv(CV)
        case cl(CL)
    }
    
    let entity: Entity
    let templateName: String
    let title: String
    let date: String
    
    private static let ddMMMMFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        formatter.locale = Locale.current
        return formatter
    }()
    
    init(entity: Entity) {
        self.entity = entity
        
        self.templateName = {
            switch entity {
            case .cv(let cv):
                return "CVTemplate.\(cv.template.identifier.rawValue + 1)"
            case .cl(let cl):
                return "CLTemplate.\(cl.template.identifier.rawValue + 1)"
            }
        }()
        
        self.title = {
            switch entity {
            case .cv(let cv):
                return String(format: "ResumeGroup.CV.Title".localized, cv.template.identifier.rawValue + 1)
            case .cl(let cl):
                return String(format: "ResumeGroup.CL.Title".localized, cl.template.identifier.rawValue + 1)
            }
        }()
        
        self.date = {
            switch entity {
            case .cv(let cv):
                if let edited = cv.edited {
                    return String(format: "ResumeGroup.Edited".localized, Self.ddMMMMFormatter.string(from: edited))
                } else {
                    return String(format: "ResumeGroup.Created".localized, Self.ddMMMMFormatter.string(from: cv.created))
                }
            case .cl(let cl):
                if let edited = cl.edited {
                    return String(format: "ResumeGroup.Edited".localized, Self.ddMMMMFormatter.string(from: edited))
                } else {
                    return String(format: "ResumeGroup.Created".localized, Self.ddMMMMFormatter.string(from: cl.created))
                }
            }
        }()
    }
}
