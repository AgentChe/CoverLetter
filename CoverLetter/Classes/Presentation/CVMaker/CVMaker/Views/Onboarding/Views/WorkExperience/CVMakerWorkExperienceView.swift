//
//  CVMakerWorkExperienceView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 24.05.2024.
//

import UIKit

final class CVMakerWorkExperienceView: UIView {
    private weak var vc: UIViewController?
    private let bind: (([WorkExperience]) -> Void)
    private let flowFinished: (() -> Void)
    
    init(
        vc: UIViewController?,
        bind: @escaping (([WorkExperience]) -> Void),
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
extension CVMakerWorkExperienceView {
    func setup(workExperiences: [WorkExperience]?) {
        subviews.forEach { $0.removeFromSuperview() }
        
        let workExperiences = workExperiences ?? []
        makeUI(workExperiences: workExperiences)
    }
}

// MARK: Private
private extension CVMakerWorkExperienceView {
    func makeUI(workExperiences: [WorkExperience]) {
        let view: UIView
        if workExperiences.isEmpty {
            view = createView(workExperiences: workExperiences)
        } else {
            view = listView(workExperiences: workExperiences)
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
    
    func createView(workExperiences: [WorkExperience]) -> CVMakerWorkExperienceCreateView {
        var result = workExperiences
        
        return CVMakerWorkExperienceCreateView(finish: { [weak self] workExperience in
            guard let self else { return }
            
            result.append(workExperience)
            self.bind(result)
            
            let singleEntityView = CVMakerSingleEntityView(
                title: "CVMaker.WorkExperience.SE.Title".localized,
                text: "CVMaker.WorkExperience.SE.Text".localized,
                noAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        singleEntityView.removeFromSuperview()
                        
                        self?.setup(workExperiences: result)
                        
                        self?.flowFinished()
                    })
                },
                yesAction: { singleEntityView in
                    UIView.animate(withDuration: 0.3, animations: {
                        singleEntityView.frame.origin = CGPoint(x: 0, y: self.bounds.height)
                    }, completion: { [weak self] complete in
                        guard let self else { return }
                        
                        singleEntityView.removeFromSuperview()
                        
                        self.setup(workExperiences: result)
                        
                        let fields = CVMWECreateFieldsView { [weak self] workExperience  in
                            result.append(workExperience)
                            self?.bind(result)
                            
                            self?.setup(workExperiences: result)
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
    
    func listView(workExperiences: [WorkExperience]) -> UIView {
        var result = workExperiences
        
        let list =  CVMakerWorkExperienceListView(didDelete: { [weak self] listView, workExperience in
            result.removeAll(where: { $0.id == workExperience.id })
            self?.bind(result)
            
            if result.isEmpty {
                self?.setup(workExperiences: result)
            } else {
                listView.setup(workExperiences: result)
            }
        }, didAddMore: { [weak self] listView in
            let fields = CVMWECreateFieldsView { [weak self] workExperience  in
                result.append(workExperience)
                self?.bind(result)
                
                listView.setup(workExperiences: result)
            }
            fields.backgroundColor = UIColor.clear
            fields.translatesAutoresizingMaskIntoConstraints = false
            
            let vc = WrapperController.make(wrappedView: fields)
            self?.vc?.present(vc, animated: true)
        }, didContinue: { [weak self] in
            self?.flowFinished()
        })
        
        list.setup(workExperiences: result)
        
        return list
    }
}
