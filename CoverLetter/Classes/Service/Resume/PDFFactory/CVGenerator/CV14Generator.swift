import UIKit
import PDFKit

class CV14Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 40.0
    var centerMargin: CGFloat = 40.0
    let whiteBackgroundColor = UIColor(red: 13/255.0, green: 13/255.0, blue: 13/255.0, alpha: 1.0)

    
    let lm1: CGFloat = 25.0
    let lm2: CGFloat = 280
    let columnWidth: CGFloat = 200
    let columnCenterWidth: CGFloat = 265
    var aboutYourSelfHeight: CGFloat = 0
    let font = UIFont.systemFont(ofSize: 12)
    let textColor = UIColor.black
    var currentYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 100
    
    var contactsRect: [String: CGRect] = [:]
    
    
    
    
    
    var pageAndRectDashArray: [Int:[CGRect]] = [:]
    var pageAndRectSHRTDashArray: [Int:[CGRect]] = [:]
    let peachDashOffset: CGFloat = 31
   
    var socialMediaPageNumber:Int = 0
    var socialMediaYOffset: CGFloat = 0
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
            if let generalInfo = profile.generalInfo {
                if let photoFileName = generalInfo.photoFileName, DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) != nil {
                    if photoFileName != "" {
                        currentYOffset = 156 + 25 + 60
                    }
                }
            }
            
            drawNameInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            currentYCenterOffset = centerMargin
           
           
            if let contactInfo = generalInfo.contactInfo {
              
                if let email = contactInfo.email {
                    if email != "" {
                        drawContactInfoInCenterColumn(contact: email,type:"email", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    }
                }
                
                if let phone = contactInfo.phone {
                    if phone != "" {
                        drawContactInfoInCenterColumn(contact: phone,type:"phone", xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    }
                }
            
                currentYOffset += 20

            } else {
                currentYOffset += 20
            }
            
            if let aboutYourself = generalInfo.aboutYourself {
                drawProfileDescriptionInCenterColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                drawAboutYourselfInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
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
        var rectAndLinkDict: [String: CGRect] = [:]
        let topMarginForSM: CGFloat = pageHeight - 45
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            if page == 0 {
                if let backgroundImage = UIImage(named: "PDF14BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                    if let generalInfo = profile.generalInfo {
                        if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                            drawImage(image: image, context: context, pageRect: pageRect, at: CGPoint(x: 25, y: 25), size: CGSize(width: 185, height: 156))
                        }
                    }
                }
            } else {
                if let backgroundImage = UIImage(named: "PDF14BackgroundImage") {
                    let context = UIGraphicsGetCurrentContext()!
                    let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                    drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
                }
            }
            if page == 0 {
                let context = UIGraphicsGetCurrentContext()!
                let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
                for (type,rect) in contactsRect {
                    if type == "email" {
                        if let image = UIImage(named: "PDF14Email") {
                            drawImage(image: image,
                                      context: context,
                                      pageRect: pageRect,
                                      at: CGPoint(x: rect.origin.x, y: rect.origin.y + 6.5),
                                      size: CGSize(width: 12, height: 9))
                        }
                    }
                    if type == "phone" {
                        if let image = UIImage(named: "PDF14Phone") {
                            drawImage(image: image,
                                      context: context,
                                      pageRect: pageRect,
                                      at: CGPoint(x: rect.origin.x, y: rect.origin.y + 4.5),
                                      size: CGSize(width: 12, height: 12))
                        }
                    }
                }
               
            }
            
            pages[page]?.forEach { $0() }
            
            
            
            
            
            let context = UIGraphicsGetCurrentContext()!
            let leftMarginForSM: CGFloat = 45
            let smSpacing: CGFloat = 8
            let increaseCoef: CGFloat = 1
            var coefficient: CGFloat = -increaseCoef
            let sideSize: CGFloat = 12.0
            
            if let socialMedia = profile.socialMedia {
                if let twitter = socialMedia.twitter {
                    let imageName = "TwitterBlack"
                    if twitter != "" {
                        coefficient += increaseCoef
                        let twitterRect = CGRect(
                            x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                            y: topMarginForSM + 2,
                            width: sideSize,
                            height: sideSize
                        )
                        rectAndLinkDict[twitter] = twitterRect
                        let image = UIImage(named: imageName)!
                        drawImage(image: image, context: context, pageRect: twitterRect, at: twitterRect.origin, size: twitterRect.size)
                    }
                }
                if let linkedin = socialMedia.linkedIn {
                    let imageName = "LinkedinBlack"
                    if linkedin != "" {
                        coefficient += increaseCoef
                        let linkedinRect = CGRect(
                            x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                            y: topMarginForSM + 1,
                            width: sideSize,
                            height: sideSize
                        )
                        rectAndLinkDict[linkedin] = linkedinRect
                        let image = UIImage(named: imageName)!
                        drawImage(image: image, context: context, pageRect: linkedinRect, at: linkedinRect.origin, size: linkedinRect.size)
                    }
                }
                if let facebook = socialMedia.facebook {
                    let imageName = "FacebookBlack"
                    if facebook != "" {
                        coefficient += increaseCoef
                        let facebookRect = CGRect(
                            x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) + 2 ,
                            y: topMarginForSM - 2  ,
                            width: sideSize - 4,
                            height: sideSize
                        )
                        rectAndLinkDict[facebook] = facebookRect
                        let image = UIImage(named: imageName)!
                        drawImage(image: image, context: context, pageRect: facebookRect, at: facebookRect.origin, size: facebookRect.size)
                    }
                }
                if let instagram = socialMedia.instagram {
                    let imageName = "InstagramBlack"
                    if instagram != "" {
                        coefficient += increaseCoef
                        let instagramRect = CGRect(
                            x: pageWidth - leftMarginForSM - coefficient*(sideSize + smSpacing) ,
                            y: topMarginForSM  - 0,
                            width: sideSize*1.2,
                            height: sideSize*1.2
                        )
                        rectAndLinkDict[instagram] = instagramRect
                        let image = UIImage(named: imageName)!
                        drawImage(image: image, context: context, pageRect: instagramRect, at: instagramRect.origin, size: instagramRect.size)
                        
                    }
                }
            }
            
        }

        UIGraphicsEndPDFContext()
        for page_ in 0..<pages.count {
            if let pdfDocument = PDFDocument(data: pdfData as Data) {
                if let page = pdfDocument.page(at: page_) {
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
        }
        return pdfData as Data
    }
    
    func drawGeneraInfoInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 8.0
        
        var jobTitle = ""
        if let reference = profile.workExperiences?.first {
            if let jobTitle_ = reference.jobTitle {
                if jobTitle_ != "" {
                    jobTitle = jobTitle_
                    let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Arial.boldItalic(size: 14),
                        .foregroundColor: whiteBackgroundColor,
                        .paragraphStyle: companyAndJobParagraphStyle
                    ]
                    let attributedjobTitileText = NSAttributedString(string: "\(jobTitle) \n", attributes: jobTitleAttributes)
                    combinedAttributedString.append(attributedjobTitileText)
                }
            }
        }
        
  
        
        var remainingText = combinedAttributedString
        
        if remainingText.length > 0  {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset  , y: currentYOffset , width: columnCenterWidth, height: pageRect.height - bottomMargin   - currentYOffset)
            
            let topOffset: CGFloat = 6
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  31, height:  1.5)
            var rectArray = pageAndRectDashArray[pageNumber]
            
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
            }
            
        }
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
            
            
            let textRect = CGRect(x: xOffset  , y: currentYOffset , width: columnWidth, height: pageRect.height - bottomMargin   - currentYOffset)
            
            
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
                currentYOffset += textHeight + 5
            }
        }
        socialMediaPageNumber = pageNumber
        
    }
    func drawNameInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        var fontSize: CGFloat = 17
     
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 1
     
        if let firstName = generalInfo.firstName, !firstName.isEmpty {
            var fullName:String = firstName

            if let lastName = generalInfo.lastName, !lastName.isEmpty {
                fullName += " \(lastName)"
            }
            let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.regular(size: fontSize),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\(fullName)", attributes: fullManeTitleAttributes)

            combinedAttributedString.append(attributedJobTitleText)
        }

        
        var remainingText = combinedAttributedString
        
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }
       
            
            let textRect = CGRect(x: xOffset  , y: currentYOffset , width: columnWidth, height: pageRect.height - bottomMargin   - currentYOffset)
            
          
         
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: 200)
            while textHeight > 50.0 {
                fontSize = fontSize - 0.3
                print("fontSize: \(fontSize), textHeight: \(textHeight)")
                var combinedAttributedString = NSMutableAttributedString()
                let companyAndJobParagraphStyle = NSMutableParagraphStyle()
                companyAndJobParagraphStyle.paragraphSpacing = 0
                
             
                if let firstName = generalInfo.firstName, !firstName.isEmpty {
                    var fullName:String = firstName

                    if let lastName = generalInfo.lastName, !lastName.isEmpty {
                        fullName += " \(lastName)"
                    }
                    let fullManeTitleAttributes: [NSAttributedString.Key: Any] = [
                        .font: Fonts.Arial.regular(size: fontSize),
                        .foregroundColor: UIColor.black,
                        .paragraphStyle: companyAndJobParagraphStyle,
                        .backgroundColor: UIColor.red
                    ]
                    let attributedJobTitleText = NSAttributedString(string: "\(fullName)", attributes: fullManeTitleAttributes)

                    combinedAttributedString.append(attributedJobTitleText)
             
                    var remainingText = combinedAttributedString
                    (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                    textHeight = calculateTextHeight(text: textToDraw, width: 200)
                }
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
                currentYOffset += textHeight + 2
            }
        }
        socialMediaPageNumber = pageNumber
    }
    
    func drawProfileDescriptionInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int ,isLast: Bool = false) {
        
        let contactFont = Fonts.Arial.boldItalic(size: 17)
        
        
      
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "About me"
     
        
        var remainingText = text
        
        guard text != "" else { return }
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = margin
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset , y: currentYOffset, width: columnWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
            
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  31, height:  1.5)
           
            var rectArray = pageAndRectDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectDashArray[pageNumber] = rectArray
            } else {
                pageAndRectDashArray[pageNumber] = [imageRect]
            }
            
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
                    currentYOffset += textHeight + 12.5
                }
            }
    
        socialMediaPageNumber = pageNumber
    }
    
    func drawAboutYourselfInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 9)
        let textColor =  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0)
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
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset , y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYCenterOffset)
          
          
            
            
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
        
        socialMediaPageNumber = pageNumber
    }
    func drawContactsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 15)
        let textColor = whiteBackgroundColor
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle,
        ]
        
        var text = "CONTACT"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset , y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
        
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  22.6, height:  1.3)
           
         
            var rectArray = pageAndRectSHRTDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectSHRTDashArray[pageNumber] = rectArray
            } else {
                pageAndRectSHRTDashArray[pageNumber] = [imageRect]
            }
            
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
        
        socialMediaPageNumber = pageNumber
    }
    
    func drawContactsDescriptionInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 10)
        let textColor =  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0)
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
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin  - currentYOffset )
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
                currentYOffset += textHeight + 25
            }
            
        }
        
        socialMediaPageNumber = pageNumber
    }
    
    func drawContactInfoInCenterColumn(contact:String,type:String, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        
        
        let contactFont = Fonts.Manrope.medium(size: 11)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor =  UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = contact
        
        
        
        guard text != "" else { return }
        
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset + 20, y: currentYOffset, width: columnWidth, height: pageRect.height - bottomMargin - currentYOffset)
            contactsRect[type] = CGRect(x: xOffset , y: currentYOffset , width: columnWidth, height: pageRect.height - bottomMargin - currentYOffset)
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
                currentYOffset += textHeight + 0
            }
            
        }
    }
    
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 15)
        let textColor = whiteBackgroundColor
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "Skills"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
        
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  22.6, height:  1.3)
           
         
            var rectArray = pageAndRectSHRTDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectSHRTDashArray[pageNumber] = rectArray
            } else {
                pageAndRectSHRTDashArray[pageNumber] = [imageRect]
            }
            
            
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
        
        socialMediaPageNumber = pageNumber
    }
    
    func drawSkiilsDescriptionInRightColumn(professionalSkills: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 10)
        let textColor =  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0)
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
           
            if !remainingText.isEmpty  {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        socialMediaPageNumber = pageNumber
    }
    
    
    func drawLanguagesInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 15)
        let textColor = whiteBackgroundColor
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "Languages"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

      
            let textRect = CGRect(x: xOffset , y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
        
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  22.6, height:  1.3)
           
         
            var rectArray = pageAndRectSHRTDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectSHRTDashArray[pageNumber] = rectArray
            } else {
                pageAndRectSHRTDashArray[pageNumber] = [imageRect]
            }
           
            
            
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
        
        socialMediaPageNumber = pageNumber
    }
    
    
    func drawLanguagesDescriptionInRightColumn(languages: [Language], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 10)
        let textColor =  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0)
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
        
        socialMediaPageNumber = pageNumber
    }
   
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 15)
        let textColor = whiteBackgroundColor
        let paragraphStyle = NSMutableParagraphStyle()
        
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "Interests"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                currentYOffset = centerMargin - aboutYourSelfHeight
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset  , y: currentYOffset, width: columnWidth , height: pageRect.height - bottomMargin - currentYOffset)
        
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  22.6, height:  1.3)
           
         
            var rectArray = pageAndRectSHRTDashArray[pageNumber]
          
            if var rectArray = rectArray {
                rectArray.append(imageRect)
                pageAndRectSHRTDashArray[pageNumber] = rectArray
            } else {
                pageAndRectSHRTDashArray[pageNumber] = [imageRect]
            }
            
            
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
        
        socialMediaPageNumber = pageNumber
    }
    
    func drawInterestsDescriptionInRightColumn(interests: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText: String = "") {
        let fullNameFont = Fonts.Arial.boldItalic(size: 10)
        let textColor =  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0)
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
             
            if !remainingText.isEmpty  {
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 25
            }
            
        }
        
        socialMediaPageNumber = pageNumber
    }
    
    //MARK: - Center
    func drawContactInfoInCenterColumn(generalInfo: GeneralInfo , xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        if let contactInfo = generalInfo.contactInfo {
            
            let contactFont = Fonts.Arial.medium(size: 10)
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
        
        let contactFont = Fonts.Arial.boldItalic(size: 17)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "Past Expirience"
        
        var remainingText = text
        
        guard text != "" else { return }
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }

            let textRect = CGRect(x: xOffset  , y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
            
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  31, height:  1.5)
           
         
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
                .font: Fonts.Arial.boldItalic(size: 9),
                .foregroundColor: UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1.0),
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
                   dateText += " / \(endDateString)"
               } else {
                   dateText += " / PRESENT"
               }
               
               let dateAttributes: [NSAttributedString.Key: Any] = [
                   .font: Fonts.Arial.boldItalic(size: 9),
                   .foregroundColor: UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1.0),
                   .paragraphStyle: dateParagraphStyle
               ]
               let attributedDateText = NSAttributedString(string: " – \(dateText)", attributes: dateAttributes)
               combinedAttributedString.append(attributedDateText)
           }
        
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.boldItalic(size: 11),
                .foregroundColor:  UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
  
        
        if let results = workExperience.results, !results.isEmpty {
            let  resultsParagraphStyle = NSMutableParagraphStyle()
            resultsParagraphStyle.lineSpacing = 4.0

            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font:  Fonts.Arial.boldItalic(size: 10),
                .foregroundColor:  UIColor(red: 0x68 / 255.0, green: 0x68 / 255.0, blue: 0x68 / 255.0, alpha: 1.0),
                .paragraphStyle : resultsParagraphStyle
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
        
        
        let contactFont = Fonts.Arial.boldItalic(size: 17)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "Education"
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset , y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height  - bottomMargin  - currentYCenterOffset)
          
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  31, height:  1.5)
           
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
                dateText += "  ––  \(endDateString)"
            } else {
                dateText += "  ––  PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.regular(size: 11),
                .foregroundColor:  UIColor(red: 132 / 255.0, green: 132 / 255.0, blue: 132 / 255.0, alpha: 1.0),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)\n", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.boldItalic(size: 11),
                .foregroundColor: UIColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1),
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
                .font:  Fonts.Arial.regular(size: 11),
                .foregroundColor: UIColor(red: 132 / 255.0, green: 132 / 255.0, blue: 132 / 255.0, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: "\(university)", attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
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
        
        
        let contactFont = Fonts.Arial.bold(size: 17)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "Certificates"
   
        guard text != "" else { return }
        var remainingText = text
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
           
      
            
            let textRect = CGRect(x: xOffset , y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin  - currentYCenterOffset)
            
            let topOffset: CGFloat = 10
            let imageRect = CGRect(x: xOffset , y: textRect.minY + topOffset, width:  31, height:  1.5)
           
         
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
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.boldItalic(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            
            let attributedJobTitleText = NSAttributedString(string: "\(description)\n", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.boldItalic(size: 9),
                .foregroundColor: UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1.0),
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
                dateText += " / \(endDateString)"
            } else {
                dateText += " / PRESENT"
            }
            
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Arial.boldItalic(size: 8),
                .foregroundColor: UIColor(red: 104/255, green: 104/255, blue: 104/255, alpha: 1.0),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: " – \(dateText)", attributes: dateAttributes)
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











extension CV14Generator {
    
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
        
        let imageSize = image.size
        let aspectWidth = size.width / imageSize.width
        let aspectHeight = size.height / imageSize.height
        let aspectRatio = max(aspectWidth, aspectHeight)
        
        let scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        
        let imageRect = CGRect(
            x: point.x - (scaledImageSize.width - size.width) / 2,
            y: pageRect.size.height - point.y - (scaledImageSize.height - size.height) / 2 - scaledImageSize.height,
            width: scaledImageSize.width,
            height: scaledImageSize.height
        )
        
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
