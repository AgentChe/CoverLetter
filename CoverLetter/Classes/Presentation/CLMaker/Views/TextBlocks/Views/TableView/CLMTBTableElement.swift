//
//  CLMTBTableElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 31.08.2024.
//

enum CLMTBTableElement {
    case header
    case textBlock(CLMTBTableTextBlockElement)
}

final class CLMTBTableTextBlockElement {
    let name: String?
    var content: String
    
    init(textBlock: CLTextBlock) {
        self.name = textBlock.title
        self.content = textBlock.text
    }
}
