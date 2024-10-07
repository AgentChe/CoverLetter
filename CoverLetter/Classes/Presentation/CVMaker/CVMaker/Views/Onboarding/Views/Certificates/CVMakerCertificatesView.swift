//
//  CVMakerCertificatesView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMakerCertificatesView: UIView {
    private weak var vc: UIViewController?
    private let bind: (([Certificate]) -> Void)
    private let flowFinished: (() -> Void)
    
    init(
        vc: UIViewController?,
        bind: @escaping (([Certificate]) -> Void),
        flowFinished: @escaping (() -> Void)
    ) {
        self.vc = vc
        self.bind = bind
        self.flowFinished = flowFinished
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CVMakerCertificatesView {
    func setup(certificates: [Certificate]?) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let certificates = certificates ?? []
        makeUI(certificates: certificates)
    }
}

// MARK: Private
private extension CVMakerCertificatesView {
    func makeUI(certificates: [Certificate]) {
        let view: UIView
        if certificates.isEmpty {
            view = createView(certificates: certificates)
        } else {
            view = listView(certificates: certificates)
        }
        
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: leadingAnchor),
            view.trailingAnchor.constraint(equalTo: trailingAnchor),
            view.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            view.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        layoutIfNeeded()
    }
    
    func createView(certificates: [Certificate]) -> CVMakerCertificatesCreateView {
        var result = certificates
        
        return CVMakerCertificatesCreateView(finish: { [weak self] certificate in
            guard let self else { return }
            
            result.append(certificate)
            self.bind(result)
            
            let singleEntityView = CVMakerSingleEntityView(
                title: "CVMaker.Certificates.SE.Title".localized,
                text: "CVMaker.Certificates.SE.SubTitle".localized,
                noAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        singleEntityView.removeFromSuperview()
                        
                        self?.setup(certificates: result)
                        
                        self?.flowFinished()
                    })
                },
                yesAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        guard let self else { return }
                        
                        singleEntityView.removeFromSuperview()
                        
                        self.setup(certificates: result)
                        
                        let fields = CVMCCreateFieldsView { [weak self] certificate  in
                            result.append(certificate)
                            self?.bind(result)
                            
                            self?.setup(certificates: result)
                        }
                        fields.backgroundColor = UIColor.clear
                        fields.translatesAutoresizingMaskIntoConstraints = false
                        
                        let vc = WrapperController.make(wrappedView: fields)
                        self.vc?.present(vc, animated: true)
                    })
                }
            )
            singleEntityView.frame.size = self.bounds.size
            singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
            singleEntityView.backgroundColor = Appearance.main100
            addSubview(singleEntityView)
            
            UIView.animate(withDuration: 0.3, animations: {
                singleEntityView.frame.origin = CGPoint.zero
            })
        }, skip: { [weak self] in
            self?.flowFinished()
        })
    }
    
    func listView(certificates: [Certificate]) -> UIView {
        var result = certificates
        
        let list = CVMakerCertificatesListView(didDelete: { [weak self] listView, certificate in
            result.removeAll(where: { $0.id == certificate.id })
            self?.bind(result)
            
            if result.isEmpty {
                self?.setup(certificates: result)
            } else {
                listView.setup(certificates: result)
            }
        }, didAddMore: { [weak self] listView in
            let fields = CVMCCreateFieldsView { [weak self] certificate  in
                result.append(certificate)
                self?.bind(result)
                
                listView.setup(certificates: result)
            }
            fields.backgroundColor = UIColor.clear
            fields.translatesAutoresizingMaskIntoConstraints = false
            
            let vc = WrapperController.make(wrappedView: fields)
            self?.vc?.present(vc, animated: true)
        }, didContinue: { [weak self] in
            self?.flowFinished()
        })
        
        list.setup(certificates: result)
        
        return list
    }
}
