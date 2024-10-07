//
//  CVMTemplatesCollectionElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

enum CVMTemplatesCollectionElement {
    case header
    case template(CVMTemplatesCollectionTemplateElement)
}

final class CVMTemplatesCollectionTemplateElement {
    let template: CVTemplate
    var marked: Bool
    
    init(
        template: CVTemplate,
        marked: Bool = false
    ) {
        self.template = template
        self.marked = marked
    }
}
