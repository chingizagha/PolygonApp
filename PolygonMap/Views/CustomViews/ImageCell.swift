//
//  ImageCell.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    static let identifier = "ImageCell"
    
    private let imageView = ImageView(frame: .zero)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
        imageView.contentMode = .scaleAspectFill
    }
    
    public func configure(image: UIImage) {
        imageView.image = image
    }
    
}
