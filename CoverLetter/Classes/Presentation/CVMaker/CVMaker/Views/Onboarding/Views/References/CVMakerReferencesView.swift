//
//  CVMakerReferencesView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 26.08.2024.
//

import UIKit

final class CVMakerReferencesView: UIView {
    private weak var vc: UIViewController?
    private let bind: (([Reference]) -> Void)
    private let flowFinished: (() -> Void)
    
    init(
        vc: UIViewController?,
        bind: @escaping (([Reference]) -> Void),
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
extension CVMakerReferencesView {
    func setup(references: [Reference]?) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let references = references ?? []
        makeUI(references: references)
    }
}

// MARK: Private
private extension CVMakerReferencesView {
    func makeUI(references: [Reference]) {
        let view: UIView
        if references.isEmpty {
            view = createView(references: references)
        } else {
            view = listView(references: references)
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
    
    func createView(references: [Reference]) -> CVMakerReferencesCreateView {
        var result = references
        
        return CVMakerReferencesCreateView(finish: { [weak self] reference in
            guard let self else { return }
            
            result.append(reference)
            self.bind(result)
            
            let singleEntityView = CVMakerSingleEntityView(
                title: "CVMaker.References.SE.Title".localized,
                text: "CVMaker.References.SE.SubTitle".localized,
                noAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        singleEntityView.removeFromSuperview()
                        
                        self?.setup(references: result)
                        
                        self?.flowFinished()
                    })
                },
                yesAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        guard let self else { return }
                        
                        singleEntityView.removeFromSuperview()
                        
                        self.setup(references: result)
                        
                        let fields = CVMRCreateFieldsView { [weak self] reference  in
                            result.append(reference)
                            self?.bind(result)
                            
                            self?.setup(references: result)
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
    
    func listView(references: [Reference]) -> UIView {
        var result = references
        
        let list = CVMakerReferencesListView(didDelete: { [weak self] listView, reference in
            result.removeAll(where: { $0.id == reference.id })
            self?.bind(result)
            
            if result.isEmpty {
                self?.setup(references: result)
            } else {
                listView.setup(references: result)
            }
        }, didAddMore: { [weak self] listView in
            let fields = CVMRCreateFieldsView { [weak self] reference  in
                result.append(reference)
                self?.bind(result)
                
                listView.setup(references: result)
            }
            fields.backgroundColor = UIColor.clear
            fields.translatesAutoresizingMaskIntoConstraints = false
            
            let vc = WrapperController.make(wrappedView: fields)
            self?.vc?.present(vc, animated: true)
        }, didContinue: { [weak self] in
            self?.flowFinished()
        })
        
        list.setup(references: result)
        
        return list
    }
}
