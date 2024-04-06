//
//  EmptyStateView.swift
//  PolygonMap
//
//  Created by Chingiz on 01.04.24.
//

import UIKit

class EmptyStateView: UIView {
    
    let messageLabel    = TitleLabel(textAlignment: .center, fontSize: 18)
    let logoImageView   = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(message: String) {
        self.init(frame: .zero)
        messageLabel.text = message
    }
    
    private func configure() {
        addSubviews(messageLabel, logoImageView)
        
        messageLabel.numberOfLines  = 2
        messageLabel.textColor      = .secondaryLabel
        
        logoImageView.image = UIImage(systemName: "exclamationmark.circle")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.tintColor = .secondaryLabel
        
        NSLayoutConstraint.activate([
            
            messageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            messageLabel.heightAnchor.constraint(equalToConstant: 100),
            
            
            logoImageView.topAnchor.constraint(equalTo: messageLabel.bottomAnchor),
            logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            logoImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            logoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.2),
            //logoImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 170),
        ])
    }
}
