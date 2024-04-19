//
//  Label.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 4/19/24.
//

import UIKit

enum LabelType {
    case caption
    case paragraph
    case title
}

class Label: UILabel {

    private var type: LabelType
    
    init(type: LabelType) {
        self.type = type

        super.init(frame: .zero)

        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        switch type {
        case .caption:
            font = UIFont(name: Constants.FontFamily.cmRegularRounded, size: CGFloat(Constants.FontSize.caption))
        case .paragraph:
            font = UIFont(name: Constants.FontFamily.cmMediumRounded, size: CGFloat(Constants.FontSize.paragraph))
        case .title:
            font = UIFont(name: Constants.FontFamily.cmBold, size: CGFloat(Constants.FontSize.title))
        }
    }

}
