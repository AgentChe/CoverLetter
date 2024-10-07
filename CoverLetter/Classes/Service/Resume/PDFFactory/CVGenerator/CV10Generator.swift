import UIKit
import PDFKit


class CV10Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 60.0
    var centerMargin: CGFloat = 60.0
    
    
    let lm1: CGFloat = 380
    let lm2: CGFloat = 63.0
    let columnWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 250
    var aboutYourSelfHeight: CGFloat = 0
    let font = UIFont.systemFont(ofSize: 12)
    let textColor = UIColor.black
    var currentYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 20
    
    
    var purpleColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1)
    
    var rectAndContactTypeDict: [String: CGRect] = [:]
    
    var pageAndRectDashArrayWithGreem: [Int:[CGRect]] = [:]
    var pageAndRectDashArray: [Int:[CGRect]] = [:]
    
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
            drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: columnCenterWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            
         
            if let contactInfo = generalInfo.contactInfo {
          
                var contactStrings: [String] = []
                var typeArray: [String] = []
                
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
                
                drawContactsDescriptionInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                if currentYOffset < 205 { currentYOffset = 205 }
                centerMargin = currentYOffset
                aboutYourSelfHeight = centerMargin - 40
                currentYCenterOffset = centerMargin
            }
    
        }
        if let educations = profile.educations, !educations.isEmpty {
            drawEducationInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            for i in 0..<educations.count {
                drawEducationeDescriptionInCenterColumn(education: educations[i], xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
            }
        }
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {
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
            var textRect = CGRect(x: lm1, y: currentYOffset, width: columnWidth, height: pageHeight  - bottomMargin  - currentYOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if remainingText.length > 0 {
                if pageHeight  - currentYOffset - bottomMargin - 30 < textHeight || remainder.length > 0 {
                    currentYOffset = margin
                    pageNumber += 1
                }
            }
            drawSkiilsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawSkiilsDescriptionInRightColumn(professionalSkills: professionalSkills, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
        if let languages = profile.languages, !languages.isEmpty {
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
            if !remainingText.isEmpty {
                var textRect = CGRect(x: lm1, y: currentYOffset, width: columnWidth , height: pageHeight  - bottomMargin - currentYOffset)
                var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
                var attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
                
                var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
                
                if pageHeight  - currentYOffset - bottomMargin - 30 < textHeight || remainder != "" {
                    
                    currentYOffset = margin
                    pageNumber += 1
                }
            }
            
            drawLanguagesInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawLanguagesDescriptionInRightColumn(languages: languages, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        }
        if let interests = profile.interests?.map({ $0.name }), !interests.isEmpty {
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
            if remainingText.length > 0 {
                let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                var textRect = CGRect(x: lm1, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
                var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                
                
                var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
                
                if pageRect.height  - currentYOffset - bottomMargin - 30 < textHeight || remainder.length > 0 {
                    
                    currentYOffset = margin
                    pageNumber += 1
                }
            }
            
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
        
        if let certificates = profile.certificates, !certificates.isEmpty {
            
            var combinedAttributedString = NSMutableAttributedString()
            let companyAndJobParagraphStyle = NSMutableParagraphStyle()
            companyAndJobParagraphStyle.paragraphSpacing = 9.0
            if let university = certificates[0].organizationName, !university.isEmpty {
                let universityAttributes: [NSAttributedString.Key: Any] = [
                    .font: Fonts.Inter.regular(size: 11),
                    .foregroundColor: purpleColor,
                    .paragraphStyle: companyAndJobParagraphStyle
                ]
                let attributedCompanyText = NSAttributedString(string: "\(university)\n", attributes: universityAttributes)
                combinedAttributedString.append(attributedCompanyText)
            }
            
            
            if var description = certificates[0].description, !description.isEmpty {
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
            
            if let startDate = certificates[0].startDate {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy"
                let startDateString = dateFormatter.string(from: startDate)
                
                var dateText = startDateString
                if let endDate = certificates[0].endDate {
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
            
            
            var remainingText = combinedAttributedString
            
            if remainingText.length > 0 {
                let xOffset = lm2
                let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                
                var textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
                var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                
                var textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
                
                if pageRect.height  - currentYCenterOffset - bottomMargin - 30 < textHeight || remainder.length > 0 {
                    
                    currentYCenterOffset = margin
                    pageNumber += 1
                 
                }
            }
            
            
            drawCertificatesInCenterColumn(xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            
            for i in 0..<certificates.count {
                drawCertificateDescriptionInCenterColumn(certificate: certificates[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
        }
    
        
        
        // Render pages
    
        let topMarginForSM: CGFloat = 107
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            if page == 0 {
                if let backgroundImage = UIImage(named: "PDF10BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                  
                    if let backImage = UIImage(named: "PDF10Avatar") {
                        let imageRect = CGRect(x: pageWidth - 80 - 140 , y: 40 + 0 , width: 150, height: 150)
                        drawImage(image: backImage, context: context, pageRect: pageRect, at: imageRect.origin, size: imageRect.size, cornerRadius: 0)
                    }
                    if let generalInfo = profile.generalInfo {
                        if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                            let imageRect = CGRect(x: pageWidth - 80 - 140 , y: 40 , width: 140, height: 140)
                            drawImage(image: image, context: context, pageRect: pageRect, at: imageRect.origin, size: imageRect.size, cornerRadius: 15)
                        }
                    }
                    for (type,rect) in rectAndContactTypeDict {
                        if let image = UIImage(named: type) {
                            drawCircularImage(image: image, context: context, pageRect: rect, at: rect.origin, size: rect.size)
                        }
                    }
                }
            } else {
                if let backgroundImage = UIImage(named: "PDF10BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                }
            }
            
            for (page_,rectArray) in pageAndRectDashArrayWithGreem {
                if page_ == page {
                    for rect in rectArray {
                        let context = UIGraphicsGetCurrentContext()!
                        drawRoundedWithGreenRectangle(context: context, pageRect: rect, at: rect.origin, size: rect.size)
                        
                    }
                }
            }
            for (page_,rectArray) in pageAndRectDashArray {
                if page_ == page {
                    for rect in rectArray {
                        let context = UIGraphicsGetCurrentContext()!
                        drawRoundedRectangle(context: context, pageRect: rect, at: rect.origin, size: rect.size)
                        
                    }
                }
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
        var fontSize: CGFloat = 25
      
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 0.0
      
        let fullNameParagraphStyle = NSMutableParagraphStyle()
        fullNameParagraphStyle.paragraphSpacing = 12.0 // Increase space after full name

        if let firstName = generalInfo.firstName, !firstName.isEmpty {
            var fullName: String = firstName
            
            if let lastName = generalInfo.lastName, !lastName.isEmpty {
                fullName += " \(lastName)"
            }
            let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Roboto.bold(size: fontSize),
                .foregroundColor: UIColor(white: 0, alpha: 1),
                .paragraphStyle: fullNameParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(fullName)\n", attributes: fullManeTitleAttributes)
            
            combinedAttributedString.append(attributedJobTitleText)
        }
        var jobTitle = ""
        if let reference = profile.workExperiences?.first {
            if let jobTitle_ = reference.jobTitle {
                if jobTitle_ != "" {
                    jobTitle = jobTitle_
                    let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Roboto.regular(size: 16),
                        .foregroundColor: UIColor(white: 0, alpha: 1),
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedJobTitleText = NSAttributedString(string: "\(jobTitle)", attributes: jobTitleAttributes)
                    combinedAttributedString.append(attributedJobTitleText)
                }
            }
        }
        
        var remainingText = combinedAttributedString
        
        currentYOffset += 25
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset  , y: currentYOffset  , width: columnCenterWidth, height: pageRect.height - bottomMargin   - currentYOffset)
            
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            while textHeight > 100 {
                print("textHeight: \(textHeight)")
                fontSize = fontSize - 0.3
                var combinedAttributedString = NSMutableAttributedString()
                let companyAndJobParagraphStyle = NSMutableParagraphStyle()
                companyAndJobParagraphStyle.paragraphSpacing = 0.0
               
                let fullNameParagraphStyle = NSMutableParagraphStyle()
                fullNameParagraphStyle.paragraphSpacing = 12.0 // Increase space after full name

                if let firstName = generalInfo.firstName, !firstName.isEmpty {
                    var fullName: String = firstName
                    
                    if let lastName = generalInfo.lastName, !lastName.isEmpty {
                        fullName += " \(lastName)"
                    }
                    let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Roboto.bold(size: fontSize),
                        .foregroundColor: UIColor(white: 0, alpha: 1),
                        .paragraphStyle: fullNameParagraphStyle
                    ]
                    let attributedJobTitleText = NSAttributedString(string: "\(fullName)\n", attributes: fullManeTitleAttributes)
                    
                    combinedAttributedString.append(attributedJobTitleText)
                }

                var jobTitle = ""
                if let reference = profile.workExperiences?.first {
                    if let jobTitle_ = reference.jobTitle {
                        if jobTitle_ != "" {
                            jobTitle = jobTitle_
                            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                                .font: Fonts.Roboto.regular(size: 16),
                                .foregroundColor: UIColor(white: 0, alpha: 1),
                                .paragraphStyle: companyAndJobParagraphStyle
                            ]
                            let attributedJobTitleText = NSAttributedString(string: "\(jobTitle)", attributes: jobTitleAttributes)
                            combinedAttributedString.append(attributedJobTitleText)
                        }
                    }
                }
                   
                
                var remainingText = combinedAttributedString
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
                
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
                currentYOffset += textHeight + 5
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
        
        var text = "about me".capitalized
        
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
        
        var text = "contact".capitalized
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
    
    func drawContactsDescriptionInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SplineSans.regular(size: 10)
        let textColor = UIColor(red: 69/255, green: 69/255, blue: 69/255, alpha: 1)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        guard let contactInfo = generalInfo.contactInfo else { return }
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
       
        if let phone = contactInfo.phone {
            if phone != "" {
                text += phone + "  "
            }
        }
        
        if let email = contactInfo.email {
            if email != "" {
                text += email
            }
        }
         
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset , y: currentYOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYOffset)
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
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Lato.bold(size: 19)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "skills".capitalized
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
           
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if pageRect.height  - currentYOffset - bottomMargin < textHeight || remainder.length > 0 {
                
                currentYOffset = margin
                pageNumber += 1
                textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            }
            
            let topOffset: CGFloat = -3
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnWidth + 20 , height:  textHeight + 5 )
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
            }
           
            
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
        let fullNameFont = Fonts.Lato.bold(size: 19)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "languages".capitalized
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
           
            
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height  - bottomMargin - currentYOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            var attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            
            if pageRect.height  - currentYOffset - bottomMargin < textHeight || remainder != "" {
                
                currentYOffset = margin
                pageNumber += 1
                 (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
                 attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
                
                 textHeight = calculateTextHeight(text: textToDraw, width: columnWidth, attributes: fullNameAttributes)
            }
            
            let topOffset: CGFloat = -3
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnWidth + 20 , height:  textHeight + 10 )
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
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
                currentYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksMediaInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Lato.bold(size: 19)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "links".capitalized
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - 50 - currentYOffset)
            
            
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
            
            let topOffset: CGFloat = -1.5
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnWidth + 20 , height:  textHeight + 10 )
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
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
                currentYOffset += textHeight + 20
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
        let fullNameFont = Fonts.Lato.bold(size: 19)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "interests".capitalized
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
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            
            if pageRect.height  - currentYOffset - bottomMargin < textHeight || remainder.length > 0 {
                
                currentYOffset = margin
                pageNumber += 1
                textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            }
            
            let topOffset: CGFloat = -3
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnWidth + 20 , height:  textHeight + 5 )
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
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
        
        let contactFont = Fonts.Lato.bold(size: 19)
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
        let attributedText = NSMutableAttributedString(string: "work".capitalized, attributes: workAttributes)
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
                currentYCenterOffset += textHeight + 30
            }
        }
    }
    
    func drawWorkExperienceDescriptionInCenterColumn(workExperience: WorkExperience, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ,isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 9.0
    
        
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Lato.bold(size: 11),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(jobTitle)\n", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        
        if let companyName = workExperience.companyName, !companyName.isEmpty {
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Lato.heavy(size: 11),
                .foregroundColor: purpleColor,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(companyName)", attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
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
                .foregroundColor: UIColor(white: 0, alpha: 0.3),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: " | \(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        if let results = workExperience.results, !results.isEmpty {
            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SourceSansPro.regular(size: 10.8),
                .foregroundColor: UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1.0)
            ]
            let attributedResultsText = NSAttributedString(string: "\n\(results)", attributes: resultsAttributes)
            combinedAttributedString.append(attributedResultsText)
        }
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            
            var textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            
            if pageRect.height  - currentYCenterOffset - bottomMargin < textHeight || remainder.length > 0 {
                
                currentYCenterOffset = margin
                pageNumber += 1
                textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            }
            
            let topOffset: CGFloat = -10
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnCenterWidth + 20 , height:  textHeight + 20 )
            var rectArray = pageAndRectDashArrayWithGreem[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArrayWithGreem[pageNumber] = rectArray
            } else {
                pageAndRectDashArrayWithGreem[pageNumber] = [imageRect]
            }
           
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
                currentYCenterOffset += textHeight + (isLast ? 60 : 60)
                
            }
        }
        
    }
    
    func drawEducationInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Lato.bold(size: 19)
        
        
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
        
        var text = "education".capitalized
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
                currentYOffset += textHeight + 30
            }
            
        }
        
        text = remainingText
    }
    
    func drawEducationeDescriptionInCenterColumn(education: Education, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 5.0
  
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 5.0
        
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
                .font: Fonts.SourceSansPro.regular(size: 11),
                .foregroundColor: UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1.0),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)\n", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
    
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Lato.heavy(size: 11),
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
                .font:  Fonts.SourceSansPro.regular(size: 11),
                .foregroundColor: UIColor(red: 89/255, green: 89/255, blue: 89/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        
      
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            
            var textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
        
            if pageRect.height  - currentYOffset - bottomMargin < textHeight || remainder.length > 0 {
                
                currentYCenterOffset = margin
                pageNumber += 1
                textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height  - bottomMargin  - currentYOffset )
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnWidth)
            }
            let topOffset: CGFloat = -10
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnWidth + 20 , height:  textHeight + 20 )
           
            var rectArray = pageAndRectDashArray[pageNumber]
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
            }
             
            
            
            
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
                currentYOffset += textHeight + (isLast ? 30 : 30)
            }
            
        }
    }
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Lato.bold(size: 19)
        
        
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
        
        var text = "certificates".capitalized
        
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
                currentYCenterOffset += textHeight + 30
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 9.0
        
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Lato.bold(size: 11),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            
            let attributedJobTitleText = NSAttributedString(string: "\(description)\n", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Lato.heavy(size: 11),
                .foregroundColor: purpleColor,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
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
            var textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            
            if pageRect.height  - currentYCenterOffset - bottomMargin < textHeight || remainder.length > 0 {
                
                currentYCenterOffset = margin
                pageNumber += 1
                textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset )
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth)
            }
            
            let topOffset: CGFloat = -10
            let imageRect = CGRect(x: xOffset - 10 , y: textRect.minY + topOffset, width:  columnCenterWidth + 20 , height:  textHeight + 20 )
            var rectArray = pageAndRectDashArrayWithGreem[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArrayWithGreem[pageNumber] = rectArray
            } else {
                pageAndRectDashArrayWithGreem[pageNumber] = [imageRect]
            }
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
                currentYCenterOffset += textHeight + 50
            }
            
        }
    }
    
}











extension CV10Generator {
    
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
    func drawRoundedRectangle(context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        
        // Calculate the rectangle's position within the page
        let rect = CGRect(x: point.x, y: pageRect.size.height - point.y - size.height, width: size.width, height: size.height)
        
        // Create the path for a rounded rectangle
        let cornerRadius: CGFloat = 10.0
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        
        // Set the stroke color (black) and line width (1 scale)
        context.setStrokeColor(UIColor.black.cgColor)
        
        context.setLineWidth(1)
       
        
        // Set the fill color to transparent (no fill)
        context.setFillColor(UIColor.white.cgColor)
        context.addPath(path.cgPath)
        context.fillPath()
        
        // Add the path to the context
        context.addPath(path.cgPath)
        
        // Draw the stroke (border)
        context.strokePath()

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
    func drawRoundedWithGreenRectangle(context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Calculate the rectangle's position within the page
        let rect = CGRect(x: point.x, y: pageRect.size.height - point.y - size.height, width: size.width, height: size.height)
        
        // Calculate the green rectangle's position within the page with the offset
        let offset: CGFloat = 13
        let greenRect = CGRect(x: rect.minX + offset, y: rect.minY - offset, width: rect.width, height: rect.height)
        
        // Create the path for the green rounded rectangle
        let greenPath = UIBezierPath(roundedRect: greenRect, cornerRadius: 10.0)
        
        // Set the fill color to the specified green color
        context.setFillColor(UIColor(red: 0x3D / 255.0, green: 0xC3 / 255.0, blue: 0x9B / 255.0, alpha: 1.0).cgColor)
        context.addPath(greenPath.cgPath)
        context.fillPath()

        // Create the path for the white rounded rectangle
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 10.0)
        
        // Set the stroke color (black) and line width (1 scale)
        context.setStrokeColor(UIColor.black.cgColor)
        context.setLineWidth(1)
        
        // Set the fill color to white
        context.setFillColor(UIColor.white.cgColor)
        context.addPath(path.cgPath)
        context.fillPath()
        
        // Add the path to the context for the white border
        context.addPath(path.cgPath)
        
        // Draw the stroke (border)
        context.strokePath()

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
    func drawImage(image: UIImage, context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize, cornerRadius: CGFloat) {
        context.saveGState()
        
        // Flip the context vertically because Core Graphics uses a bottom-left origin
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        // Calculate the aspect fill size
        let imageSize = image.size
        let aspectWidth = size.width / imageSize.width
        let aspectHeight = size.height / imageSize.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        let scaledImageWidth = imageSize.width * aspectRatio
        let scaledImageHeight = imageSize.height * aspectRatio
        
        let imageX = point.x - (scaledImageWidth - size.width) / 2.0
        let imageY = pageRect.size.height - point.y - size.height - (scaledImageHeight - size.height) / 2.0
        
        let imageRect = CGRect(x: imageX, y: imageY, width: scaledImageWidth, height: scaledImageHeight)
        
        // Create a clipping path with a corner radius
        let path = UIBezierPath(roundedRect: CGRect(x: point.x, y: pageRect.size.height - point.y - size.height, width: size.width, height: size.height), cornerRadius: cornerRadius)
        context.addPath(path.cgPath)
        context.clip()
        
        // Draw the image within the clipped path
        context.draw(image.cgImage!, in: imageRect)
        
        context.restoreGState()
    }
    
}
