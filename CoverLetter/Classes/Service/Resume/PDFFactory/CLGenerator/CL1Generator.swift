//
//  CL1Generator.swift
//  PDFGenerate
//
//  Created by Niiaz Khasanov on 8/28/24.
//

import UIKit
import PDFKit

class CL1Generator {
    var clInfo: CLInfo
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 60
    
    let lm1: CGFloat = 187
    let lm2: CGFloat = 175.0
    let lm3: CGFloat = 595 - 150 - 43
    
    let columnLeftWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 360
    let columnRightWidth: CGFloat = 150
    
    let textColor = UIColor.black
    
    var currentLeftYOffset: CGFloat =  60
    var currentYCenterOffset: CGFloat =  60
    var currentRightYOffset: CGFloat =  60
    
    let estimateHeight: CGFloat = 20.0
    let bottomMargin: CGFloat = 20
    
    var pageAndRectDashArray: [Int:[CGRect]] = [:]
    
    init(clInfo: CLInfo) {
        
        self.clInfo = clInfo
    }

    func createPDF() -> Data {
        
        let pdfMetaData = [
            kCGPDFContextCreator: "PDF Creator",
            kCGPDFContextAuthor: "Your Name",
            kCGPDFContextTitle: "Profile"
        ]
        
        let pdfData = NSMutableData()
        
        UIGraphicsBeginPDFContextToData(pdfData, CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pdfMetaData)
        
        
        var pages: [Int: [() -> Void]] = [:]
        var pageNumber = 0
        var pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
        
        drawDateinRightColumn(xOffset: 0, pageRect: pageRect, pages: &pages, pageNumber: &pageNumber)
        if let company = clInfo.company,
           let hiringManager = clInfo.hiringManager {
            drawHRContactsInCenterColumn(company: company,
                                         hrManager: hiringManager,
                                         xOffset: 40,
                                         pageRect: pageRect,
                                         pages: &pages,
                                         pageNumber: &pageNumber)
        }
        
     
        
        if let firstName = clInfo.personalInfo?.firstName,
           let lastName = clInfo.personalInfo?.lastName {
            drawGeneraInfoInRightColumn(firstName: firstName,
                                        lastName: lastName,
                                        xOffset: lm1,
                                        pageRect: pageRect,
                                        pages: &pages,
                                        pageNumber: &pageNumber)
        }
        
        currentYCenterOffset = 135
        if let textBlocks = clInfo.textBlocks, !textBlocks.isEmpty {
            for textBlock in textBlocks {
                let text = textBlock.text
                if text != "" {
                    drawTextBlocksInRightColumn(textBlock: text,
                                                xOffset: lm1,
                                                pageRect: pageRect,
                                                pages: &pages,
                                                pageNumber: &pageNumber)
                    currentYCenterOffset += 10
                }
            }
        }
        
//        email = "abcgoing@gmail.com"
//        if let email = email {
//            currentYCenterOffset += 15
//            if email != "" {
//                drawEmailInCenterColumn(email: email, xOffset: lm1, pageRect: pageRect, pages: &pages, pageNumber: &pageNumber)
//            }
//        }
        
        
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            let context = UIGraphicsGetCurrentContext()!
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            if page == 0 {
                if let backgroundImage = UIImage(named: "CL1BackgroundImage") {
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                }
            } else {
                if let backgroundImage = UIImage(named: "CL1_1BackgroundImage") {
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                }
            }
            pages[page]?.forEach { $0() }
            for (page_,rectArray) in pageAndRectDashArray {
                if page_ == page {
                    for rect in rectArray {
                        let context = UIGraphicsGetCurrentContext()!
                        if let image = UIImage(named: "CL3Circle") {
                            drawImage(image: image, context: context, pageRect: rect, at: rect.origin, size: rect.size)
                        }
                    }
                }
            }
        }
        UIGraphicsEndPDFContext()
        
        return pdfData as Data
    }
    
    
    func drawGeneraInfoInRightColumn(
        firstName: String,
        lastName: String,
        xOffset: CGFloat,
        pageRect: CGRect,
        pages: inout [Int: [() -> Void]],
        pageNumber: inout Int
    ) {
        var fullNameFontSize: CGFloat = 20
        var jobTitleFontSize: CGFloat = 16
        
        let fullNameTextColor = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
        let jobTitleTextColor = UIColor(red: 17/255, green: 17/255, blue: 24/255, alpha: 1.0)
        
        let fullNameParagraphStyle = NSMutableParagraphStyle()
        fullNameParagraphStyle.alignment = .left
        
        let jobTitleParagraphStyle = NSMutableParagraphStyle()
        jobTitleParagraphStyle.alignment = .left
        
        var fullNameFont = Fonts.Roboto.regular(size: fullNameFontSize)
        var jobTitleFont = Fonts.Roboto.regular(size: jobTitleFontSize)
        
        var fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: fullNameTextColor,
            .paragraphStyle: fullNameParagraphStyle
        ]
        
        var jobTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: jobTitleFont,
            .foregroundColor: jobTitleTextColor,
            .paragraphStyle: jobTitleParagraphStyle
        ]
        
        let fullName = "\(firstName) \(lastName)\n"
        var jobTitleAttributedString = NSMutableAttributedString(string: "", attributes: jobTitleAttributes)
        
        var fullNameAttributedString = NSMutableAttributedString(string: fullName, attributes: fullNameAttributes)
        fullNameAttributedString.append(jobTitleAttributedString)
        
        guard fullNameAttributedString.string != "" else { return }
        var remainingText = fullNameAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: pageWidth - 180 - 43, height: pageRect.height - bottomMargin - currentYCenterOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: pageWidth - 180 - 43)
            
            while textHeight > 50.0 {
                print("FontSize: \(fullNameFontSize)")
                fullNameFontSize -= 0.1
                jobTitleFontSize -= 0.1
                fullNameFont = Fonts.Roboto.bold(size: fullNameFontSize)
                jobTitleFont = Fonts.Roboto.regular(size: jobTitleFontSize)
                
               
                
                let fullNameAttributes: [NSAttributedString.Key: Any] = [.font: fullNameFont]
                let fullNameRange = NSRange(location: 0, length: fullName.count)
                fullNameAttributedString = NSMutableAttributedString(string: fullName, attributes: fullNameAttributes)

                let jobTitleAttributes: [NSAttributedString.Key: Any] = [.font: jobTitleFont]
                let jobTitleRange = NSRange(location: 0, length: "".count)
                jobTitleAttributedString = NSMutableAttributedString(string: "", attributes: jobTitleAttributes)
                
                fullNameAttributedString.append(jobTitleAttributedString)
                remainingText = fullNameAttributedString
                
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: pageWidth  - 180 - 43)
            }
            
            let adjustedTextRect = CGRect(x: textRect.minX, y: currentYCenterOffset, width: textRect.width, height: textRect.height)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: adjustedTextRect)
            }
            
            remainingText = remainder
            
            if remainingText.length > 0 {
                currentYCenterOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + 20
            }
        }
    }
    func drawHRContactsInCenterColumn(company: CLCompany,
                                      hrManager: CLHiringManager,
                                      xOffset: CGFloat,
                                      pageRect: CGRect,
                                      pages: inout [Int: [() -> Void]],
                                      pageNumber: inout Int) {
        
        let contactFont = Fonts.Roboto.regular(size: 11)
        let boldContactFont = Fonts.Roboto.bold(size: 11)
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.2
        
        let textColor = UIColor(red: 22/255, green: 21/255, blue: 61/255, alpha: 1.0)
        
        let regularAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
        ]
        
        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: boldContactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
        ]
        
        let resultedText = NSMutableAttributedString()
        
        if let firstName = hrManager.firstName, !firstName.isEmpty {
            let boldFirstName = NSAttributedString(string: "To\n" + firstName, attributes: boldAttributes)
            resultedText.append(boldFirstName)
        }
        
        if let lastName = hrManager.lastName, !lastName.isEmpty {
            let boldLastName = NSAttributedString(string: " " + lastName + "\n", attributes: boldAttributes)
            resultedText.append(boldLastName)
        } else {
            resultedText.append(NSAttributedString(string: "\n", attributes: regularAttributes))
        }
        
        if let address = company.address, !address.isEmpty {
            let regularAddress = NSAttributedString(string: address, attributes: regularAttributes)
            resultedText.append(regularAddress)
        }
        
        var text = resultedText
        guard text.length > 0 else { return }
        
        while text.length > 0 {
           
            
            let textRect = CGRect(x: 40, y: 219, width: 130, height: pageRect.height - bottomMargin - currentYCenterOffset)
            
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: text)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: 300)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            text = remainder
            
            if text.length > 0 {
              //  currentYCenterOffset = margin
                pageNumber += 1
            } else {
              //  currentYCenterOffset += textHeight + 15
            }
        }
    }

    func drawDateinRightColumn( xOffset: CGFloat,
                                pageRect: CGRect,
                                pages: inout [Int: [() -> Void]],
                                pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Roboto.regular(size: 12)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .right
        contactParagraphStyle.lineHeightMultiple = 1
        
        let textColor = UIColor.black
    
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMMM yyyy"
        let formattedDate = dateFormatter.string(from: Date())
        var resultedText = formattedDate
      
      
        var text = resultedText
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
//            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
//                currentRightYOffset = margin
//                pageNumber += 1
//            }
            
            let textRect = CGRect(x: xOffset , y: 410, width: 167, height: 30)
          
            
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: 167, attributes: textAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
        
                if !remainingText.isEmpty {
            //        currentRightYOffset = margin
                    pageNumber += 1
                } else {
                //    currentRightYOffset += textHeight + 15
                }
            
        }
        
        text = remainingText
    }
     func drawTextBlocksInRightColumn(
        textBlock: String,
        xOffset: CGFloat,
        pageRect: CGRect,
        pages: inout [Int: [() -> Void]],
        pageNumber: inout Int
    ) {
        // Default attributes for the body text
        let bodyFont = Fonts.Roboto.regular(size: 13)
        let bodyTextColor = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        paragraphStyle.paragraphSpacing = 8.0
        
        var bodyAttributes: [NSAttributedString.Key: Any] = [
            .font: bodyFont,
            .foregroundColor: bodyTextColor,
           // .paragraphStyle: paragraphStyle
        ]
        
        // Custom attributes for the greeting (header)
        let headerFont = Fonts.Roboto.bold(size: 14)
        let headerTextColor = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
        let headerAttributes: [NSAttributedString.Key: Any] = [
            .font: headerFont,
            .foregroundColor: headerTextColor,
            .paragraphStyle: paragraphStyle
        ]
        
        // Greetings we want to apply special styling to
        let headers = ["Dear Hiring Manager,", "Dear Hiring Manager,\n", "Hello Company", "Hello Team"]
        var headerPart = ""
        var bodyPart = textBlock
        
        // Check if the textBlock starts with one of the headers
        for header in headers {
            if textBlock.hasPrefix(header) {
                headerPart = header + (header.hasSuffix("\n") ? "" : "\n")
                bodyPart = String(textBlock.dropFirst(header.count)) // remove header part from body
                break
            }
        }
        
        // Create attributed string for the whole text
        let attributedText = NSMutableAttributedString()
        
        if !headerPart.isEmpty {
            // Add header part with specific styling
            let headerAttributedString = NSAttributedString(string: headerPart , attributes: headerAttributes)
            attributedText.append(headerAttributedString)
        }
        
        // Add the body part with the default styling
        let bodyAttributedString = NSAttributedString(string: bodyPart, attributes: bodyAttributes)
        attributedText.append(bodyAttributedString)
        
        // Now handle the drawing and text splitting
        var remainingText = attributedText
        guard remainingText.length > 0 else { return }

        while remainingText.length > 0 {
            // Check for page height and whether we need to start a new page
            if pageRect.height - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }

            let textRect = CGRect(
                x: xOffset,
                y: currentYCenterOffset,
                width: pageWidth - 2 * lm1,
                height: pageRect.height - bottomMargin - currentYCenterOffset
            )

            // Split text to fit in the current textRect
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: pageWidth - 2 * lm1)

            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }

            remainingText = remainder

            if remainingText.length > 0 {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight
            }
        }
    }
    func drawEmailInCenterColumn(email:String, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Roboto.regular(size: 16)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor(red: 72/255, green: 72/255, blue: 72/255, alpha: 1.0)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = email
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset + 30, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset)
          
            let topOffset: CGFloat = 4
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  15, height:  15)
           
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
            }
            
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth, attributes: textAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
        
                if !remainingText.isEmpty {
                    currentYCenterOffset = margin
                    pageNumber += 1
                } else {
                    currentYCenterOffset += textHeight + 15
                }
            
        }
        
        text = remainingText
    }


}

extension CL1Generator {
    
    func splitTextToFit(rect: CGRect, text: String, attributes: [NSAttributedString.Key: Any]) -> (String, String) {
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        
        var fitRange = CFRange(location: 0, length: 0)
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: attributedText.length), nil, rect.size, &fitRange)
        
        let index = fitRange.location + fitRange.length
        let fitString = (text as NSString).substring(to: index)
        let remainderString = (text as NSString).substring(from: index)
        
        return (fitString, remainderString)
    }
    func splitTextToFit(rect: CGRect, text: NSMutableAttributedString) -> (NSMutableAttributedString, NSMutableAttributedString) {
        let framesetter = CTFramesetterCreateWithAttributedString(text)
        
        var fitRange = CFRange(location: 0, length: 0)
        CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: text.length), nil, rect.size, &fitRange)
        
        let index = fitRange.location + fitRange.length
        
        let fitString = text.attributedSubstring(from: NSRange(location: 0, length: index))
        let remainderString = text.attributedSubstring(from: NSRange(location: index, length: text.length - index))
        
        return (NSMutableAttributedString(attributedString: fitString), NSMutableAttributedString(attributedString: remainderString))
    }
    
    func calculateTextHeight(text: String, width: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRange(location: 0, length: attributedText.length), nil, CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), nil)
        return suggestedSize.height
    }
    func calculateTextHeight(text: NSMutableAttributedString, width: CGFloat) -> CGFloat {
        let framesetter = CTFramesetterCreateWithAttributedString(text)
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRange(location: 0, length: text.length),
            nil,
            CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            nil
        )
        return suggestedSize.height
    }
    func drawBackground(context: CGContext, pageRect: CGRect, image: UIImage) {
          context.saveGState()
          context.translateBy(x: 0, y: pageRect.size.height)
          context.scaleBy(x: 1.0, y: -1.0)
          context.draw(image.cgImage!, in: pageRect)
          context.restoreGState()
      }
    func drawCircularImage(image: UIImage, context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        
        // Flip the coordinate system to PDF coordinate system (bottom-left is (0, 0))
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Calculate the circular clipping path
        let radius = min(size.width, size.height) / 2
        let center = CGPoint(x: point.x + radius, y: pageRect.size.height - point.y - radius)
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        context.addPath(circularPath.cgPath)
        context.clip()
        
        // Draw the image within the circular path
        let imageRect = CGRect(x: point.x, y: pageRect.size.height - point.y - size.height, width: size.width, height: size.height)
        context.draw(image.cgImage!, in: imageRect)
        
        context.restoreGState()
    }
    func calculateTextWidth(text: String, height: CGFloat, attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        let attributedText = NSAttributedString(string: text, attributes: attributes)
        let framesetter = CTFramesetterCreateWithAttributedString(attributedText)
        
        // Calculate the suggested size with a fixed height and infinite width
        let suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(
            framesetter,
            CFRange(location: 0, length: attributedText.length),
            nil,
            CGSize(width: CGFloat.greatestFiniteMagnitude, height: height),
            nil
        )
        
        return suggestedSize.width
    }
    func drawImage(image: UIImage, context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let imageSize = image.size
        let aspectWidth = size.width / imageSize.width
        let aspectHeight = size.height / imageSize.height
        let aspectRatio = min(aspectWidth, aspectHeight) // Use min for aspect fit
        
        let scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        
        let imageRect = CGRect(
            x: point.x + (size.width - scaledImageSize.width) / 2,
            y: pageRect.size.height - point.y - (size.height - scaledImageSize.height) / 2 - scaledImageSize.height,
            width: scaledImageSize.width,
            height: scaledImageSize.height
        )
        
        context.draw(image.cgImage!, in: imageRect)
        context.restoreGState()
    }

}
