//
//  Fonts.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import UIKit

struct Fonts {
    // MARK: Bitter
    struct Bitter {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Bitter-Bold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Bitter-Medium", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Bitter-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Bitter-Regular", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "Bitter-ExtraBold", size: size)!
        }
    }
    
    // MARK: Nunito
    struct Nunito {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Nunito-Bold", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Nunito-Medium", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Nunito-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Nunito-Regular", size: size)!
        }
        
        static func extraBold(size: CGFloat) -> UIFont {
            UIFont(name: "Nunito-ExtraBold", size: size)!
        }
    }
    
    // MARK: SFPro
    struct SFPro {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Bold", size: size)!
        }
        
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Semibold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SFProText-Regular", size: size)!
        }
        
        static func light(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .light)
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .medium)
        }
        
        static func thin(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .thin)
        }
        
        static func heavy(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .heavy)
        }
        
        static func black(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .black)
        }
        
        static func ultraLight(size: CGFloat) -> UIFont {
            UIFont.systemFont(ofSize: size, weight: .ultraLight)
        }
    }
    
    // MARK: SpaceGrotesk
    struct SpaceGrotesk {
        static func light(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Light", size: size)!
        }
      
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Regular", size: size)!
        }
     
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Medium", size: size)!
        }
      
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Semibold", size: size)!
        }
      
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceGrotesk-Bold", size: size)!
        }
    }
    
    // MARK: Inter
    struct Inter {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter18pt-Bold", size: size)!
        }
        
        static func semibold(size: CGFloat) -> UIFont {
            UIFont(name: "Inter18pt-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Inter18pt-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Inter18pt-Medium", size: size)!
        }
    }
    
    // MARK: Archivo
    struct Archivo {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Archivo-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Archivo-Medium", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Archivo-Regular", size: size)!
        }
        
        static func regularItalic(size: CGFloat) -> UIFont {
            UIFont(name: "Archivo-Italic", size: size)!
        }
    }
    
    // MARK: Lora
    struct Lora {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Lora-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Lora-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Lora-Medium", size: size)!
        }
        
        static func regularItalic(size: CGFloat) -> UIFont {
            UIFont(name: "Lora-Italic", size: size)!
        }
    }
    
    // MARK: Outfit
    struct Outfit {
        static func semiBold(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-SemiBold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Outfit-Regular", size: size)!
        }
    }
    
    // MARK: SplineSans
    struct SplineSans {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SplineSans-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SplineSans-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "SplineSans-Medium", size: size)!
        }
    }
    
    // MARK: SpaceMono
    struct SpaceMono {
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SpaceMono-Regular", size: size)!
        }
    }
    
    // MARK: Montserrat
    struct Montserrat {
        static func black(size: CGFloat) -> UIFont {
            UIFont(name: "Montserrat-Black", size: size)!
        }
    }
    
    // MARK: Poppins
    struct Poppins {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Poppins-Medium", size: size)!
        }
    }
    
    // MARK: Roboto
    struct Roboto {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Roboto-Medium", size: size)!
        }
    }
    
    // MARK: Lato
    struct Lato {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Lato-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Lato-Regular", size: size)!
        }
        
        static func heavy(size: CGFloat) -> UIFont {
            UIFont(name: "Lato-Heavy", size: size)!
        }
    }
    
    // MARK: SourceSansPro
    struct SourceSansPro {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "SourceSansPro-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "SourceSansPro-Regular", size: size)!
        }
    }
    
    // MARK: PlayfairDisplay
    struct PlayfairDisplay {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "PlayfairDisplay-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "PlayfairDisplay-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "PlayfairDisplay-Medium", size: size)!
        }
    }
    
    // MARK: Mulish
    struct Mulish {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Mulish-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Mulish-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Mulish-Medium", size: size)!
        }
    }
    
    // MARK: Arial
    struct Arial {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Arial-BoldMT", size: size)!
        }
        
        static func boldItalic(size: CGFloat) -> UIFont {
            UIFont(name: "Arial-BoldItalicMT", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "ArialMT", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Arial-Mdm", size: size)!
        }
    }
    
    // MARK: Manrope
    struct Manrope {
        static func bold(size: CGFloat) -> UIFont {
            UIFont(name: "Manrope-Bold", size: size)!
        }
        
        static func regular(size: CGFloat) -> UIFont {
            UIFont(name: "Manrope-Regular", size: size)!
        }
        
        static func medium(size: CGFloat) -> UIFont {
            UIFont(name: "Manrope-Medium", size: size)!
        }
    }
}
