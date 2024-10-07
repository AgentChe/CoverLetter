//
//  CVMakerEducationView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 27.05.2024.
//

import UIKit

final class CVMakerEducationView: UIView {
    private weak var vc: UIViewController?
    private let bind: (([Education]) -> Void)
    private let flowFinished: (() -> Void)
    
    init(
        vc: UIViewController?,
        bind: @escaping (([Education]) -> Void),
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
extension CVMakerEducationView {
    func setup(educations: [Education]?) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let educations = educations ?? []
        makeUI(educations: educations)
    }
}

// MARK: Private
private extension CVMakerEducationView {
    func makeUI(educations: [Education]) {
        let view: UIView
        if educations.isEmpty {
            view = createView(educations: educations)
        } else {
            view = listView(educations: educations)
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
    
    func createView(educations: [Education]) -> CVMakerEducationCreateView {
        var result = educations
        
        return CVMakerEducationCreateView(finish: { [weak self] education in
            guard let self else { return }
            
            result.append(education)
            self.bind(result)
            
            let singleEntityView = CVMakerSingleEntityView(
                title: "CVMaker.Education.SE.Title".localized,
                text: "CVMaker.Education.SE.Text".localized,
                noAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        singleEntityView.removeFromSuperview()
                        
                        self?.setup(educations: result)
                        
                        self?.flowFinished()
                    })
                },
                yesAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        guard let self else { return }
                        
                        singleEntityView.removeFromSuperview()
                        
                        self.setup(educations: result)
                        
                        let fields = CVMECreateFieldsView { [weak self] education  in
                            result.append(education)
                            self?.bind(result)
                            
                            self?.setup(educations: result)
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
    
    func listView(educations: [Education]) -> UIView {
        var result = educations
        
        let list =  CVMakerEducationListView(didDelete: { [weak self] listView, education in
            result.removeAll(where: { $0.id == education.id })
            self?.bind(result)
            
            if result.isEmpty {
                self?.setup(educations: result)
            } else {
                listView.setup(educations: result)
            }
        }, didAddMore: { [weak self] listView in
            let fields = CVMECreateFieldsView { [weak self] education  in
                result.append(education)
                self?.bind(result)
                
                listView.setup(educations: result)
            }
            fields.backgroundColor = UIColor.clear
            fields.translatesAutoresizingMaskIntoConstraints = false
            
            let vc = WrapperController.make(wrappedView: fields)
            self?.vc?.present(vc, animated: true)
        }, didContinue: { [weak self] in
            self?.flowFinished()
        })
        
        list.setup(educations: result)
        
        return list
    }
}
