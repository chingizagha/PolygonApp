//
//  ImageView.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit

class ImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func configure() {
        layer.cornerRadius = 8
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
}
