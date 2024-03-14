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
            setTitle(selectedOption, for: .normal)
        }
    }
    
    init(options: [String] = []) {
        self.options = options
        selectedOption = options.isEmpty ? nil : options[0]
        
        super.init(frame: .zero)

        configure()
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
        setTitle(options[0], for: .normal)
    }
    
    private func configure() {
        configuration = .plain()
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0.0, leading: -4.0, bottom: 0.0, trailing: 0.0)
        setTitleColor(.label, for: .normal)
        tintColor = .gray
        backgroundColor = .secondarySystemBackground
        contentHorizontalAlignment = .leading
        layer.cornerRadius = 10
        tintColor = .gray
        showsMenuAsPrimaryAction = true

        setTitle(selectedOption, for: .normal)

        let config = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName:  "arrow.up.and.down", withConfiguration: config)
        let highlightImage = image?.withTintColor(.systemGray2, renderingMode: .alwaysOriginal)
        setImage(image, for: .normal)
        setImage(highlightImage, for: .highlighted)
        
        setupMenu()
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
    }
}
