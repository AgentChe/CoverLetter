//
//  PDFViewController.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.08.2024.
//

import UIKit
import PDFKit

final class PDFViewController: UIViewController {
    private let pdf: Data
    
    init(pdf: Data) {
        self.pdf = pdf
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Appearance.main100
        
        let pdfView = PDFView()
        pdfView.document = PDFDocument(data: pdf)
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pdfView)
        
        let originalWidth: CGFloat = 595.44
        let originalHeight: CGFloat = 841.68
        let scale: CGFloat = 0.7
        
        NSLayoutConstraint.activate([
            pdfView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pdfView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pdfView.widthAnchor.constraint(equalToConstant: originalWidth * scale),
            pdfView.heightAnchor.constraint(equalToConstant: originalHeight * scale)
        ])
    }
}
