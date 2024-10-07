//
//  CVMICollectionElement.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.08.2024.
//

enum CVMICollectionElement {
    case header
    case interest(CVMICollectionInterestElement)
}

final class CVMICollectionInterestElement {
    let interest: Interest
    var marked: Bool
    
    init(
        interest: Interest,
        marked: Bool
    ) {
        self.interest = interest
        self.marked = marked
    }
}
