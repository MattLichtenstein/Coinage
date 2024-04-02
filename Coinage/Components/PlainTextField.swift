//
//  PlainTextField.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/29/24.
//

import UIKit

class PlainTextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        
    }
}
