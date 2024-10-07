//
//  PDFFactory.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import Foundation

enum PDFFactory {
    static func createCV(cv: CV) -> Data {
        switch cv.template.identifier {
        case .template1:
            return CV1Generator(profile: cv.profile).createPDF()
        case .template2:
            return CV2Generator(profile: cv.profile).createPDF()
        case .template3:
            return CV3Generator(profile: cv.profile).createPDF()
        case .template4:
            return CV4Generator(profile: cv.profile).createPDF()
        case .template5:
            return CV5Generator(profile: cv.profile).createPDF()
        case .template6:
            return CV6Generator(profile: cv.profile).createPDF()
        case .template7:
            return CV7Generator(profile: cv.profile).createPDF()
        case .template8:
            return CV8Generator(profile: cv.profile).createPDF()
        case .template9:
            return CV9Generator(profile: cv.profile).createPDF()
        case .template10:
            return CV10Generator(profile: cv.profile).createPDF()
        case .template11:
            return CV11Generator(profile: cv.profile).createPDF()
        case .template12:
            return CV12Generator(profile: cv.profile).createPDF()
        case .template13:
            return CV13Generator(profile: cv.profile).createPDF()
        case .template14:
            return CV14Generator(profile: cv.profile).createPDF()
        case .template15:
            return CV15Generator(profile: cv.profile).createPDF()
        case .template16:
            return CV16Generator(profile: cv.profile).createPDF()
        }
    }
    
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
