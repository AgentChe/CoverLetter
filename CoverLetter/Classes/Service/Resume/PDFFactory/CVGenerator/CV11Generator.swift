import UIKit
import PDFKit

class CV11Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 8.5 * 72.0
    let pageHeight : CGFloat = 11 * 72.0
    
    let margin: CGFloat = 40.0
    var centerMargin: CGFloat = 40.0
    
    
    let lm1: CGFloat = 450
    let lm2: CGFloat = 43.0
    let columnWidth: CGFloat = 180
    let columnCenterWidth: CGFloat = 365
    var aboutYourSelfHeight: CGFloat = 0
    let font = UIFont.systemFont(ofSize: 12)
    let textColor = UIColor.black
    var currentYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40

    var secondPlusYOffset: CGFloat = 120
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 65
    
    var rectAndLinkDict: [String: CGRect] = [:]
    var pageAndLinksDict: [Int: [String]] = [:]
    
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
        if let generalInfo = profile.generalInfo {
            drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber, checkTheNextText:(generalInfo.aboutYourself ?? ""))
            
            drawAboutYourselfInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            
            if currentYOffset < 150 { currentYOffset = 150 }
            centerMargin = currentYOffset
            currentYCenterOffset = centerMargin
            if let contactInfo = generalInfo.contactInfo {
                
                drawContactsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                drawContactsDescriptionInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
        }
        
        
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {
            
            drawSkiilsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
        
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }) {
            drawSkiilsDescriptionInRightColumn(professionalSkills: professionalSkills, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
        
        if let languages = profile.languages, !languages.isEmpty {
            
            drawLanguagesInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawLanguagesDescriptionInRightColumn(languages: languages, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
        
     
        
        if let interests = profile.interests?.map({ $0.name }), !interests.isEmpty {
            
            drawInterestsInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawInterestsDescriptionInRightColumn(interests: interests, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
      
        if let socialMedia = profile.socialMedia {
            let instagramExist = socialMedia.instagram != "" && socialMedia.instagram != nil
            let facebookExist =  socialMedia.facebook != "" && socialMedia.facebook != nil
            let linkedIndExist = socialMedia.linkedIn != "" && socialMedia.linkedIn != nil
            let twitterExist = socialMedia.twitter != "" && socialMedia.twitter != nil
            
            if instagramExist || facebookExist || linkedIndExist || twitterExist {
                drawLinksMediaInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                
                if socialMedia.instagram != "" && socialMedia.instagram != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.instagram!, type: "Instagram", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.facebook != "" && socialMedia.facebook != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.facebook!, type: "Facebook", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.linkedIn!, type: "LinkedIn", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.twitter != "" && socialMedia.twitter != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.twitter!, type: "Twitter", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
            }
         
        }
        // Draw second column text starting from the first page
        
        pageNumber = 0
        //        if let generalInfo = profile.generalInfo {
        //            drawContactInfoInCenterColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        //        }
      
        if let workExperiences = profile.workExperiences, !workExperiences.isEmpty {
            drawWorkExperienceInCenterColumn (xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            for i in 0..<workExperiences.count  {
                drawWorkExperienceDescriptionInCenterColumn(workExperience: workExperiences[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber, isLast: i == workExperiences.count - 1 ? true : false)
            }
        }
        if let educations = profile.educations, !educations.isEmpty {
            drawEducationInCenterColumn (xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            for i in 0..<educations.count {
                drawEducationeDescriptionInCenterColumn(education: educations[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
            }
        }
        if let certificates = profile.certificates, !certificates.isEmpty {
            drawCertificatesInCenterColumn(xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<certificates.count {
                drawCertificateDescriptionInCenterColumn(certificate: certificates[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
        }
        
        
        // Render pages
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            if let backgroundImage = UIImage(named: "PDF11BackgroundImage") {
                let context = UIGraphicsGetCurrentContext()!
                let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
            }
            pages[page]?.forEach { $0() }
        }
        
        UIGraphicsEndPDFContext()
        if let pdfDocument = PDFDocument(data: pdfData as Data) {
            for page_ in 0..<pages.count {
                
                print("page_ \(page_)")
                let topMarginForSM: CGFloat = currentYCenterOffset
                
                    if let page = pdfDocument.page(at: page_) {
                        if let linksArray = pageAndLinksDict[page_] {
                            for link in linksArray {
                                // let imageRect = CGRect(x: 0, y: pageHeight - 40 - 56 , width: 56, height: 56)
                                if let rect = rectAndLinkDict[link] {
                                    var adaptedRect = CGRect(x: rect.minX,
                                                             y: pageHeight -  rect.origin.y - 1.8*rect.height ,
                                                             width: rect.width,
                                                             height: rect.height)
                                    let linkAnnotation = PDFAnnotation(bounds: adaptedRect, forType: .link, withProperties: nil)
                                    linkAnnotation.url = URL(string: link)!
                                    page.addAnnotation(linkAnnotation)
                                }
                            }
                        }
                    }
                   
                }
                return pdfDocument.dataRepresentation() ?? Data()
            }
        
        return pdfData as Data
    }
    
    func drawGeneraInfoInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        var fontSize: CGFloat = 45
        
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 1.0
        
        
        if let firstName = generalInfo.firstName, !firstName.isEmpty {
            var fullName:String = firstName
            
            if let lastName = generalInfo.lastName, !lastName.isEmpty {
                fullName += " \(lastName)"
            }
            let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.bold(size: fontSize),
                .foregroundColor: UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(fullName)", attributes: fullManeTitleAttributes)
            
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        
        var jobTitle = ""
        if let reference = profile.workExperiences?.first {
            if let jobTitle_ = reference.jobTitle {
                if jobTitle_ != "" {
                    jobTitle = jobTitle_
                    let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Poppins.bold(size: 12),
                        .foregroundColor:  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7),
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedjobTitileText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
                    combinedAttributedString.append(attributedjobTitileText)
                }
            }
        }
     
  
        
        var remainingText = combinedAttributedString
        
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin   - currentYOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            while textHeight > 130.0 {
                fontSize -= 0.3
                
                var combinedAttributedString = NSMutableAttributedString()
                let companyAndJobParagraphStyle = NSMutableParagraphStyle()
                companyAndJobParagraphStyle.lineHeightMultiple = 0.9
                
                
                if let firstName = generalInfo.firstName, !firstName.isEmpty {
                    var fullName:String = firstName
                    
                    if let lastName = generalInfo.lastName, !lastName.isEmpty {
                        fullName += " \(lastName)"
                    }
                    let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Poppins.bold(size: fontSize),
                        .foregroundColor: UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 1.0),
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedJobTitleText = NSAttributedString(string: "\(fullName)", attributes: fullManeTitleAttributes)
                    
                    combinedAttributedString.append(attributedJobTitleText)
                }
                
                
                var jobTitle = ""
                if let reference = profile.workExperiences?.first {
                    if let jobTitle_ = reference.jobTitle {
                        if jobTitle_ != "" {
                            jobTitle = jobTitle_
                        }
                    }
                }
                let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: Fonts.Poppins.bold(size: 12),
                    .foregroundColor:  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7),
                    .paragraphStyle: companyAndJobParagraphStyle
                ]
                let attributedjobTitileText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
                combinedAttributedString.append(attributedjobTitileText)
              
                var remainingText = combinedAttributedString
                
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                
                
                textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
                print("textHeight: \(textHeight)")
                
                
                
            }
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if remainingText.length > 0  {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
        }
        
    }
    
    
    
    func drawAboutYourselfInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 9)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "\(generalInfo.aboutYourself ?? "")"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    func drawContactsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.bold(size: 15)
        let textColor = UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        var text = "DETAILS".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYOffset = centerMargin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawContactsDescriptionInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 9)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
   
        // Paragraph style for bold text (headers)
        let boldParagraphStyle = NSMutableParagraphStyle()
        boldParagraphStyle.paragraphSpacing = 3.0
        boldParagraphStyle.alignment = .left

        // Paragraph style for regular text
        let regularParagraphStyle = NSMutableParagraphStyle()
        regularParagraphStyle.lineHeightMultiple = 1
        regularParagraphStyle.paragraphSpacing = 9.0
        regularParagraphStyle.alignment = .left


        guard let contactInfo = generalInfo.contactInfo else { return }

        let boldFont = Fonts.Poppins.bold(size: 10) // Use a bold font for headers

        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: regularParagraphStyle
        ]

        let boldAttributes: [NSAttributedString.Key: Any] = [
            .font: boldFont,
            .foregroundColor: textColor,
            .paragraphStyle: boldParagraphStyle
        ]

        let combinedAttributedString = NSMutableAttributedString()

        if let address = contactInfo.homeAddress, !address.isEmpty {
            let addressHeader = NSAttributedString(string: "Address\n", attributes: boldAttributes)
            let addressText = NSAttributedString(string: address + "\n", attributes: fullNameAttributes)
            combinedAttributedString.append(addressHeader)
            combinedAttributedString.append(addressText)
        }

        if let phone = contactInfo.phone, !phone.isEmpty {
            let phoneHeader = NSAttributedString(string: "Phone\n", attributes: boldAttributes)
            let phoneText = NSAttributedString(string: phone + "\n", attributes: fullNameAttributes)
            combinedAttributedString.append(phoneHeader)
            combinedAttributedString.append(phoneText)
        }

        if let email = contactInfo.email, !email.isEmpty {
            let emailHeader = NSAttributedString(string: "Email\n", attributes: boldAttributes)
            let emailText = NSAttributedString(string: email + "\n", attributes: fullNameAttributes)
            combinedAttributedString.append(emailHeader)
            combinedAttributedString.append(emailText)
        }
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset )
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if remainingText.length > 0   {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
    }
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.bold(size: 15)
        let textColor =  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "SKILLS".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if !remainingText.isEmpty   {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsDescriptionInRightColumn(professionalSkills: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        for skill in professionalSkills {
            if skill != "" {
                text += "•  \(skill)\n"
            }
        }
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.bold(size: 15)
        let textColor =  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "LANGUAGES".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if !remainingText.isEmpty {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesDescriptionInRightColumn(languages: [Language], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        for language in languages {
            if language.name != "" {
                text +=  "\(language.name)  |   \(language.level)\n"
            }
        }
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height  - bottomMargin - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksMediaInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.bold(size: 15)
        let textColor =  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "LINKS".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }
            
            
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
        
           
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    func drawLinksDescriptionInRightColumn(socialMedia: String, type: String, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Poppins.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = type
       
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            rectAndLinkDict[socialMedia] = CGRect(x: textRect.minX, y: textRect.minY, width: textRect.width, height: fullNameFont.pointSize)
          
            if var linksArray = pageAndLinksDict[pageNumber] {
                linksArray.append(socialMedia)
                pageAndLinksDict[pageNumber] = linksArray
            } else {
                pageAndLinksDict[pageNumber] = [socialMedia]
            }
           
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight
            }
            
        }

        text = remainingText
    }
    func drawLinksDescriptionInRightColumn(socialMedia: SocialMedia, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        if socialMedia.instagram != "" && socialMedia.instagram != nil {
            text += socialMedia.instagram! + "\n"
        }
        if socialMedia.facebook != "" && socialMedia.facebook != nil {
            text += socialMedia.facebook! + "\n"
        }
        if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil {
            text += socialMedia.linkedIn! + "\n"
        }
        if socialMedia.twitter != "" && socialMedia.twitter != nil {
            text += socialMedia.twitter! + "\n"
        }
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin   - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if !remainingText.isEmpty {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.bold(size: 15)
        let textColor =  UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "INTERESTS".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if !remainingText.isEmpty   {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawInterestsDescriptionInRightColumn(interests: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Poppins.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        for interest in interests {
            if interest != "" {
                text += "•  \(interest)" + "\n"
            }
        }
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset  - bottomMargin < estimateHeight {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
             
            if !remainingText.isEmpty  {
                currentYOffset = secondPlusYOffset
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    //MARK: - Center
    func drawContactInfoInCenterColumn(generalInfo: GeneralInfo , xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        if let contactInfo = generalInfo.contactInfo {
            
            let contactFont = Fonts.Poppins.medium(size: 10)
            let vertOffset = 7
            let contactParagraphStyle = NSMutableParagraphStyle()
            contactParagraphStyle.alignment = .right
            contactParagraphStyle.lineHeightMultiple = 1.3
            
            
            let textColor = UIColor(red: 0/255, green: 91/255, blue: 162/255, alpha: 1)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: textColor,
                .paragraphStyle: contactParagraphStyle
                
            ]
            
            var text = ""
            if let website = contactInfo.website {
                if website != "" {
                    text += website + "\n"
                }
            }
            if let email = contactInfo.email {
                if email != "" {
                    text += email + "\n"
                }
            }
            if let phone = contactInfo.phone {
                if phone != "" {
                    text += phone + "\n"
                }
            }
            guard text != "" else { return }
            var remainingText = text
            
            
            while !remainingText.isEmpty {
                
                let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
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
                    currentYCenterOffset += textHeight + 25
                }
            }
            
            text = remainingText
        }
    }
    
    func drawWorkExperienceInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ) {
        
        let contactFont = Fonts.Poppins.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "EXPERIENCE".capitalized
        
        var remainingText = text
        
        guard text != "" else { return }
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
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
                    currentYCenterOffset += textHeight + 12.5
                }
            }
        
        
        
        text = remainingText
    }
    
    func drawWorkExperienceDescriptionInCenterColumn(workExperience: WorkExperience, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ,isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let companyName = workExperience.companyName, !companyName.isEmpty {
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(companyName)", attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
     
      
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = workExperience.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = workExperience.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 9),
                .foregroundColor: UIColor(white: 0, alpha: 0.7),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        if let results = workExperience.results, !results.isEmpty {
            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 9),
                .foregroundColor: UIColor(white: 0, alpha: 0.7)
            ]
            let attributedResultsText = NSAttributedString(string: "\n\(results)", attributes: resultsAttributes)
            combinedAttributedString.append(attributedResultsText)
        }
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
         
                if remainingText.length > 0 {
                    currentYCenterOffset = margin
                    pageNumber += 1
                } else {
                    currentYCenterOffset += textHeight + (isLast ? 30 : 15)
                }
            }
        
    }
    
    func drawEducationInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Poppins.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "EDUCATION".capitalized
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset)
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
    
    func drawEducationeDescriptionInCenterColumn(education: Education, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let university = education.university, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font:  Fonts.Poppins.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: " \(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 9),
                .foregroundColor: UIColor(white: 0, alpha: 0.7),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
//            if let degree = education.degree, !degree.isEmpty {
//                fieldOfStudy += " (\(degree))"
//            }
            let attributedJobTitleText = NSAttributedString(string: "\n\(fieldOfStudy)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
     
        
    
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = education.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = education.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 9),
                .foregroundColor: UIColor(white: 0, alpha: 0.7),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: ", \(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
         
                if remainingText.length > 0 {
                    currentYCenterOffset = margin
                    pageNumber += 1
                } else {
                    currentYCenterOffset += textHeight + (isLast ? 30 : 15)
                }
            
        }
    }
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Poppins.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor(red: 0/255, green: 53/255, blue: 107/255, alpha: 0.7)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "CERTIFICATES".capitalized
   
        guard text != "" else { return }
        var remainingText = text
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin   - currentYCenterOffset)
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
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.bold(size: 12),
                .foregroundColor: UIColor(red: 0/255, green: 91/255, blue: 162/255, alpha: 1),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            
            let attributedJobTitleText = NSAttributedString(string: "\(description) @", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: " \(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = certificate.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = certificate.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Poppins.regular(size: 8),
                .foregroundColor: UIColor.gray,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin   - currentYCenterOffset )
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
            
            if remainingText.length > 0 {
                currentYCenterOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
}











extension CV11Generator {
    
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
    
}
