//
//  CLMTemplatesCollectionElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

enum CLMTemplatesCollectionElement {
    case header
    case template(CLMTemplatesCollectionTemplateElement)
}

final class CLMTemplatesCollectionTemplateElement {
    let template: CLTemplate
    var marked: Bool
    
    init(
        template: CLTemplate,
        marked: Bool = false
    ) {
        self.template = template
        self.marked = marked
    }
}
