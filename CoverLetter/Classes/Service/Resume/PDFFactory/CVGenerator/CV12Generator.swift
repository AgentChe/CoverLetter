import UIKit
import PDFKit


class CV12Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 40.0
    var centerMargin: CGFloat = 40.0
    
    
    let lm1: CGFloat = 43.0
    let lm2: CGFloat = 280.0
    let columnWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 270
    var aboutYourSelfHeight: CGFloat = 0
    let font = UIFont.systemFont(ofSize: 12)
    let textColor = UIColor.black
    var currentYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 30
    

    var purpleColor = UIColor(red: 112/255, green: 81/255, blue: 239/255, alpha: 1)
    
    var rectAndContactTypeDict: [String: CGRect] = [:]
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
            if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: 140.5, pageRect: CGRect(x: 0, y: 0, width: 400, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            } else {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: 400, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
            
            centerMargin = 154 + 25
            aboutYourSelfHeight = 139
            currentYCenterOffset = centerMargin
            if let contactInfo = generalInfo.contactInfo {
                
                drawContactsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                var contactStrings: [String] = []
                var typeArray: [String] = []
                if let website = contactInfo.website {
                    if website != "" {
                        contactStrings.append(website)
                        typeArray.append("website")
                    }
                }
                if let email = contactInfo.email {
                    if email != "" {
                        contactStrings.append(email)
                        typeArray.append("email")
                    }
                }
                if let phone = contactInfo.phone {
                    if phone != "" {
                        contactStrings.append(phone)
                        typeArray.append("phone")
                    }
                }
                for i in 0..<contactStrings.count {
                    drawContactsDescriptionInRightColumn(
                        contact: contactStrings[i],
                        type: typeArray[i],
                        xOffset: lm1,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &pageNumber)
                    
                }
                currentYOffset += 25
            }
            if let aboutYourself = generalInfo.aboutYourself {
                drawProfileDescriptionInCenterColumn(xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                drawAboutYourselfInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
        }
        
        if let educations = profile.educations, !educations.isEmpty {
            drawEducationInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            for i in 0..<educations.count {
                drawEducationeDescriptionInCenterColumn(education: educations[i], xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
            }
        }
        
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {
            
            drawSkiilsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
     
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
        
        if let certificates = profile.certificates, !certificates.isEmpty {
            drawCertificatesInCenterColumn(xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<certificates.count {
                drawCertificateDescriptionInCenterColumn(certificate: certificates[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
        }
        
        
        // Render pages
        var rectAndLinkDict: [String: CGRect] = [:]
        let topMarginForSM: CGFloat = 107
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            if page == 0 {
                if let backgroundImage = UIImage(named: "PDF12BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                    if let generalInfo = profile.generalInfo {
                        if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                            let imageRect = CGRect(x: 30 , y: 36 , width: 87.1, height: 87.1)
                            drawCircularImage(image: image, context: context, pageRect: pageRect, at: imageRect.origin, size: imageRect.size)
                        }
                    }
                        // Define the URL to which you want to redirect
                        let leftMarginForSM: CGFloat = 60
                        let smSpacing: CGFloat = 5
                        let increaseCoef: CGFloat = 1
                        var coefficient: CGFloat = -increaseCoef
                        let sideSize: CGFloat = 23.0
                        
                        
                        if let socialMedia = profile.socialMedia {
                            if let twitter = socialMedia.twitter {
                                let imageName = "Twitter"
                                if twitter != "" {
                                    coefficient += increaseCoef
                                    let twitterRect = CGRect(
                                        x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                                        y: topMarginForSM ,
                                        width: sideSize,
                                        height: sideSize
                                    )
                                    rectAndLinkDict[twitter] = twitterRect
                                    let image = UIImage(named: imageName)!
                                    drawCircularImage(image: image, context: context, pageRect: twitterRect, at: twitterRect.origin, size: twitterRect.size)
                                }
                            }
                            if let linkedin = socialMedia.linkedIn {
                                let imageName = "Linkedin"
                                if linkedin != "" {
                                    coefficient += increaseCoef
                                    let linkedinRect = CGRect(
                                        x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                                        y: topMarginForSM ,
                                        width: sideSize,
                                        height: sideSize
                                    )
                                    rectAndLinkDict[linkedin] = linkedinRect
                                    let image = UIImage(named: imageName)!
                                    drawCircularImage(image: image, context: context, pageRect: linkedinRect, at: linkedinRect.origin, size: linkedinRect.size)
                                }
                            }
                            if let facebook = socialMedia.facebook {
                                let imageName = "Facebook"
                                if facebook != "" {
                                    coefficient += increaseCoef
                                    let facebookRect = CGRect(
                                        x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                                        y: topMarginForSM  ,
                                        width: sideSize+1,
                                        height: sideSize
                                    )
                                    rectAndLinkDict[facebook] = facebookRect
                                    let image = UIImage(named: imageName)!
                                    drawCircularImage(image: image, context: context, pageRect: facebookRect, at: facebookRect.origin, size: facebookRect.size)
                                }
                            }
                            if let instagram = socialMedia.instagram {
                                let imageName = "Instagram"
                                if instagram != "" {
                                    coefficient += increaseCoef
                                    let instagramRect = CGRect(
                                        x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                                        y: topMarginForSM ,
                                        width: sideSize,
                                        height: sideSize
                                    )
                                    rectAndLinkDict[instagram] = instagramRect
                                    let image = UIImage(named: imageName)!
                                    drawCircularImage(image: image, context: context, pageRect: instagramRect, at: instagramRect.origin, size: instagramRect.size)
                                }
                            }
                        }
                    
                    for (type,rect) in rectAndContactTypeDict {
                        if let image = UIImage(named: type) {
                            drawImage(image: image, context: context, pageRect: rect, at: rect.origin, size: rect.size)
                        }
                    }
                }
            } else {
                if let backgroundImage = UIImage(named: "PDF12_1BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                }
            }
            pages[page]?.forEach { $0() }
        }
        
        UIGraphicsEndPDFContext()
        if let pdfDocument = PDFDocument(data: pdfData as Data) {
            if let page = pdfDocument.page(at: 0) {
                // let imageRect = CGRect(x: 0, y: pageHeight - 40 - 56 , width: 56, height: 56)
                for (link,rect) in rectAndLinkDict {
                    var adaptedRect = CGRect(x: rect.minX, y: pageHeight - topMarginForSM - rect.width , width: rect.width, height: rect.height)
                    let linkAnnotation = PDFAnnotation(bounds: adaptedRect, forType: .link, withProperties: nil)
                    linkAnnotation.url = URL(string: link)!
                    page.addAnnotation(linkAnnotation)
                }
            }
            return pdfDocument.dataRepresentation() ?? Data()
        }
        
        
        return pdfData as Data
    }
    
    func drawGeneraInfoInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        var fontSize: CGFloat = 25
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 1.0
        if let firstName = generalInfo.firstName, !firstName.isEmpty {
            var fullName:String = "i'm " + firstName
            
            if let lastName = generalInfo.lastName, !lastName.isEmpty {
                fullName += " \(lastName),"
            }
            let fullNameTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: fontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(fullName.lowercased())\na", attributes: fullNameTitleAttributes)
            
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        
        var jobTitle = ""
        if let reference = profile.workExperiences?.first {
            if let jobTitle_ = reference.jobTitle {
                if jobTitle_ != "" {
                    jobTitle = jobTitle_
                    let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Inter.bold(size: fontSize),
                        .foregroundColor: purpleColor,
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedjobTitileText = NSAttributedString(string:" \(jobTitle.lowercased())", attributes: jobTitleAttributes)
                    combinedAttributedString.append(attributedjobTitileText)
                }
            }
        }
        
        var remainingText = combinedAttributedString
        
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset , y: currentYOffset + 10 , width: 400, height: pageRect.height - bottomMargin   - currentYOffset)
            
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: 400)
            while textHeight > 180 {
                
                fontSize = fontSize - 0.3
                var combinedAttributedString = NSMutableAttributedString()
                let companyAndJobParagraphStyle = NSMutableParagraphStyle()
                companyAndJobParagraphStyle.paragraphSpacing = 1.0
                if let firstName = generalInfo.firstName, !firstName.isEmpty {
                    var fullName:String = "i'm " + firstName
                    
                    if let lastName = generalInfo.lastName, !lastName.isEmpty {
                        fullName += " \(lastName),"
                    }
                    let fullNameTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Inter.bold(size: fontSize),
                        .foregroundColor: UIColor.black,
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedJobTitleText = NSAttributedString(string: "\(fullName.lowercased())\na", attributes: fullNameTitleAttributes)
                    
                    combinedAttributedString.append(attributedJobTitleText)
                }
                
                var jobTitle = ""
                if let reference = profile.workExperiences?.first {
                    if let jobTitle_ = reference.jobTitle {
                        if jobTitle_ != "" {
                            jobTitle = jobTitle_
                            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                                .font: Fonts.Inter.bold(size: fontSize),
                                .foregroundColor: purpleColor,
                                .paragraphStyle: companyAndJobParagraphStyle
                            ]
                            let attributedjobTitileText = NSAttributedString(string:" \(jobTitle.lowercased())", attributes: jobTitleAttributes)
                            combinedAttributedString.append(attributedjobTitileText)
                        }
                    }
                }
                var remainingText = combinedAttributedString
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: 400)
                
                print(textHeight)
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
                currentYOffset = 154 + 25
            }
        }
        
    }
    
    func drawProfileDescriptionInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ,isLast: Bool = false) {
        
        let contactFont = Fonts.Inter.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "about me"
        
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
    
    func drawAboutYourselfInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 9)
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin  - currentYCenterOffset)
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
                currentYCenterOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    func drawContactsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.bold(size: 15)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        var text = "contact"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawContactsDescriptionInRightColumn(contact: String, type: String, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 10)
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var remainingText = contact
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset + 20, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset )
            let coeddicient: CGFloat = 0.8
            let topOffset: CGFloat = 6
            var imageRect = CGRect()
            if type == "email" {
                imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width: coeddicient * 14, height: coeddicient * 10)
            }
            if type == "phone" {
                imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset , width: coeddicient * 14, height: coeddicient * 14)
            }
            if type == "website" {
                imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset , width: coeddicient * 14, height: coeddicient * 14)
            }
            rectAndContactTypeDict[type] = imageRect
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 0
            }
            
        }
    }
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.bold(size: 15)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "skills"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsDescriptionInRightColumn(professionalSkills: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 10)
        let textColor = UIColor.black
        let bulletColor = purpleColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]

        let bulletAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: bulletColor,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSMutableAttributedString()

        for skill in professionalSkills {
            if skill != "" {
                let bullet = NSAttributedString(string: "•  ", attributes: bulletAttributes)
                let skillText = NSAttributedString(string: "\(skill)\n", attributes: textAttributes)
                
                attributedText.append(bullet)
                attributedText.append(skillText)
            }
        }
        var remainingText = attributedText
        
        
        
        while remainingText.length > 0 {
            if pageRect.height - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
            if remainingText.length > 0 {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        
    }
    
    
    func drawLanguagesInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.bold(size: 15)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "languages"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesDescriptionInRightColumn(languages: [Language], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 10)
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksMediaInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.bold(size: 15)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "links"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksDescriptionInRightColumn(socialMedia: SocialMedia, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 10)
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        if socialMedia.instagram != "" && socialMedia.instagram != nil && socialMedia.instagram != nil {
            text += socialMedia.instagram! + "\n"
        }
        if socialMedia.facebook != "" && socialMedia.facebook != nil && socialMedia.facebook != nil{
            text += socialMedia.facebook! + "\n"
        }
        if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil && socialMedia.linkedIn != nil{
            text += socialMedia.linkedIn! + "\n"
        }
        if socialMedia.twitter != "" && socialMedia.twitter != nil && socialMedia.twitter != nil{
            text += socialMedia.twitter! + "\n"
        }
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.bold(size: 15)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "interests"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
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
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawInterestsDescriptionInRightColumn(interests: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Inter.regular(size: 10)
        let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        let bulletColor = purpleColor

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left

        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]

        let bulletAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: bulletColor,
            .paragraphStyle: paragraphStyle
        ]

        let attributedText = NSMutableAttributedString()

        for interest in interests {
            if interest != "" {
                let bullet = NSAttributedString(string: "•  ", attributes: bulletAttributes)
                let interestText = NSAttributedString(string: "\(interest)\n", attributes: textAttributes)
                
                attributedText.append(bullet)
                attributedText.append(interestText)
            }
        }
        var remainingText = attributedText
        
        
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset  - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
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
                currentYOffset += textHeight + 25
            }
            
        }
    }
    
    //MARK: - Center
    func drawContactInfoInCenterColumn(generalInfo: GeneralInfo , xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        if let contactInfo = generalInfo.contactInfo {
            
            let contactFont = Fonts.Inter.medium(size: 10)
            let vertOffset = 7
            let contactParagraphStyle = NSMutableParagraphStyle()
            contactParagraphStyle.alignment = .right
            contactParagraphStyle.lineHeightMultiple = 1.3
            
            
            let textColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
        
        let contactFont = Fonts.Inter.bold(size: 15)
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3

        // Define the colors
        let blackColor = UIColor.black
        let purpleColor = purpleColor

        // Create the attributes for "work"
        let workAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: blackColor,
            .paragraphStyle: contactParagraphStyle
        ]

        // Create the attributes for "experience"
        let experienceAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: purpleColor,
            .paragraphStyle: contactParagraphStyle
        ]

        // Create the attributed string
        let attributedText = NSMutableAttributedString(string: "work", attributes: workAttributes)
        let experienceText = NSAttributedString(string: " experience", attributes: experienceAttributes)

        // Append the "experience" text to the "work" text
        attributedText.append(experienceText)
        
        var remainingText = attributedText
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
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
                currentYCenterOffset += textHeight + 12.5
            }
        }
    }
    
    func drawWorkExperienceDescriptionInCenterColumn(workExperience: WorkExperience, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ,isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 9.0
    
        if let companyName = workExperience.companyName, !companyName.isEmpty {
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.medium(size: 11),
                .foregroundColor: purpleColor,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(companyName)\n", attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(jobTitle)", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
     
        
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = workExperience.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = workExperience.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 8),
                .foregroundColor: UIColor(white: 0, alpha: 0.5),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: " | \(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        if let results = workExperience.results, !results.isEmpty {
            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 10),
                .foregroundColor: UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
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
        
        
        let contactFont = Fonts.Inter.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "education"
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: textAttributes)
            
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
    
    func drawEducationeDescriptionInCenterColumn(education: Education, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            //            if let degree = education.degree, !degree.isEmpty {
            //                fieldOfStudy += " (\(degree))"
            //            }
            let attributedJobTitleText = NSAttributedString(string: "\(fieldOfStudy)\n", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        if let university = education.university, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font:  Fonts.Inter.regular(size: 9),
                .foregroundColor: UIColor(red: 110/255.0, green: 109/255.0, blue: 143/255.0, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = education.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = education.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 8),
                .foregroundColor: purpleColor,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
            
            if remainingText.length > 0 {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Inter.bold(size: 15)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "certificates"
        
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
        companyAndJobParagraphStyle.paragraphSpacing = 9.0
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 11),
                .foregroundColor: purpleColor,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(university)\n", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            
            let attributedJobTitleText = NSAttributedString(string: "\(description)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
       
        
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        
        if let startDate = certificate.startDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let startDateString = dateFormatter.string(from: startDate)
            
            var dateText = startDateString
            if let endDate = certificate.endDate {
                let endDateString = dateFormatter.string(from: endDate)
                dateText += " - \(endDateString)"
            } else {
                dateText += " - PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 8),
                .foregroundColor: UIColor(white: 0, alpha: 0.3),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: " | \(dateText)", attributes: dateAttributes)
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











extension CV12Generator {
    
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
    func drawImage(image: UIImage, context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        
        let imageRect = CGRect(x: point.x, y: pageRect.size.height - point.y - size.height, width: size.width, height: size.height)
        
        context.draw(image.cgImage!, in: imageRect)
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
    
}
