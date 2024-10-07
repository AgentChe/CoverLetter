import UIKit
import PDFKit

class CV15Generator {
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
            
            var maxY : CGFloat =  25 + 142 + 40
            if let image = image {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1 + 165 + 25, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            } else {
                drawGeneraInfoInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                maxY = currentYCenterOffset
            }
            
            
            
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
            
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
            if let aboutYourself = generalInfo.aboutYourself {
                if aboutYourself != "" {
                    drawAboutYourselfInRightColumn( xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    
                    drawAboutYourselfDescInRightColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    
                    maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
                    
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
                    
                    maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
                    
                    currentLeftYOffset = maxY
                    currentYCenterOffset = maxY
                    currentRightYOffset = maxY
                }
            }
            
        }
        
        var skillsPageNumber: Int = pageNumber
        var skillsDescPageNumber : Int = pageNumber
        
        if let workExperiences = profile.workExperiences, !workExperiences.isEmpty {
            drawWorkExperienceInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            for i in 0..<workExperiences.count  {
                drawWorkExperienceDescriptionInCenterColumn(workExperience: workExperiences[i], xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber, isLast: i == workExperiences.count - 1 ? true : false)
         
                let maxY : CGFloat =  max(currentYCenterOffset,currentLeftYOffset) + 25
                currentLeftYOffset = maxY
                currentYCenterOffset = maxY
                
                
            }
        }
        
        if let professionalSkills = profile.professionalSkills?.map({ $0.name }), !professionalSkills.isEmpty {

            drawSkiilsInRightColumn( xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &skillsPageNumber)


            drawSkiilsDescriptionInRightColumn(professionalSkills: professionalSkills, xOffset: lm3, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &skillsDescPageNumber)
            
            let maxSkillsPageNumber = max(skillsPageNumber,skillsDescPageNumber)
            let maxPageNumber = max(pageNumber,maxSkillsPageNumber)
            
            let yoffset = 0.0
            if maxPageNumber == maxSkillsPageNumber && maxPageNumber == pageNumber {
                var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset,currentRightYOffset)
                currentLeftYOffset = maxY + yoffset
                currentYCenterOffset = maxY + yoffset
                currentRightYOffset = maxY + yoffset
            } else {
                if maxPageNumber == pageNumber {
                    var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset)
                    currentLeftYOffset = maxY + yoffset
                    currentYCenterOffset = maxY + yoffset
                    currentRightYOffset = maxY + yoffset
                } else {
                    if maxPageNumber == maxSkillsPageNumber {
                        currentLeftYOffset = currentRightYOffset + yoffset
                        currentYCenterOffset = currentRightYOffset + yoffset
                        currentRightYOffset += yoffset
                    }
                }
            }
            pageNumber = maxPageNumber
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
           
           if let rects = pageAndRectsForSeparator[pageNumber] {
               var rectsArray = pageAndRectsForSeparator[pageNumber]
               rectsArray?.append(separatorRectangle)
               pageAndRectsForSeparator[pageNumber] = rectsArray
           } else {
               pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
           }
           
          let  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
           
           currentLeftYOffset = maxY
           currentYCenterOffset = maxY
           currentRightYOffset = maxY
           
        } else {
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
           
           if let rects = pageAndRectsForSeparator[pageNumber] {
               var rectsArray = pageAndRectsForSeparator[pageNumber]
               rectsArray?.append(separatorRectangle)
               pageAndRectsForSeparator[pageNumber] = rectsArray
           } else {
               pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
           }
           
            let maxSkillsPageNumber = max(skillsPageNumber,skillsDescPageNumber)
            let maxPageNumber = max(pageNumber,maxSkillsPageNumber)
            
            let yoffset = 25.0
            if maxPageNumber == maxSkillsPageNumber && maxPageNumber == pageNumber {
                var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset,currentRightYOffset)
                currentLeftYOffset = maxY + yoffset
                currentYCenterOffset = maxY + yoffset
                currentRightYOffset = maxY + yoffset
            } else {
                if maxPageNumber == pageNumber {
                    var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset)
                    currentLeftYOffset = maxY + yoffset
                    currentYCenterOffset = maxY + yoffset
                    currentRightYOffset = maxY + yoffset
                } else {
                    if maxPageNumber == maxSkillsPageNumber {
                        currentLeftYOffset = currentRightYOffset + yoffset
                        currentYCenterOffset = currentRightYOffset + yoffset
                        currentRightYOffset += yoffset
                    }
                }
            }
        }


      
        if let educations = profile.educations, !educations.isEmpty {
            drawEducationInCenterColumn (xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            var  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 0
             
             currentLeftYOffset = maxY
             currentYCenterOffset = maxY
             currentRightYOffset = maxY
            
            
            
            var i = 0
            
            while (i < educations.count) {
                var leftPage = pageNumber
                var centerPage = pageNumber
                var rightPage = pageNumber
                //left
                if i + 0 < educations.count {
                    drawEducationeDescriptionInCenterColumn(
                        education: educations[i],
                        currentYOffset: &currentLeftYOffset,
                        xOffset: lm1,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &leftPage)
                }
                //center
                if i + 1 < educations.count {
                    drawEducationeDescriptionInCenterColumn(
                        education: educations[i],
                        currentYOffset: &currentYCenterOffset,
                        xOffset:  (pageWidth - 2*lm1)/2.26  ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &centerPage)
                }
                //right
                if i + 2 < educations.count {
                    drawEducationeDescriptionInCenterColumn(
                        education: educations[i],
                        currentYOffset: &currentRightYOffset,
                        xOffset:  2*(pageWidth - 2*lm1)/2.5 ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &rightPage)
                }
                
                let maxSkillsPageNumber = max(leftPage,rightPage)
                let maxPageNumber = max(centerPage,maxSkillsPageNumber)
                
                let yoffset = 20.0
                if maxPageNumber == maxSkillsPageNumber && maxPageNumber == pageNumber {
                    var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset,currentRightYOffset)
                    currentLeftYOffset = maxY + yoffset
                    currentYCenterOffset = maxY + yoffset
                    currentRightYOffset = maxY + yoffset
                } else {
                    if maxPageNumber == pageNumber {
                        var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset)
                        currentLeftYOffset = maxY + yoffset
                        currentYCenterOffset = maxY + yoffset
                        currentRightYOffset = maxY + yoffset
                    } else {
                        if maxPageNumber == maxSkillsPageNumber {
                            currentLeftYOffset = currentRightYOffset + yoffset
                            currentYCenterOffset = currentRightYOffset + yoffset
                            currentRightYOffset += yoffset
                        }
                    }
                }
                pageNumber = maxPageNumber
                
                i = i + 3
            }
         
                
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
           
           if let rects = pageAndRectsForSeparator[pageNumber] {
               var rectsArray = pageAndRectsForSeparator[pageNumber]
               rectsArray?.append(separatorRectangle)
               pageAndRectsForSeparator[pageNumber] = rectsArray
           } else {
               pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
           }
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY

            
        }
      
        

        if let certificates = profile.certificates, !certificates.isEmpty {
            drawCertificatesInCenterColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            var  maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 0
             
             currentLeftYOffset = maxY
             currentYCenterOffset = maxY
             currentRightYOffset = maxY
            
            var i = 0
            
            while (i < certificates.count) {
                var leftPage = pageNumber
                var centerPage = pageNumber
                var rightPage = pageNumber
                //left
                if i + 0 < certificates.count {
                    drawCertificateDescriptionInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentLeftYOffset,
                        xOffset: lm1,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &leftPage)
                    drawCertificateDateInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentLeftYOffset,
                        xOffset: lm1,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &leftPage)
                }
                //center
                if i + 1 < certificates.count {
                    drawCertificateDescriptionInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentYCenterOffset,
                        xOffset:  (pageWidth - 2*lm1)/2.26  ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &centerPage)
                    drawCertificateDateInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentYCenterOffset,
                        xOffset:  (pageWidth - 2*lm1)/2.26  ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &centerPage)
                }
                //right
                if i + 2 < certificates.count {
                    drawCertificateDescriptionInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentRightYOffset,
                        xOffset:  2*(pageWidth - 2*lm1)/2.5 ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &rightPage)
                    drawCertificateDateInCenterColumn(
                        certificate: certificates[i],
                        currentYOffset: &currentRightYOffset,
                        xOffset:  2*(pageWidth - 2*lm1)/2.5 ,
                        pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight),
                        pages: &pages,
                        pageNumber: &rightPage)
                    
                }
                
                let maxSkillsPageNumber = max(leftPage,rightPage)
                let maxPageNumber = max(centerPage,maxSkillsPageNumber)
                
                let yoffset = 20.0
                if maxPageNumber == maxSkillsPageNumber && maxPageNumber == pageNumber {
                    var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset,currentRightYOffset)
                    currentLeftYOffset = maxY + yoffset
                    currentYCenterOffset = maxY + yoffset
                    currentRightYOffset = maxY + yoffset
                } else {
                    if maxPageNumber == pageNumber {
                        var maxY : CGFloat =  max(currentLeftYOffset, currentYCenterOffset)
                        currentLeftYOffset = maxY + yoffset
                        currentYCenterOffset = maxY + yoffset
                        currentRightYOffset = maxY + yoffset
                    } else {
                        if maxPageNumber == maxSkillsPageNumber {
                            currentLeftYOffset = currentRightYOffset + yoffset
                            currentYCenterOffset = currentRightYOffset + yoffset
                            currentRightYOffset += yoffset
                        }
                    }
                }
                pageNumber = maxPageNumber
                
                i = i + 3
            }
            
            separatorRectangle = CGRect(x: lm1, y: currentYCenterOffset, width: pageWidth - 2*lm1, height: 1)
           
           if let rects = pageAndRectsForSeparator[pageNumber] {
               var rectsArray = pageAndRectsForSeparator[pageNumber]
               rectsArray?.append(separatorRectangle)
               pageAndRectsForSeparator[pageNumber] = rectsArray
           } else {
               pageAndRectsForSeparator[pageNumber] = [separatorRectangle]
           }
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
        }
 


        if let languages = profile.languages, !languages.isEmpty {
            
            drawLanguagesInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawLanguagesDescriptionInRightColumn(languages: languages, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            var maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
           
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
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
            
        }
       
        
        if let interests = profile.interests?.map({ $0.name }), !interests.isEmpty {
            
            drawInterestsInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
            
            drawInterestsDescriptionInRightColumn(interests: interests, xOffset: lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
      
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
            maxY =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 30
            
            currentLeftYOffset = maxY
            currentYCenterOffset = maxY
            currentRightYOffset = maxY
        }

      
        if let generalInfo = profile.generalInfo {
            
               if let contactInfo = generalInfo.contactInfo {
                   drawContactInCenterColumn(generalInfo: generalInfo, xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
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
               }
               
        }
        
    
        
        if let socialMedia = profile.socialMedia {
            let instagramExist = socialMedia.instagram != "" && socialMedia.instagram != nil
            let facebookExist =  socialMedia.facebook != "" && socialMedia.facebook != nil
            let linkedIndExist = socialMedia.linkedIn != "" && socialMedia.linkedIn != nil
            let twitterExist = socialMedia.twitter != "" && socialMedia.twitter != nil
            
            if instagramExist || facebookExist || linkedIndExist || twitterExist {
                let fullNameFont = Fonts.Inter.bold(size: 10)
                let textColor = UIColor.black
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineHeightMultiple = 0.6
                paragraphStyle.alignment = .left
                
                let fullNameAttributes: [NSAttributedString.Key: Any] = [
                    .font: fullNameFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: paragraphStyle
                ]
                
                var  textToDraw =  socialMedia.twitter != "" ? "          Twitter\n          –––––––" : ""
                
                if textToDraw == "" {
                    textToDraw =  socialMedia.linkedIn != "" ? "         LinkedIn\n        –––––––––" : ""
                }
                if textToDraw == "" {
                    textToDraw =  socialMedia.facebook != "" ? "       Facebook\n      ––––––––––" : ""
                }
                if textToDraw == "" {
                    textToDraw =  socialMedia.instagram != "" ? "    Instagram\n    ––––––––––" : ""
                }
                
                
                
                
                let textHeight = calculateTextHeight(text: textToDraw, width: columnCenterWidth, attributes: fullNameAttributes)
                var sm_lm2: CGFloat = pageWidth - lm1 - calculateTextWidth(text: textToDraw, height: textHeight, attributes: fullNameAttributes)
                //    drawLinksMediaInRightColumn(xOffset: lm1, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                var first: Bool = true
                socialMediaPageNumber = pageNumber
                if socialMedia.twitter != "" && socialMedia.twitter != nil {
                    let type: String = first ? "          Twitter\n          –––––––" : "       Twitter\n       –––––––"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.twitter!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.linkedIn != "" && socialMedia.linkedIn != nil {
                    let type: String = first ? "LinkedIn\n–––––––––" : "         LinkedIn\n        –––––––––"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.linkedIn!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.facebook != "" && socialMedia.facebook != nil {
                    let type: String = first ? "Facebook\n–––––––––" : "       Facebook\n      ––––––––––"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.facebook!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                if socialMedia.instagram != "" && socialMedia.instagram != nil {
                    let type: String = first ? "Instagram\n––––––––––" : "    Instagram\n    ––––––––––"
                    drawLinksDescriptionInRightColumn(socialMedia: socialMedia.instagram!, type: type, xOffset: &sm_lm2, pageRect: CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight), pages: &pages, pageNumber: &pageNumber)
                    first = false
                }
                
                
                
                
                
                
                let maxY : CGFloat =  max(currentLeftYOffset, max(currentYCenterOffset, currentRightYOffset)) + 20
                
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
           
            if let backgroundImage = UIImage(named: "PDF16BackgroundImage") {
                drawBackground(context: context, pageRect: pageRect, image: backgroundImage)
            }
          
            if page == 0 {
                if let generalInfo = profile.generalInfo {
                    if let photoFileName = generalInfo.photoFileName, let image = DocumentsDirectory.loadImageFromDocumentsDirectory(fileName: photoFileName) {
                        drawImageAspectFill(image: image, context: context, pageRect: pageRect, at: CGPoint(x: lm1, y: 25), size: CGSize(width: 165, height: 142))
                    }
                }
            }
            
            if let rects = pageAndRectsForSeparator[page] {
                for rect in rects {
                    if let image = UIImage(named: "PDF16Separator") {
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
                                             y: pageHeight -  rect.origin.y - 1*rect.height ,
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
        var fontSizeName: CGFloat = 10
        var fontSizeJob: CGFloat = 18
        let textColor = UIColor.black

        // Paragraph style for full name
        let fullNameParagraphStyle = NSMutableParagraphStyle()
        fullNameParagraphStyle.alignment = .left

        // Paragraph style for job title
        let jobTitleParagraphStyle = NSMutableParagraphStyle()
        jobTitleParagraphStyle.alignment = .left
        jobTitleParagraphStyle.paragraphSpacingBefore = 10.0 // Example customization for job title

        // Attributes for full name
        var fullNameFont = Fonts.Inter.bold(size: fontSizeName)
        var fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: fullNameParagraphStyle
        ]

        // Attributes for job title
        let jobTitleFont = Fonts.Inter.bold(size: fontSizeJob)
        let jobTitleAttributes: [NSAttributedString.Key: Any] = [
            .font: jobTitleFont,
            .foregroundColor: textColor,
            .paragraphStyle: jobTitleParagraphStyle
        ]

        var jobTitle = "Job Title"
        if let reference = profile.workExperiences?.first, let jobTitle_ = reference.jobTitle, !jobTitle_.isEmpty {
            jobTitle = jobTitle_
        }

        // Create attributed string for the full name
        let fullNameText = "\(generalInfo.firstName ?? "") \(generalInfo.lastName ?? "")".uppercased()
        var attributedText = NSMutableAttributedString(string: fullNameText, attributes: fullNameAttributes)

        // Add job title as a new line with its own paragraph style
        let jobTitleText = "\n\(jobTitle)".uppercased()
        let attributedJobTitle = NSAttributedString(string: jobTitleText, attributes: jobTitleAttributes)
        attributedText.append(attributedJobTitle)

        var remainingText = attributedText
        
        guard remainingText.length > 0 else { return }
           
           
           while remainingText.length > 0 {
            if pageRect.height  - currentYCenterOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                pageNumber += 1
            }
               var textRect = CGRect(x: xOffset, y: currentYCenterOffset , width: 250, height: pageRect.height - bottomMargin - currentYCenterOffset)
            var (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            
            var textHeight = calculateTextHeight(text: textToDraw, width: 250)
            
            while textHeight > 60.0 {
                print("FontSizeJob: \(fontSizeJob)")
                fontSizeJob = fontSizeJob - 0.3
                // Paragraph style for full name
                let fullNameParagraphStyle = NSMutableParagraphStyle()
                fullNameParagraphStyle.alignment = .left

                // Paragraph style for job title
                let jobTitleParagraphStyle = NSMutableParagraphStyle()
                jobTitleParagraphStyle.alignment = .left
                jobTitleParagraphStyle.paragraphSpacingBefore = 4.0 // Example customization for job title

                // Attributes for full name
                var fullNameFont = Fonts.Inter.bold(size: fontSizeName)
                var fullNameAttributes: [NSAttributedString.Key: Any] = [
                    .font: fullNameFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: fullNameParagraphStyle
                ]

                // Attributes for job title
                let jobTitleFont = Fonts.Inter.bold(size: fontSizeJob)
                let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                    .font: jobTitleFont,
                    .foregroundColor: textColor,
                    .paragraphStyle: jobTitleParagraphStyle
                ]

                var jobTitle = "Job Title"
                if let reference = profile.workExperiences?.first, let jobTitle_ = reference.jobTitle, !jobTitle_.isEmpty {
                    jobTitle = jobTitle_
                }

                // Create attributed string for the full name
                let fullNameText = "\(generalInfo.firstName ?? "") \(generalInfo.lastName ?? "")".uppercased()
                var attributedText = NSMutableAttributedString(string: fullNameText, attributes: fullNameAttributes)

                // Add job title as a new line with its own paragraph style
                let jobTitleText = "\n\(jobTitle)".uppercased()
                let attributedJobTitle = NSAttributedString(string: jobTitleText, attributes: jobTitleAttributes)
                attributedText.append(attributedJobTitle)
                
                (textToDraw, remainder) = splitTextToFit(rect: textRect, text: attributedText)
                
                textHeight = calculateTextHeight(text: textToDraw, width: 250)
            }
               textRect = CGRect(x: textRect.minX, y: currentYCenterOffset + 15 , width: textRect.width, height: textRect.height)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
           
            if remainingText.length > 0  {
                currentYCenterOffset = margin
                pageNumber += 1
            } else {
                currentYCenterOffset += textHeight + 8
            }
        }
    }
    
    func drawAboutYourselfInRightColumn( xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.bold(size: 13)
        let textColor = UIColor(white: 0, alpha: 0.7)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "About me".uppercased()
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
                currentLeftYOffset += textHeight + 10
            }
            
        }
        
        text = remainingText
    }
    
    func drawAboutYourselfDescInRightColumn(generalInfo: GeneralInfo, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.medium(size: 9)
        let textColor = UIColor(white: 0, alpha: 0.7)
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
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textWidth = pageWidth - 2*lm1
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: textWidth, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: textWidth, attributes: fullNameAttributes)
            
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
                currentLeftYOffset += textHeight
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.bold(size: 13)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "SKILLS"
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentRightYOffset, width: columnRightWidth , height: pageRect.height - bottomMargin - currentRightYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth, attributes: fullNameAttributes)
            
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
                currentRightYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    func drawSkiilsDescriptionInRightColumn(professionalSkills: [String], xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.regular(size: 10)
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
                if text == "" {
                    text += "\(skill)"
                } else {
                    text += "\n\(skill)"
                }
            }
        }
        var remainingText = text
        
        guard text != "" else { return }
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentRightYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentRightYOffset, width: columnRightWidth , height: pageRect.height - bottomMargin - currentRightYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText, attributes: fullNameAttributes)
            let attributedTextToDraw = NSAttributedString(string: textToDraw, attributes: fullNameAttributes)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: columnRightWidth, attributes: fullNameAttributes)
            
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
                currentRightYOffset += textHeight + 25
            }
            
        }
        
        text = remainingText
    }
    
    
    func drawLanguagesInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.bold(size: 13)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "LANGUAGES"
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
        let fullNameFont = Fonts.Inter.regular(size: 10)
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
        let fullNameFont = Fonts.Inter.bold(size: 13)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "LINKS"
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
        let fullNameFont = Fonts.Inter.bold(size: 10)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 0.6
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
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            
            let textRect = CGRect(x: xOffset, y: currentYCenterOffset + 10, width: columnCenterWidth , height: pageRect.height - bottomMargin - currentYCenterOffset)
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
                xOffset -= calculateTextWidth(text: textToDraw, height: textHeight, attributes: fullNameAttributes)
                // currentYCenterOffset += textHeight
            }
        }
    }
    
    
    func drawInterestsInRightColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int) {
        let fullNameFont = Fonts.Inter.bold(size: 13)
        let textColor = UIColor.black
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.2
        paragraphStyle.alignment = .left
        
        let fullNameAttributes: [NSAttributedString.Key: Any] = [
            .font: fullNameFont,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
        
        var text = "INTERESTS"
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
        let fullNameFont = Fonts.Inter.regular(size: 10)
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
            
            let contactFont = Fonts.Inter.bold(size: 9)
            
            
            let vertOffset = 7
            let contactParagraphStyle = NSMutableParagraphStyle()
            contactParagraphStyle.alignment = .left
            contactParagraphStyle.lineHeightMultiple = 1.3
        
            
            
            let textColor = UIColor.black
            let textAttributes: [NSAttributedString.Key: Any] = [
                .font: contactFont,
                .foregroundColor: textColor,
                .paragraphStyle: contactParagraphStyle,
                .kern : 1.1
                
            ]
            
            var text = "Contact".uppercased()
           
          
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
        
        
        let contactFont = Fonts.Inter.medium(size: 8)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.lineHeightMultiple = 1.3
        
        
        let textColor =  UIColor(red: 0.4078, green: 0.4078, blue: 0.4078, alpha: 1.0)
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = contact
        
        
        
        guard text != "" else { return }
        
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentRightYOffset - 10 < estimateHeight {
                currentYCenterOffset = margin
                currentRightYOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset , y: currentRightYOffset, width: columnRightWidth, height: pageRect.height - bottomMargin - currentRightYOffset)
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
        
        let contactFont = Fonts.Inter.bold(size: 12)
        
        
        let vertOffset = 7
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "MY EXPERIENCE".uppercased()
        guard text != "" else { return }
        var remainingText = text
        
        
        while !remainingText.isEmpty {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
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
                .font: Fonts.Inter.semibold(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: companyName.uppercased(), attributes: companyAttributes)
            combinedAttributedString.append(attributedCompanyText)
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
                dateText += " / \(endDateString)"
            } else {
                dateText += " / PRESENT"
            }

            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 9),
                .foregroundColor: UIColor(red: 117/255, green: 117/255, blue: 117/255, alpha: 1.0),
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "  \(dateText.uppercased())", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)

        // Job Title
        if let jobTitle = workExperience.jobTitle, !jobTitle.isEmpty {
            let jobTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedJobTitleText = NSAttributedString(string: "\n\(jobTitle.uppercased())", attributes: jobTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }

        
        }
   
        // Results
        if let results = workExperience.results, !results.isEmpty {
            let resultsAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 10),
                .foregroundColor: UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0),
                .paragraphStyle: resultsParagraphStyle // Different paragraph style can be used here
            ]
            let attributedResultsText = NSAttributedString(string: "\n\(results)", attributes: resultsAttributes)
            combinedAttributedString.append(attributedResultsText)
        }

        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        
        let textWidth: CGFloat = 350
        while remainingText.length > 0 {
            if pageRect.height  - currentLeftYOffset - bottomMargin < estimateHeight {
                currentYCenterOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentLeftYOffset, width: textWidth, height: pageRect.height - bottomMargin - currentLeftYOffset)
            let (textToDraw, remainder) = splitTextToFit(rect: textRect, text: remainingText)
            
            let textHeight = calculateTextHeight(text: textToDraw, width: textWidth)
            
            if pages[pageNumber] == nil {
                pages[pageNumber] = []
            }
            pages[pageNumber]?.append {
                textToDraw.draw(in: textRect)
            }
            
            remainingText = remainder
            
            
            if remainingText.length > 0 {
                currentYCenterOffset = margin
                currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentLeftYOffset += textHeight
            }
            
        }
    }

    func drawEducationInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.Inter.bold(size: 12)
        
        
         
        let contactParagraphStyle = NSMutableParagraphStyle()
        contactParagraphStyle.alignment = .left
        contactParagraphStyle.paragraphSpacing = 3.0
        
        
        let textColor = UIColor.black
        let textAttributes: [NSAttributedString.Key: Any] = [
            .font: contactFont,
            .foregroundColor: textColor,
            .paragraphStyle: contactParagraphStyle
            
        ]
        
        var text = "EDUCATION".uppercased()
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
    
    func drawEducationeDescriptionInCenterColumn(education: Education,currentYOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 6.0
        
        if let university = education.university, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university.uppercased(), attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var fieldOfStudy = education.fieldOfStudy, !fieldOfStudy.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 9),
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
                .font: Fonts.Inter.regular(size:9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\n\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        var remainingText = combinedAttributedString
        let columnWidth = (pageWidth - 2*lm1)/3 - 20
        
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                //currentYCenterOffset = margin
                //currentRightYOffset = margin
                //currentLeftYOffset = margin
                currentYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height - bottomMargin - currentYOffset)
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
               // currentYCenterOffset = margin
               // currentRightYOffset = margin
               // currentLeftYOffset = margin
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
    
    func drawCertificatesInCenterColumn(xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,checkTheNextText:NSMutableAttributedString? = nil) {
        
        
        let contactFont = Fonts.Inter.bold(size: 12)
        
        
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
        
        var text = "CERTIFICATES".uppercased()
       
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
    
    
    func drawCertificateDescriptionInCenterColumn(certificate: Certificate,currentYOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 5.0
        
        if let university = certificate.organizationName, !university.isEmpty {
            let universityAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.bold(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
            let attributedCompanyText = NSAttributedString(string: university, attributes: universityAttributes)
            combinedAttributedString.append(attributedCompanyText)
        }
        
        if var description = certificate.description, !description.isEmpty {
            let fieldOfStudyTitleAttributes: [NSAttributedString.Key: Any] = [
                .font: Fonts.Inter.regular(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: companyAndJobParagraphStyle
            ]
           
            let attributedJobTitleText = NSAttributedString(string: "\n\(description)", attributes: fieldOfStudyTitleAttributes)
            combinedAttributedString.append(attributedJobTitleText)
        }
      
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        let columnWidth = (pageWidth - 2*lm1)/3 - 20
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
                //currentYCenterOffset = margin
                //currentRightYOffset = margin
                //currentLeftYOffset = margin
                currentYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height - bottomMargin - currentYOffset)
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
                //currentYCenterOffset = margin
               // currentRightYOffset = margin
               // currentLeftYOffset = margin
                currentYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + 4
            }
            
        }
    }
    func drawCertificateDateInCenterColumn(certificate: Certificate,currentYOffset: inout CGFloat, xOffset: CGFloat, pageRect: CGRect, pages: inout [Int: [() -> Void]], pageNumber: inout Int,  checkTheNextText:NSMutableAttributedString? = nil, isLast: Bool = false) {
        var combinedAttributedString = NSMutableAttributedString()
        let companyAndJobParagraphStyle = NSMutableParagraphStyle()
        companyAndJobParagraphStyle.paragraphSpacing = 3.0
        
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
                .font: Fonts.Inter.regular(size: 9),
                .foregroundColor: UIColor.black,
                .paragraphStyle: dateParagraphStyle
            ]
            let attributedDateText = NSAttributedString(string: "\(dateText)", attributes: dateAttributes)
            combinedAttributedString.append(attributedDateText)
        }
        
        guard combinedAttributedString.length > 0 else { return }
        
        var remainingText = combinedAttributedString
        let columnWidth = (pageWidth - 2*lm1)/3 - 20
        while remainingText.length > 0 {
            if pageRect.height  - currentYOffset - bottomMargin < estimateHeight {
               // currentYCenterOffset = margin
               // currentRightYOffset = margin
               // currentLeftYOffset = margin
                pageNumber += 1
            }
            let textRect = CGRect(x: xOffset, y: currentYOffset, width: columnWidth, height: pageRect.height - bottomMargin - currentYOffset)
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
               // currentYCenterOffset = margin
               // currentRightYOffset = margin
              //  currentLeftYOffset = margin
                pageNumber += 1
            } else {
                currentYOffset += textHeight + (isLast ? 30 : 15)
            }
            
        }
    }
    
}






extension CV15Generator {
    
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
    func drawImageAspectFill(image: UIImage, context: CGContext, pageRect: CGRect, at point: CGPoint, size: CGSize) {
        context.saveGState()
        
        context.translateBy(x: 0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        
        let imageSize = image.size
        let aspectWidth = size.width / imageSize.width
        let aspectHeight = size.height / imageSize.height
        let aspectRatio = max(aspectWidth, aspectHeight) // Use max for aspect fill
        
        let scaledImageSize = CGSize(width: imageSize.width * aspectRatio, height: imageSize.height * aspectRatio)
        
        let imageRect = CGRect(
            x: point.x,
            y: pageRect.size.height - point.y - size.height,
            width: size.width,
            height: size.height
        )
        
        context.clip(to: imageRect) // Ensure the image fills the space exactly
        context.draw(image.cgImage!, in: CGRect(x: point.x - (scaledImageSize.width - size.width) / 2,
                                                y: pageRect.size.height - point.y - (scaledImageSize.height - size.height) / 2 - scaledImageSize.height,
                                                width: scaledImageSize.width,
                                                height: scaledImageSize.height))
        context.restoreGState()
    }


   
}
