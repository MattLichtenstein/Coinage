//
//  PickerButton.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 3/13/24.
//

import UIKit

class PickerButton: UIButton {
    
    private var options: [String] {
        didSet {
            setupMenu()
        }
    }
    
    var selectedOption: String? {
        didSet {
            configuration?.attributedTitle = AttributedString(selectedOption ?? "--", attributes: AttributeContainer([NSAttributedString.Key.font: UIFont(name: Constants.cmRegular, size: 16)!]))        }
    }
    
    init(options: [String] = []) {
        self.options = options
        selectedOption = options.isEmpty ? nil : options[0]
        
        super.init(frame: .zero)

        configure()
        setupMenu()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        // Ensure the trailing image is pinned to the trailing edge
        if let imageView = imageView {
            imageView.frame.origin.x = bounds.width - imageView.frame.width - 12
        }
    }
    
    func setOptions(_ options: [String]) {
        if options.isEmpty { return }
        self.options = options
    }
    
    private func configure() {
        configuration = .gray()
        configuration?.baseBackgroundColor = .secondarySystemBackground
        configuration?.baseForegroundColor = .label
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: -4.0, bottom: 0.0, trailing: 0.0)
        configuration?.background.cornerRadius = 10
        contentHorizontalAlignment = .leading
        showsMenuAsPrimaryAction = true
 

        let config = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName:  "chevron.up.chevron.down", withConfiguration: config)
        setImage(image, for: .normal)
    }
    
    private func setupMenu() {
        var actions = [UIAction]()
        for option in options {
            let action = UIAction(title: option) { action in
                self.selectedOption = action.title
            }
            actions.append(action)
        }
        
        let menu = UIMenu(children: actions)
        self.menu = menu
        selectedOption = !options.isEmpty ? options[0] : "--"
    }
}
