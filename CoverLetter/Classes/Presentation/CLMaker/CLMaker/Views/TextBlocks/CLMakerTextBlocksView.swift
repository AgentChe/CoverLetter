//
//  CLMakerTextBlocksView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit
import RxSwift

final class CLMakerTextBlocksView: CLMakerFlowView {
    lazy var tableView = makeTableView()
    lazy var continueButton = makeContinueButton()
    lazy var preloader = makePreloader()
    
    private lazy var activity = RxActivityIndicator()
    
    private lazy var disposeBag = DisposeBag()
    
    private lazy var resumeManager = ResumeManager()
    
    private let finished: ([CLTextBlock]) -> Void
    
    init(finished: @escaping ([CLTextBlock]) -> Void) {
        self.finished = finished
        
        super.init(frame: .zero)
        
        makeConstraints()
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerTextBlocksView {
    func analyze(analyzeData: CLMakerAnalyzeData) {
        let qa: [[String: String]] = {
            var result = [[String: String]]()
            
            func add(q: String, a: String) {
                let qa = [
                    "question": q,
                    "answer": a
                ]
                result.append(qa)
            }
            
            if let companyName = analyzeData.company?.name, !companyName.isEmpty {
                add(q: "What's the company?", a: companyName)
            }
            
            if let companyAddress = analyzeData.company?.address, !companyAddress.isEmpty {
                add(q: "What is the company address?", a: companyAddress)
            }
            
            if let hiringManager = analyzeData.hiringManager {
                let answer = 
                    [
                        hiringManager.firstName,
                        hiringManager.lastName,
                        hiringManager.phoneNumber,
                        hiringManager.email
                    ]
                    .compactMap { $0 }
                    .filter { !$0.isEmpty }
                    .joined(separator: ", ")
                add(q: "Who is the hiring manager?", a: answer)
            }
            
            if let gender = analyzeData.hiringManager?.gender {
                let localized: String = {
                    switch gender {
                    case .male:
                        return "Male"
                    case .female:
                        return "Female"
                    }
                }()
                add(q: "Is your hiring manager male or female?", a: localized)
            }
            
            if let position = analyzeData.vacancy?.position, !position.isEmpty {
                add(q: "What's the position you're applying for?", a: position)
            }
            
            if let resource = analyzeData.vacancy?.resource, !resource.isEmpty {
                add(q: "How do you know about the job?", a: resource)
            }
            
            return result
        }()
        
        let resumeStyle: String? = {
            guard let toneOfVoice = analyzeData.toneOfVoice else { return nil }
            
            return 
                [
                    toneOfVoice.friendly ? "Friendly" : nil,
                    toneOfVoice.formal ? "Formal" : nil,
                    toneOfVoice.funny ? "Funny" : nil
                ]
                .compactMap { $0 }
                .joined(separator: "/")
        }()
        
        resumeManager
            .analyzeCL(qa: qa, resumeStyle: resumeStyle)
            .trackActivity(activity)
            .asDriver(onErrorJustReturn: [])
            .drive(Binder(self) { base, textBlocks in
                let elements: [CLMTBTableElement] = [.header] + textBlocks.map { textBlock -> CLMTBTableElement in
                    let element = CLMTBTableTextBlockElement(textBlock: textBlock)
                    return CLMTBTableElement.textBlock(element)
                }
                base.tableView.setup(elements: elements)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: Private
private extension CLMakerTextBlocksView {
    func initialize() {
        rx.keyboardHeight
            .bind(to: Binder(tableView) { base, keyboardHeight in
                base.contentInset.bottom = keyboardHeight + 24.scale
            })
            .disposed(by: disposeBag)
        
        activity
            .drive(Binder(self) { base, activity in
                activity ? base.preloader.startAnimating() : base.preloader.stopAnimating()
                
                base.tableView.isHidden = activity
                base.continueButton.isHidden = activity
            })
            .disposed(by: disposeBag)
        
        let tapGesture = UITapGestureRecognizer()
        tableView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind(to: Binder(self) { base, event in
                base.endEditing(true)
            })
            .disposed(by: disposeBag)
    }
    
    @objc
    func continueTapped() {
        let textBlocks = tableView.elements
            .compactMap { element -> CLTextBlock? in
                guard case let .textBlock(textBlockElement) = element else { return nil }
                
                return CLTextBlock(
                    title: textBlockElement.name,
                    text: textBlockElement.content
                )
            }
        finished(textBlocks)
    }
}

// MARK: Make constraints
private extension CLMakerTextBlocksView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: continueButton.topAnchor, constant: -2.scale)
        ])
        
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.scale),
            continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.scale),
            continueButton.heightAnchor.constraint(equalToConstant: 58.scale),
            continueButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: ScreenSize.isIphoneXFamily ? -8.scale : -16.scale)
        ])
        
        NSLayoutConstraint.activate([
            preloader.widthAnchor.constraint(equalToConstant: 45.scale),
            preloader.heightAnchor.constraint(equalToConstant: 45.scale),
            preloader.centerXAnchor.constraint(equalTo: centerXAnchor),
            preloader.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerTextBlocksView {
    func makeTableView() -> CLMTBTableView {
        let view = CLMTBTableView()
        view.separatorStyle = .none
        view.contentInset = UIEdgeInsets(t: 52.scale, b: 24.scale)
        view.setContentOffset(CGPoint(x: 0, y: -52.scale), animated: false)
        view.showsVerticalScrollIndicator = false
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeContinueButton() -> UIButton {
        let attrs = TextAttributes()
            .textColor(Appearance.mono100)
            .font(Fonts.Inter.semibold(size: 17.scale))
        
        let view = UIButton()
        view.setAttributedTitle("Continue".localized.attributed(with: attrs), for: .normal)
        view.layer.cornerRadius = 20.scale
        view.backgroundColor = Appearance.custom_ed6f00
        view.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makePreloader() -> UIActivityIndicatorView {
        let view = UIActivityIndicatorView()
        view.color = Appearance.custom_ed6f00
        view.style = .large
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
}
