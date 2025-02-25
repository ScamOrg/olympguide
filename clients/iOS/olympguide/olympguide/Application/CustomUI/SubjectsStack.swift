//
//  SubjectsStack.swift
//  olympguide
//
//  Created by Tom Tim on 25.02.2025.
//

import UIKit

final class SubjectsStack: UIStackView {
    init() {
        super.init(frame: .zero)
        axis = .horizontal
        spacing = 10
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(requiredSubjects: [String], optionalSubjects: [String]){
        arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for subject in requiredSubjects {
            if let subject = Subject(rawValue: subject) {
                let subjectsLabel = SubjectLabel(
                    text: subject.abbreviation,
                    side: .Single
                )
                addArrangedSubview(subjectsLabel)
            }
        }
        
        if !optionalSubjects.isEmpty {
            let optionalSubjectsStack = OptionalSubjectsStack(subjects: optionalSubjects)
            addArrangedSubview(optionalSubjectsStack)
        }
    }
}



final class OptionalSubjectsStack: UIStackView {
    let subjects: [String]
    
    init(subjects: [String]){
        self.subjects = subjects
        super.init(frame: .zero)
        configureUI()
    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        spacing = 2
        axis = .horizontal
        
        for (index, subject) in subjects.enumerated() {
            if let subject = Subject(rawValue: subject) {
                if index == 0 {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Left
                    )
                    addArrangedSubview(subjectsLabel)
                } else if index == subjects.count - 1 {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Right
                    )
                    addArrangedSubview(subjectsLabel)
                } else {
                    let subjectsLabel = SubjectLabel(
                        text: subject.abbreviation,
                        side: .Center
                    )
                    addArrangedSubview(subjectsLabel)
                }
            }
        }
    }
}

enum SubjectSide {
    case Single
    case Center
    case Right
    case Left
}

final class SubjectLabel: UILabel {
    
    init(text: String, side: SubjectSide) {
        super.init(frame: .zero)
        
        self.text = text
        self.textAlignment = .center
        self.font = UIFont(name: "MontserratAlternates-Regular", size: 14)
        self.textColor = UIColor.black.withAlphaComponent(0.53)
        self.layer.borderColor = UIColor.black.withAlphaComponent(0.53).cgColor
        self.layer.borderWidth = 1
        self.layer.masksToBounds = true
        
        self.frame.size = CGSize(width: 34, height: 34)
        
        switch side {
        case .Single:
            self.layer.cornerRadius = 5
        case .Center:
            self.layer.cornerRadius = 0
        case .Right:
            self.layer.cornerRadius = 5
            self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
        case .Left:
            self.layer.cornerRadius = 5
            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 34, height: 34)
    }
}


enum Subject {
    case Russian
    case English
    case Math
    case Physics
    case Chemistry
    case History
    case Biology
    case SocialStudies
    case Informatics
    case Geographie
    case Literature
    
    init?(rawValue: String) {
        switch rawValue {
        case "Русский язык":
            self = .Russian
        case "Иностранный язык":
            self = .English
        case "Математика":
            self = .Math
        case "Физика":
            self = .Physics
        case "Химия":
            self = .Chemistry
        case "История":
            self = .History
        case "Биология":
            self = .Biology
        case "Обществознание":
            self = .SocialStudies
        case "Информатика":
            self = .Informatics
        case "География":
            self = .Geographie
        case "Литература":
            self = .Literature
        default:
            return nil
        }
    }
    
    var abbreviation: String {
        switch self {
        case .Russian: return "РЯ"
        case .English: return "ИЯ"
        case .Math: return "М"
        case .Physics: return "Ф"
        case .Chemistry: return "Х"
        case .History: return "И"
        case .Biology: return "Б"
        case .SocialStudies: return "О"
        case .Informatics: return "ИКТ"
        case .Geographie: return "Г"
        case .Literature: return "Л"
        }
    }
}
