import UIKit
import PDFKit

class CV4Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 40.0
    
    let lm1: CGFloat = 43.0
    let lm2: CGFloat = 175.0
    let lm3: CGFloat = 320
    
    let columnLeftWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 170
    let columnRightWidth: CGFloat = 225
    
    
    
    let textColor = UIColor.black
    
    var currentLeftYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    var currentRightYOffset: CGFloat =  40
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 30
    
    var socialMediaPageNumber:Int = 0
    
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
            drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            //   drawAboutYourselfInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            if let generalInfo = profile.generalInfo {
                drawContactInfoInCenterColumn(generalInfo: generalInfo, xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
            }
            
            
            let maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
        }
        
        if let workExperiences = profile.workExperiences, !workExperiences.isEmpty {
            var vertOffsetDesc = currentYCenterOffset
            var pgNumberDesc = pageNumber
           
            var vertOffsetDate = currentRightYOffset
            var pgNumberDate = pageNumber
            
            drawWorkExperienceInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<workExperiences.count  {
              
                drawWorkExperienceDescriptionInCenterColumn(workExperience: workExperiences[i],vertOffset: &vertOffsetDesc, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDesc, isLast: i == workExperiences.count - 1 ? true : false)
                
              
                drawWorkExperienceDateInCenterColumn(workExperience: workExperiences[i],vertOffset: &vertOffsetDate, xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDate, isLast: i == workExperiences.count - 1 ? true : false)
               
                if pgNumberDesc > pgNumberDate {
                    currentLeftYOffset = vertOffsetDesc
                    currentYCenterOffset = vertOffsetDesc
                    currentRightYOffset = vertOffsetDesc
                    vertOffsetDate = vertOffsetDesc
                }
                if pgNumberDesc < pgNumberDate {
                    currentLeftYOffset = vertOffsetDate
                    currentYCenterOffset = vertOffsetDate
                    currentRightYOffset = vertOffsetDate
                    vertOffsetDesc = vertOffsetDate
                    
                }
                if pgNumberDesc == pgNumberDate {
                    let max = max(vertOffsetDate, vertOffsetDesc)
                    currentLeftYOffset = max
                    currentYCenterOffset = max
                    currentRightYOffset = max
                    vertOffsetDesc = max
                    vertOffsetDate = max
                }
                pgNumberDesc = max(pgNumberDesc,pgNumberDate)
                pgNumberDate = max(pgNumberDesc,pgNumberDate)
                pageNumber = max(pgNumberDesc,pgNumberDate)
            }
            var maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) // + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
        }
     
     
        
        if let educations = profile.educations, !educations.isEmpty {
            var vertOffsetDesc = currentYCenterOffset
            var pgNumberDesc = pageNumber
           
            var vertOffsetDate = currentRightYOffset
            var pgNumberDate = pageNumber
            
            drawEducationInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<educations.count {
                drawEducationeDescriptionInCenterColumn(education: educations[i],vertOffset: &vertOffsetDesc, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDesc)
              //  drawEducationeDateInCenterColumn(education: educations[i],vertOffset: &vertOffsetDate ,xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDate)
                
                if pgNumberDesc > pgNumberDate {
                    currentLeftYOffset = vertOffsetDesc
                    currentYCenterOffset = vertOffsetDesc
                    currentRightYOffset = vertOffsetDesc
                    vertOffsetDate = vertOffsetDesc
                }
                if pgNumberDesc < pgNumberDate {
                    currentLeftYOffset = vertOffsetDate
                    currentYCenterOffset = vertOffsetDate
                    currentRightYOffset = vertOffsetDate
                    vertOffsetDesc = vertOffsetDate
                    
                }
                if pgNumberDesc == pgNumberDate {
                    let max = max(vertOffsetDate, vertOffsetDesc)
                    currentLeftYOffset = max
                    currentYCenterOffset = max
                    currentRightYOffset = max
                    vertOffsetDesc = max
                    vertOffsetDate = max
                }
                pgNumberDesc = max(pgNumberDesc,pgNumberDate)
                pgNumberDate = max(pgNumberDesc,pgNumberDate)
                pageNumber = max(pgNumberDesc,pgNumberDate)
                
            }
           var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
      
      

        if let certificates = profile.certificates, !certificates.isEmpty {
            var vertOffsetDesc = currentYCenterOffset
            var pgNumberDesc = pageNumber
            
            var vertOffsetDate = currentRightYOffset
            var pgNumberDate = pageNumber
            
            drawCertificatesInCenterColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<certificates.count {
                drawCertificateDescriptionInCenterColumn(certificate: certificates[i], vertOffset: &vertOffsetDesc, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDesc)
                drawCertificateDateInCenterColumn(certificate: certificates[i], vertOffset: &vertOffsetDate, xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pgNumberDate)
                
                if pgNumberDesc > pgNumberDate {
                    currentLeftYOffset = vertOffsetDesc
                    currentYCenterOffset = vertOffsetDesc
                    currentRightYOffset = vertOffsetDesc
                    vertOffsetDate = vertOffsetDesc
                }
                if pgNumberDesc < pgNumberDate {
                    currentLeftYOffset = vertOffsetDate
                    currentYCenterOffset = vertOffsetDate
                    currentRightYOffset = vertOffsetDate
                    vertOffsetDesc = vertOffsetDate
                    
                }
                if pgNumberDesc == pgNumberDate {
                    let max = max(vertOffsetDate, vertOffsetDesc)
                    currentLeftYOffset = max
                    currentYCenterOffset = max
                    currentRightYOffset = max
                    vertOffsetDesc = max
                    vertOffsetDate = max
                }
                pgNumberDesc = max(pgNumberDesc,pgNumberDate)
                pgNumberDate = max(pgNumberDesc,pgNumberDate)
                pageNumber = max(pgNumberDesc,pgNumberDate)
            }
           var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
        
      
      
      
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {
            
            drawSkiilsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            
            drawSkiilsDescriptionInRightColumn(professionalSkills: professionalSkills, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
           var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
        
        if let languages = profile.languages, !languages.isEmpty {
            
            drawLanguagesInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawLanguagesDescriptionInRightColumn(languages: languages, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
        
            var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
       
        
        if let interests = profile.interests?.map({ $0.name }), !interests.isEmpty {
            
            drawInterestsInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawInterestsDescriptionInRightColumn(interests: interests, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
           var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }

       
        
        
        socialMediaPageNumber = pageNumber
       
        
        if let socialMedia = profile.socialMedia {
            let instagramExist = socialMedia.instagram != "" && socialMedia.instagram != nil
            let facebookExist =  socialMedia.facebook != "" && socialMedia.facebook != nil
            let linkedIndExist = socialMedia.linkedIn != "" && socialMedia.linkedIn != nil
            let twitterExist = socialMedia.twitter != "" && socialMedia.twitter != nil
            
            if instagramExist || facebookExist || linkedIndExist || twitterExist {
                drawLinksMediaInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                
                if socialMedia.instagram != "" && socialMedia.instagram != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.instagram!, type: "Instagram", xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.facebook != "" && socialMedia.facebook != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.facebook!, type: "Facebook", xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.linkedIn!, type: "LinkedIn", xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
                if socialMedia.twitter != "" && socialMedia.twitter != nil {
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.twitter!, type: "Twitter", xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                }
               var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
               
               currentLeftYOffset = maxY
               currentYCenterOffset = maxY
               currentRightYOffset = maxY
            }
        }
      
     

        // Render pages
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            if let backgroundImage = UIImage(named: "PDF15BackgroundImage") {
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
    
    func drawGeneraInfoInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 20)
        let jobTitleFont = Fonts.SpaceGrotesk.regular(size: 14)
        let textColor = UIColor.black
        
        // Paragraph style for full name
        let fullNameParagraphStyle = NSMutableParagraphStyle()
        fullNameParagraphStyle.alignment = .left
        fullNameParagraphStyle.paragraphSpacing = 6
        
        // Paragraph style for job title
        let jobTitleParagraphStyle = NSMutableParagraphStyle()
        jobTitleParagraphStyle.alignment = .left
        
        // Attributes for full name
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: fullNameParagraphStyle
        ]
        
        // Attributes for job title
        let jobTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: jobTitleFont,
            .foregroundColor: textColor,
            .paragraphStyle: jobTitleParagraphStyle
        ]
        
        let jobTitle = profile.workExperiences?.first?.jobTitle ?? ""
        
        // Create attributed strings for full name and job title
        let fullNameString = "\(generalInfo.firstName ?? "") \(generalInfo.lastName ?? "")"
        let jobTitleString = jobTitle
        
        let attributedFullName = NSAttributedString(string: fullNameString, attributes: fullNameAttributes)
        let attributedJobTitle = NSAttributedString(string: jobTitleString, attributes: jobTitleAttributes)
        
        // Combine full name and job title into a single attributed string
        let combinedText = NSMutableAttributedString()
        combinedText.append(attributedFullName)
        combinedText.append(NSAttributedString(string: "\n"))
        combinedText.append(attributedJobTitle)
        
        guard combinedText.string != "" else { return }
        var remainingText = combinedText
        
        
        while remainingText.length > 0 {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: 300, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            let textHeight = calculateTextHeight(text: textToDraw, width: 300)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if remainingText.length > 0  {
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 25
            }
        }
        
    }
    
    
    
    func drawAboutYourselfInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 12)
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth , height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty   {
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 45
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 13)
        let textColor = UIColor.black
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth , height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsDescriptionInRightColumn(professionalSkills: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.regular(size: 10)
        let textColor = UIColor.black
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
                text += "\(skill)\n"
            }
        }
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYCenterOffset)
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
           
            if !remainingText.isEmpty   {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 13)
        let textColor = UIColor.black
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth , height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesDescriptionInRightColumn(languages: [Language], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.regular(size: 10)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.5
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = ""
        for i in 0..<languages.count {
            if languages[i].name != "" {
                if i < languages.count - 1 {
                    text +=  "\(languages[i].name)  |   \(languages[i].level)\n"
                } else {
                    text +=  "\(languages[i].name)  |   \(languages[i].level)\n"
                }
            }
        }
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYCenterOffset)
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
          
            if !remainingText.isEmpty  {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksMediaInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 13)
        let textColor = UIColor.black
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth , height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
          
            if !remainingText.isEmpty  {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawLinksDescriptionInRightColumn(socialMedia: String, type: String, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.regular(size: 10)
        let textColor = UIColor.black
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
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYCenterOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth, attributes: fullNameAttributes)
            
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
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.bold(size: 13)
        let textColor = UIColor.black
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth , height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: fullNameAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty   {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawInterestsDescriptionInRightColumn(interests: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.SpaceGrotesk.regular(size: 10)
        let textColor = UIColor.black
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
                text += interest + "\n"
            }
        }
        
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYCenterOffset)
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
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    //MARK: - Center
    func drawContactInfoInCenterColumn(generalInfo: GeneralInfo , xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        if let contactInfo = generalInfo.contactInfo {
            
            let contactFont = Fonts.SpaceGrotesk.medium(size: 10)
            
            
            let vertOffset = 7
            let contactParagraphStyle = NSMutableParagraphStyle()
            contactParagraphStyle.alignment = .right
            contactParagraphStyle.lineHeightMultiple = 1.3
            
            
            let textColor = UIColor.black
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: contactFont,
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
                    if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                        currentYCenterOffset = margin
                        currentRightYOffset = margin
                        currentLeftYOffset = margin
                        pageNumber += 1
                    }
                    let textRect = CGRect(x: xOffset, y: currentRightYOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
                    let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
                    let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
                     
                    let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth, attributes: textAttributes)
                    
                    if pages[pageNumber] == nil {
                        pages[pageNumber] = []
                    }
                    pages[pageNumber]?.append {
                        attributedTextToDraw.draw(in: textRect)
                    }
                    
                    remainingText = remainder
                    if !remainingText.isEmpty {
                        currentYCenterOffset = margin
                        currentRightYOffset = margin
                        currentLeftYOffset = margin
                        pageNumber += 1
                    } else {
                        currentRightYOffset += textHeight + 25
                    }
                }
        }
    }
    
    func drawWorkExperienceInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText:NSMutableAttributedString? = nil) {
        
        let contactFont = Fonts.SpaceGrotesk.bold(size: 12)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "EXPERIENCE".capitalized
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset - 1, width: columnLeftWidth, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: textAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
       
            if !remainingText.isEmpty {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 12.5
            }
            
        }
        
        
        text = remainingText
    }
    
    func drawWorkExperienceDescriptionInCenterColumn(workExperience: WorkExperience,vertOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        // Define a paragraph style for company name and job title
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        companyAndJobParagraphStyle.lineSpacing = 5.0

        // Company Name
        if let companyName = workExperience.companyName, !companyName.isEmpty {
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.bold(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: companyName, attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }

        // Job Title
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.regular(size: 10),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.alignment = .left

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
                .font: Fonts.SpaceGrotesk.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
      

        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
            currentYCenterOffset = margin
            currentRightYOffset = margin
            currentLeftYOffset = margin
            vertOffset = margin
            pageNumber += 1
        }
        while remainingText.length > 0 {
            
            let textRect = CGRect(x: xOffset, y: vertOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - vertOffset)
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
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            } else {
                vertOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawWorkExperienceDateInCenterColumn(
        workExperience: WorkExperience,
        vertOffset: inout CGFloat,
        xOffset: CGFloat,
        pageRect: CGRect, pages: inout [Int: [() -> Void]],
        pageNumber: inout Int,
        checkTheNextText:NSMutableAttributedString? = nil,
        isLast: Bool = false) {
            var combinedAttributedString = NSMutableAttributedString()
            
            // Define a separate paragraph style for results if needed
            let resultsParagraphStyle = NSMutableParagraphStyle()
            resultsParagraphStyle.paragraphSpacing = 5.0
            resultsParagraphStyle.lineSpacing = 5.0
            
            // Results
            if let results = workExperience.results, !results.isEmpty {
                let resultsAttributes: [NSAttributedString.Key: Any] = [
                    .font: Fonts.SpaceGrotesk.regular(size: 10),
                    .foregroundColor: UIColor.black,
                    .paragraphStyle: resultsParagraphStyle // Different paragraph style can be used here
                ]
                let attributedResultsText = NSAttributedString(string: "\(results)", attributes: resultsAttributes)
                combinedAttributedString.append(attributedResultsText)
            }
            
            guard combinedAttributedString.length > 0 else { return }
            var remainingText = combinedAttributedString
            
            while remainingText.length > 0 {
                if pageRect.height  - vertOffset - bottomMargin < estimateHeight {
                    currentYCenterOffset = margin
                    currentRightYOffset = margin
                    currentLeftYOffset = margin
                    vertOffset = margin
                    pageNumber += 1
                }
                let textRect = CGRect(x: xOffset, y: vertOffset , width: columnRightWidth, height: pageRect.height - bottomMargin - vertOffset)
                let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
                
                let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth)
                
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
                    vertOffset = margin
                    pageNumber += 1
                } else {
                    vertOffset += textHeight + (isLast ? 30 : 15)
                }
                
            }
        }
    
    func drawEducationInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.SpaceGrotesk.bold(size: 12)
        
        
         
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.paragraphSpacing = 3.0
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "EDUCATION".capitalized
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset  , width: columnLeftWidth, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: textAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
           
            if !remainingText.isEmpty {
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    func drawEducationeDescriptionInCenterColumn(education: Education,vertOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let university = education.university, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.bold(size: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university, attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.regular(size: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            if let degree = education.degree, !degree.isEmpty {
                fieldOfStudy += " (\(degree))"
            }
            let attributedJobTitleText = NSAttributedString(string: "\n\(fieldOfStudy)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
       
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.alignment = .left
        dateParagraphStyle.paragraphSpacing = 3.0
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
                .font: Fonts.SpaceGrotesk.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - vertOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: vertOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - vertOffset)
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
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            } else {
                vertOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawEducationeDateInCenterColumn(education: Education,vertOffset: inout CGFloat,  xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
       
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.alignment = .right
        dateParagraphStyle.paragraphSpacing = 3.0
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
                .font: Fonts.SpaceGrotesk.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - vertOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: vertOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - vertOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth)
            
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
                vertOffset = margin
                pageNumber += 1
            } else {
                currentRightYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.SpaceGrotesk.bold(size: 12)
        
        
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
        
        var text = "CERTIFICATES".capitalized
       
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin

                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: columnLeftWidth, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: textAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: textAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnLeftWidth, attributes: textAttributes)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
          
            if !remainingText.isEmpty {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight + 15
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate,vertOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.medium(size: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university, attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.SpaceGrotesk.regular(size: 12),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
           
            let attributedJobTitleText = NSAttributedString(string: "    \(description)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
      
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - vertOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: vertOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - vertOffset)
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
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            } else {
                vertOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawCertificateDateInCenterColumn(certificate: Certificate,vertOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        dateParagraphStyle.alignment = .right
        
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
                .font: Fonts.SpaceGrotesk.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - vertOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                vertOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: vertOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - vertOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth)
            
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
                vertOffset = margin
                pageNumber += 1
            } else {
                vertOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
}


















extension CV4Generator {
    
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
