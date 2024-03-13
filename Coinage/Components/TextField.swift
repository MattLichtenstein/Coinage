//
//  TextField.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/13/24.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 10
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        leftView = padding
        rightView = padding
        leftViewMode = .always
        rightViewMode = .always
    }
    
}
