//
//  ToastManager.swift
//  Coinage
//
//  Created by Matt Lichtenstein on 4/20/24.
//

import Foundation
import UIKit

final class ToastManager {
    static let shared = ToastManager()
    
    func showToast(text: String, symbolName: String? = nil) {
        guard let window = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow else { return }
        let toast = Toast()
        toast.configure(text: text, symbolName: symbolName)
        
        window.addSubview(toast)
        toast.translatesAutoresizingMaskIntoConstraints = false

        let topAnchor = toast.topAnchor.constraint(equalTo: window.topAnchor, constant: -64)
        topAnchor.isActive = true
        let topAnchor2 = toast.topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor)

        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: window.centerXAnchor),
            toast.heightAnchor.constraint(equalToConstant: 64),
            toast.widthAnchor.constraint(equalTo: window.widthAnchor, multiplier: 0.6),
        ])

        window.layoutIfNeeded()

        UIView.animate(withDuration: 0.2) {
            topAnchor.isActive = false
            topAnchor2.isActive = true
            window.layoutIfNeeded()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                UIView.animate(withDuration: 0.2, animations: {
                    topAnchor2.isActive = false
                    topAnchor.isActive = true
                    window.layoutIfNeeded()
                }) { _ in
                    toast.removeFromSuperview()
                }
            }
        }
    }
}
