import UIKit
import PDFKit

class CV16Generator {
    let profile: Profile
    
    init(profile: Profile) {
        self.profile = profile
    }
    
    let pageWidth : CGFloat = 595
    let pageHeight : CGFloat = 842
    
    let margin: CGFloat = 50.0
    
    let lm1: CGFloat = 43.0
    let lm2: CGFloat = 175.0
    let lm3: CGFloat = 595 - 110 - 43
    
    let columnLeftWidth: CGFloat = 130
    let columnCenterWidth: CGFloat = 360
    let columnRightWidth: CGFloat = 120
    
    let textColor = UIColor.black
    
    var currentLeftYOffset: CGFloat =  40
    var currentYCenterOffset: CGFloat =  40
    var currentRightYOffset: CGFloat =  35
    
    let estimateHeight: CGFloat = 50.0
    let bottomMargin: CGFloat = 30
    
    var socialMediaPageNumber:Int = 0
    
    var rectAndLinkDict: [String: CGRect] = [:]
    var contactsRect: [String: CGRect] = [:]
    var pageAndRectsForSeparator : [Int: [CGRect]] = [:]
    
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
        
        var separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
        
        if let generalInfo = profile.generalInfo {
        
            var image: UIImage?
            
            if let photoFileName = generalInfo.photoFileName {
                image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName)
            }
            
            if let image = image {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: 25 + 73 + 25, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            } else {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            }
         
            if let contactInfo = generalInfo.contactInfo {
                drawContactInCenterColumn(generalInfo: generalInfo, xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                if let email = contactInfo.email {
                    if email != "" {
                        drawContactInfoInCenterColumn(contact: email,type:"email", xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    }
                }
                
                if let phone = contactInfo.phone {
                    if phone != "" {
                        drawContactInfoInCenterColumn(contact: phone,type:"phone", xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    }
                }
            }
            
            if let aboutYourself = generalInfo.aboutYourself {
                var maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
                
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
                
                separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
                
                if let rects = pageAndRectsForSeparator[pageNumber] {
                    var rectsArray = pageAndRectsForSeparator[pageNumber]
                    rectsArray?.append(separatorRectangle)
                    pageAndRectsForSeparator[pageNumber] = rectsArray
                } else {
                    pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
                }
                
                maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
                
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
                
                
                drawAboutYourselfInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                drawAboutYourselfDescInRightColumn(generalInfo: generalInfo, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                
                maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
                
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
            }
        }
        
        if let workExperiences = profile.workExperiences, !workExperiences.isEmpty {
            var maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            
            
            drawWorkExperienceInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<workExperiences.count  {
                drawWorkExperienceDescriptionInCenterColumn(workExperience: workExperiences[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber, isLast: i == workExperiences.count - 1 ? true : false)
         
                let maxY : CGFloat =  max(currentYCenterOffset, currentRightYOffset)
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
                
            }
            
             maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) // + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
        }
     
  
        
      
        if let educations = profile.educations, !educations.isEmpty {
        
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
         var   maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            
            drawEducationInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<educations.count {
                drawEducationeDescriptionInCenterColumn(education: educations[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
              
                let maxY : CGFloat =  max(currentYCenterOffset, currentRightYOffset)
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
                
            }
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
      
      


        if let certificates = profile.certificates, !certificates.isEmpty {
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
           var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            
            drawCertificatesInCenterColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<certificates.count {
                drawCertificateDescriptionInCenterColumn(certificate: certificates[i], xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
               
                
                let maxY : CGFloat =  max(currentYCenterOffset, currentRightYOffset)
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
            }
        }
        
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {
            var  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            
            drawSkiilsInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            
            drawSkiilsDescriptionInRightColumn(professionalSkills: professionalSkills, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
        
       

        
 

        if let languages = profile.languages, !languages.isEmpty {
            
            var  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            drawLanguagesInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawLanguagesDescriptionInRightColumn(languages: languages, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
           
            
           maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }
     
        
        if let interests = profile.interests?.map({ $0.name }), !interests.isEmpty {
           
            var  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
            
            
            if let rects = pageAndRectsForSeparator[pageNumber] {
                var rectsArray = pageAndRectsForSeparator[pageNumber]
                rectsArray?.append(separatorRectangle)
                pageAndRectsForSeparator[pageNumber] = rectsArray
            } else {
                pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
            }
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            drawInterestsInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawInterestsDescriptionInRightColumn(interests: interests, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
        }

      
        
        
        
        if let socialMedia = profile.socialMedia {
            let instagramExist = socialMedia.instagram != "" && socialMedia.instagram != nil
            let facebookExist =  socialMedia.facebook != "" && socialMedia.facebook != nil
            let linkedIndExist = socialMedia.linkedIn != "" && socialMedia.linkedIn != nil
            let twitterExist = socialMedia.twitter != "" && socialMedia.twitter != nil
            
            if instagramExist || facebookExist || linkedIndExist || twitterExist {
                
                separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
                
                if let rects = pageAndRectsForSeparator[pageNumber] {
                    var rectsArray = pageAndRectsForSeparator[pageNumber]
                    rectsArray?.append(separatorRectangle)
                    pageAndRectsForSeparator[pageNumber] = rectsArray
                } else {
                    pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
                }
                
               var maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 40
                
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                currentRightYOffset = maxY
                
                
                var sm_lm2: CGFloat = lm2
                drawLinksMediaInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                var first: Bool = true
                socialMediaPageNumber = pageNumber
                
                if socialMedia.instagram != "" && socialMedia.instagram != nil {
                    let type: String = first ? "Instagram" : "  |  Instagram"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.instagram!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.facebook != "" && socialMedia.facebook != nil {
                    let type: String = first ? "Facebook" : "  |  Facebook"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.facebook!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil {
                    let type: String = first ? "LinkedIn" : "  |  LinkedIn"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.linkedIn!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.twitter != "" && socialMedia.twitter != nil {
                    let type: String = first ? "Twitter" : "  |  Twitter"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.twitter!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                
                maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
               
               currentLeftYOffset = maxY
               currentYCenterOffset = maxY
               currentRightYOffset = maxY
            }
            
        }
      
      

        // Render pages
        for page in 0..<pages.count {
            UIGraphicsBeginPDFPage()
            let context = UIGraphicsGetCurrentContext()!
            let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)
            if let backgroundImage = UIImage(named: "PDF6_1BackgroundImage") {
                drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
            }
            
            if page == 0 {
                if let generalInfo = profile.generalInfo {
                    if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                        drawCircularImage(image: image, context: context, pageRect: pageRect, at: CGPoint(x: 25, y: 26), size: CGSize(width: 73, height: 73))
                    }
                }
                for (type,rect) in contactsRect {
                    if type == "email" {
                        if let image = UIImage(named: "PDF6Email") {
                            drawImage(image: image, 
                                      context: context,
                                      pageRect: pageRect,
                                      at: CGPoint(x: rect.origin.x, y: rect.origin.y + 6.5),
                                      size: CGSize(width: 10, height: 10))
                        }
                    }
                    if type == "phone" {
                        if let image = UIImage(named: "PDF6Phone") {
                            drawImage(image: image, 
                                      context: context,
                                      pageRect: pageRect,
                                      at: CGPoint(x: rect.origin.x, y: rect.origin.y + 4.5),
                                      size: CGSize(width: 10, height: 10))
                        }
                    }
                }
               
            }
            if let rects = pageAndRectsForSeparator[page] {
                for rect in rects {
                    if let image = UIImage(named: "PDF6Separator") {
                        drawImage(image: image,
                                  context: context,
                                  pageRect: pageRect,
                                  at: rect.origin,
                                  size: rect.size)
                    }
                }
            }
            pages[page]?.forEach { $0() }
        }
        
        UIGraphicsEndPDFContext()
     
        let topMarginForSM: CGFloat = currentYCenterOffset
        if let pdfDocument = PDFDocument(data: pdfData as Data) {
            if let page = pdfDocument.page(at: socialMediaPageNumber) {
                // let imageRect = CGRect(x: 0, y: pageHeight - 40 - 56 , width: 56, height: 56)
                for (link,rect) in rectAndLinkDict {
                    var adaptedRect = CGRect(x: rect.minX,
                                             y: pageHeight -  rect.origin.y - 1.8*rect.height ,
                                             width: rect.width,
                                             height: rect.height)
                    let linkAnnotation = PDFAnnotation(bounds: adaptedRect, forType: .link, withProperties: nil)
                    linkAnnotation.url = URL(string: link)!
                    page.addAnnotation(linkAnnotation)
                }
            }
            return pdfDocument.dataRepresentation() ?? Data()
        }
     
        return pdfData as Data
    }
    
    func drawGeneraInfoInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        var fontSize:CGFloat = 20
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .left
        
        var fullNameFont = Fonts.Manrope.bold(size: fontSize)
        var fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var jobTitle = ""
        if let reference = profile.workExperiences?.first {
            if let jobTitle_ = reference.jobTitle {
                if jobTitle_ != "" {
                    jobTitle = jobTitle_
                }
            }
        }
        
        var text = "\(generalInfo.firstName ?? "") \(generalInfo.lastName ?? "")\n\(jobTitle)"
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
            var textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: 250, height: pageRect.height - bottomMargin - currentYCenterOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            var attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            var textHeight = calculateTextHeight(text: textToDraw, width: 250, attributes: fullNameAttributes)
            
            while textHeight > 60.0 {
                print("FontSize: \(fontSize)")
                fontSize = fontSize - 0.3
                fullNameFont = Fonts.Manrope.bold(size: fontSize)
                fullNameAttributes = [
                    .font: fullNameFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
                attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
                textHeight = calculateTextHeight(text: textToDraw, width: 250, attributes: fullNameAttributes)
            }
            textRect = CGRect(x: textRect.minX, y: (123 - textHeight)/2, width: textRect.width, height: textRect.height)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                attributedTextToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if !remainingText.isEmpty  {
                currentYCenterOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + 8
            }
        }
        text = remainingText
    }
    
    func drawAboutYourselfInRightColumn( xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Manrope.bold(size: 13)
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "About me"
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
                currentLeftYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawAboutYourselfDescInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Manrope.regular(size: 13)
        let textColor = UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0)
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
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Manrope.bold(size: 13)
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
        let fullNameFont = Fonts.Manrope.regular(size: 10)
        let textColor =  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0)
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
                if text == "" {
                    text += "\(skill)"
                } else {
                    text += "  |  \(skill)"
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
        let fullNameFont = Fonts.Manrope.bold(size: 13)
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
        let fullNameFont = Fonts.Manrope.regular(size: 10)
        let textColor =  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0)
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
        let fullNameFont = Fonts.Manrope.bold(size: 13)
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
    
    func drawLinksDescriptionInRightColumn(socialMedia: String, type: String, xOffset: inout CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Manrope.regular(size: 10)
        let textColor =  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0)
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
            print(calculateTextWidth(text: textToDraw, height: textHeight, attributes: fullNameAttributes))
            rectAndLinkDict[socialMedia] = CGRect(x: textRect.minX,
                                                  y: textRect.minY,
                                                  width: calculateTextWidth(text: textToDraw, height: textHeight, attributes: fullNameAttributes),
                                                  height: fullNameFont.pointSize)
           
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
                xOffset += calculateTextWidth(text: textToDraw, height: textHeight, attributes: fullNameAttributes)
                // currentYCenterOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Manrope.bold(size: 13)
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
        let fullNameFont = Fonts.Manrope.regular(size: 10)
        let textColor =  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0)
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
            if text == "" {
                if interest != "" {
                    text += interest
                }
            } else {
                if interest != "" {
                    text +=  "  |  " + interest
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
    func drawContactInCenterColumn(generalInfo: GeneralInfo , xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        if let contactInfo = generalInfo.contactInfo {
            
            let contactFont = Fonts.Manrope.medium(size: 10)
            
            
            let vertOffset = 7
            let contactParagraphStyle = NSMutableParagraphStyle()
            contactParagraphStyle.alignment = .left
            contactParagraphStyle.lineHeightMultiple = 1.3
            
            
            let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: contactFont,
                .foregroundColor: textColor,
                .paragraphStyle: contactParagraphStyle
                
            ]
            
            var text = "Contact:"
           
          
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
                        currentRightYOffset += textHeight + 3
                    }
                }
        }
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
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset + 20, y: currentRightYOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
            contactsRect[type] = CGRect(x: xOffset , y: currentRightYOffset , width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
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
                currentRightYOffset += textHeight + 0
            }
            
        }
    }
    
    func drawWorkExperienceInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int, checkTheNextText:NSMutableAttributedString? = nil) {
        
        let contactFont = Fonts.Manrope.bold(size: 12)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
    
    func drawWorkExperienceDescriptionInCenterColumn(workExperience: WorkExperience, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        // Define a paragraph style for company name and job title
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        companyAndJobParagraphStyle.lineSpacing = 5.0

        // Company Name
        if let companyName = workExperience.companyName, !companyName.isEmpty {
            let companyAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.bold(size: 10),
                .foregroundColor:  UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: companyName, attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }

        // Job Title
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor:  UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\n\(jobTitle)", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }

        // Define a separate paragraph style for results if needed
        let resultsParagraphStyle = NSMutableParagraphStyle()
        resultsParagraphStyle.paragraphSpacing = 5.0
        resultsParagraphStyle.lineSpacing = 5.0
   
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.alignment = .left
        dateParagraphStyle.paragraphSpacing = 5.0
        dateParagraphStyle.lineSpacing = 5.0
        
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
                .font: Fonts.Manrope.regular(size: 8),
                .foregroundColor: UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 0.8),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
   
        // Results
        if let results = workExperience.results, !results.isEmpty {
            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor:  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 1.0),
                .paragraphStyle: resultsParagraphStyle // Different paragraph style can be used here
            ]
            let attributedResultsText = NSAttributedString(string: "\n\(results)", attributes: resultsAttributes)
            combinedAttributedString.append(attributedResultsText)
        }

        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - currentYCenterOffset)
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
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawWorkExperienceDateInCenterColumn(workExperience: WorkExperience, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
    
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
                .font: Fonts.Manrope.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
      
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentRightYOffset , width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
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
                pageNumber += 1
            } else {
                currentRightYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
    func drawEducationInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.Manrope.bold(size: 12)
        
        
         
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.paragraphSpacing = 3.0
        
        
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
    
    func drawEducationeDescriptionInCenterColumn(education: Education, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let university = education.university, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.bold(size: 10),
                .foregroundColor: UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university, attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor: UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
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
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor:  UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 0.8),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "   \(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - currentYCenterOffset)
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
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawEducationeDateInCenterColumn(education: Education, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
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
                .font: Fonts.Manrope.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentRightYOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
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
                pageNumber += 1
            } else {
                currentRightYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.Manrope.bold(size: 12)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor = UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0)
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
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.medium(size: 10),
                .foregroundColor: UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university, attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor: UIColor(red: 29/255, green: 43/255, blue: 95/255, alpha: 1.0),
                .paragraphStyle: companyAndJobParagraphStyle
            ]
           
            let attributedJobTitleText = NSAttributedString(string: "\n\(description)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
        let  dateParagraphStyle = NSMutableParagraphStyle()
        dateParagraphStyle.paragraphSpacing = 8.0
        dateParagraphStyle.alignment = .left
        
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
                .font: Fonts.Manrope.regular(size: 10),
                .foregroundColor:UIColor(red: 93/255, green: 104/255, blue: 144/255, alpha: 0.8),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "  \(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset, width: columnCenterWidth, height: pageRect.height - bottomMargin - currentYCenterOffset)
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
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    func drawCertificateDateInCenterColumn(certificate: Certificate, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
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
                .font: Fonts.Manrope.regular(size: 8),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        
        while remainingText.length > 0 {
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentRightYOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
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
                pageNumber += 1
            } else {
                currentRightYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
}






extension CV16Generator {
    
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
