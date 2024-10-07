//
//  PDFFactory.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import Foundation

enum PDFFactory {
    static func createCL(cl: CL) -> Data {
        switch cl.template.identifier {
        case .template1:
            return CL1Generator(clInfo: cl.info).createPDF()
        case .template2:
            return CL2Generator(clInfo: cl.info).createPDF()
        case .template3:
            return CL3Generator(clInfo: cl.info).createPDF()
        case .template4:
            return CL4Generator(clInfo: cl.info).createPDF()
        case .template5:
            return CL5Generator(clInfo: cl.info).createPDF()
        case .template6:
            return CL6Generator(clInfo: cl.info).createPDF()
        case .template7:
            return CL7Generator(clInfo: cl.info).createPDF()
        }
    }
}
