//
//  PickerButton.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/13/24.
//

import UIKit

class PickerButton: UIButton {
    
    private var options = [String]()
    
    init(options: [String]) {
        self.options = options
        
        super.init(frame: .zero)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        configuration = .plain()
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: 8.0, bottom: 0.0, trailing: 0.0)
        setTitleColor(.label, for: .normal)
        tintColor = .gray
        backgroundColor = .secondarySystemBackground
        contentHorizontalAlignment = .leading
        layer.cornerRadius = 10
        
        //Setup actions
        var actions = [UIAction]()
        for option in options {
            let action = UIAction(title: option) { action in
                self.setTitle(action.title, for: .normal)
            }
            actions.append(action)
        }
        
        let menu = UIMenu(children: actions)
        self.menu = menu
        showsMenuAsPrimaryAction = true
        
        setTitle(actions[0].title, for: .normal)
        
    }
    
}
