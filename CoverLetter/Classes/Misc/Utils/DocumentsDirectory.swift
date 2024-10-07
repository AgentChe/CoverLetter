//
//  DocumentsDirectory.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 23.05.2024.
//

import UIKit

final class DocumentsDirectory {
    enum ReserveNames {
        static let cvPhoto = "documents_directory_cv_photo_name"
    }
    
    @discardableResult
    static func saveImageToDocumentsDirectory(image: UIImage, fileName: String) -> URL? {
        if let data = image.pngData() {
            let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
            do {
                try data.write(to: filePath)
                return filePath
            } catch {
                return nil
            }
        }
        
        return nil
    }
    
    static func loadImageFromDocumentsDirectory(fileName: String) -> UIImage? {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: filePath.path) {
            return UIImage(contentsOfFile: filePath.path)
        } else {
            return nil
        }
    }
    
    static func deleteImageFromDocumentsDirectory(fileName: String) {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: filePath.path) {
            try? FileManager.default.removeItem(at: filePath)
        }
    }
}

// MARK: Private
private extension DocumentsDirectory {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
