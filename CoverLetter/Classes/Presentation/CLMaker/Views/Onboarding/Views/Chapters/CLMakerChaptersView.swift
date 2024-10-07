//
//  CLMakerChaptersView.swift
//  CVMaker
//
//  Created by Андрей Чернышев on 30.08.2024.
//

import UIKit

final class CLMakerChaptersView: UIView {
    var didSelect: ((CLMakerOnboardingView.Chapter) -> Void)?
    
    lazy var scrollView = makeScrollView()
    lazy var personalInfoButton = makeChapterButton(chapter: .personalInfo)
    lazy var companyInfoButton = makeChapterButton(chapter: .companyInfo)
    lazy var hiringManagerButton = makeChapterButton(chapter: .hiringManager)
    lazy var vacancyButton = makeChapterButton(chapter: .vacancy)
    lazy var toneOnVoiceButton = makeChapterButton(chapter: .toneOnVoice)
    
    private lazy var buttons = [
        personalInfoButton,
        companyInfoButton,
        hiringManagerButton,
        vacancyButton,
        toneOnVoiceButton
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Public
extension CLMakerChaptersView {
    func setup(chapter: CLMakerOnboardingView.Chapter, withCallback: Bool = false) {
        buttons.forEach { $0.marked = $0.chapter == chapter }
        
        if withCallback {
            didSelect?(chapter)
        }
    }
}

// MARK: Private
private extension CLMakerChaptersView {
    @objc
    func tapped(sender: UIButton) {
        guard let chapterButton = sender as? CLMakerChapterButton else {
            return
        }
        
        buttons.forEach { $0.marked = $0.chapter == chapterButton.chapter }
        
        didSelect?(chapterButton.chapter)
    }
}

// MARK: Make constraints
private extension CLMakerChaptersView {
    func makeConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            personalInfoButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16.scale),
            personalInfoButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            personalInfoButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            personalInfoButton.topAnchor.constraint(equalTo: topAnchor),
            personalInfoButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            companyInfoButton.leadingAnchor.constraint(equalTo: personalInfoButton.trailingAnchor, constant: 16.scale),
            companyInfoButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            companyInfoButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            hiringManagerButton.leadingAnchor.constraint(equalTo: companyInfoButton.trailingAnchor, constant: 16.scale),
            hiringManagerButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            hiringManagerButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            vacancyButton.leadingAnchor.constraint(equalTo: hiringManagerButton.trailingAnchor, constant: 16.scale),
            vacancyButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            vacancyButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            toneOnVoiceButton.leadingAnchor.constraint(equalTo: vacancyButton.trailingAnchor, constant: 16.scale),
            toneOnVoiceButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16.scale),
            toneOnVoiceButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            toneOnVoiceButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}

// MARK: Lazy initialization
private extension CLMakerChaptersView {
    func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = UIColor.clear
        view.contentInset = UIEdgeInsets()
        view.setContentOffset(CGPoint.zero, animated: false)
        view.showsHorizontalScrollIndicator = false
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        return view
    }
    
    func makeChapterButton(chapter: CLMakerOnboardingView.Chapter) -> CLMakerChapterButton {
        let view = CLMakerChapterButton(chapter: chapter)
        view.backgroundColor = UIColor.clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(tapped(sender:)), for: .touchUpInside)
        scrollView.addSubview(view)
        return view
    }
}
