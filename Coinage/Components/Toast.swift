//
//  Toast.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 4/19/24.
//

import UIKit

class Toast: UIView {
    
    private lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.tintColor = .label
        return iconView
    }()
    
    private lazy var label: Label = {
        let label = Label("", type: .paragraph)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 12

        layer.cornerRadius = 32
    }
    
    private func setupUI() {
        backgroundColor = .tertiarySystemBackground
        
        let container = UIStackView()
        addSubview(container)
        container.addArrangedSubview(iconView)
        container.addArrangedSubview(label)
        container.axis = .horizontal
        container.spacing = 8
        
        container.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            container.centerXAnchor.constraint(equalTo: centerXAnchor),
            container.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func configure(text: String, symbolName: String? = nil) {
        label.text = text
        if let symbolName {
            iconView.image = UIImage(systemName: symbolName)
        }
    }
    
}
