//
//  CL1Generator.swift
//  PDFGenerate
//
//  Created by Niiaz Khasanov on 8/28/24.
//

import UIKit
import PDFKit

class CL3Generator {
    var clInfo: CLInfo
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 56.0
    
    let lm1: CGFloat = 43.0
    let lm2: CGFloat = 175.0
    let lm3: CGFloat = 595 - 150 - 43
    
    let columnLeftWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 360
    let columnRightWidth: CGFloat = 150
    
    let textColor = UIColor.black
    
    var currentLeftYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    var currentRightYOffset: CGFloat =  40
    
    let estimateHeight: CGFloat = 20.0
    let bottomMargin: CGFloat = 20
    
    var firstName: String?
    var lastName: String?
    
    var jobTitle:String?
    var email: String?
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
        
        firstName = clInfo.personalInfo?.firstName
        lastName = clInfo.personalInfo?.lastName
        
        
        if let firstName = firstName,
           let lastName = lastName {
            drawGeneraInfoInRightColumn(firstName: firstName, 
                                        lastName: lastName,
                                        xOffset: lm1,
                                        pageRect: pageRect,
                                        pages: &pages,
                                        pageNumber: &pageNumber)
        }
        
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
        
        if let email = email {
            currentYCenterOffset += 15
            if email != "" {
                drawEmailInCenterColumn(email: email, xOffset: lm1, pageRect: pageRect, pages: &pages, pageNumber: &pageNumber)
            }
        }
        
        
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            let context = UIGraphicsGetCurrentContext()!
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            if let backgroundImage = UIImage(named: "PDF2BackgroundImage") {
                drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
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
        
        var fullNameFont = Fonts.Outfit.semiBold(size: fullNameFontSize)
        var jobTitleFont = Fonts.Outfit.regular(size: jobTitleFontSize)
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: fullNameTextColor,
            .paragraphStyle: fullNameParagraphStyle
        ]
        
        let jobTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: jobTitleFont,
            .foregroundColor: jobTitleTextColor,
            .paragraphStyle: jobTitleParagraphStyle
        ]
        
        let fullName = "\(firstName) \(lastName)\n"
        let jobTitleAttributedString = NSMutableAttributedString(string: "", attributes: jobTitleAttributes)
        
        let fullNameAttributedString = NSMutableAttributedString(string: fullName, attributes: fullNameAttributes)
        fullNameAttributedString.append(jobTitleAttributedString)
        
        guard fullNameAttributedString.string != "" else { return }
        var remainingText = fullNameAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: pageRect.height - bottomMargin - currentYCenterOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: pageWidth - 2*lm1)
            
            while textHeight > 60.0 {
                print("FontSize: \(fullNameFontSize)")
                fullNameFontSize -= 0.3
                jobTitleFontSize -= 0.3
                fullNameFont = Fonts.Manrope.bold(size: fullNameFontSize)
                jobTitleFont = Fonts.Manrope.regular(size: jobTitleFontSize)
                
                fullNameAttributedString.addAttributes([.font: fullNameFont], range: NSRange(location: 0, length: fullName.count))
                jobTitleAttributedString.addAttributes([.font: jobTitleFont], range: NSRange(location: 0, length: jobTitleAttributedString.length))
                
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: 250)
            }
            
            let adjustedTextRect = CGRect(x: textRect.minX, y: (123 - textHeight) / 2, width: textRect.width, height: textRect.height)
            
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
                currentYCenterOffset += textHeight + 8
            }
        }
    }
     func drawTextBlocksInRightColumn(
        textBlock: String,
        xOffset: CGFloat,
        pageRect: CGRect,
        pages: inout [Int: [() -> Void]],
        pageNumber: inout Int
    ) {
        // Default attributes for the body text
        let bodyFont = Fonts.Outfit.regular(size: 13)
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
        let headerFont = Fonts.Outfit.semiBold(size: 19)
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
            let headerAttributedString = NSAttributedString(string: headerPart, attributes: headerAttributes)
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
        
        
        let contactFont = Fonts.Outfit.regular(size: 16)
        
        
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

extension CL3Generator {
    
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
