//
//  ImageViewController.swift
//  PolygonMap
//
//  Created by Chingiz on 03.04.24.
//

import UIKit

class ImageViewController: UIViewController {
    
    private let titleLabel = TitleLabel(textAlignment: .left, fontSize: 22)
    private let imageView = ImageView(frame: .zero)
    
    private var dismissButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBackground
        button.tintColor = .systemGray
        let plusSign = UIImage(systemName: "x.circle.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = button.frame.width / 2
        button.clipsToBounds = true
        return button
    }()
    
    init(title: String, image: UIImage){
        self.titleLabel.text = title
        self.imageView.image = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        dismissButton.addTarget(self, action: #selector(goBackDetailScreen), for: .touchUpInside)
        view.backgroundColor = .systemBackground
        layoutUI()
    }
    
    @objc
    private func goBackDetailScreen(){
        dismiss(animated: true)
    }
    
    private func layoutUI(){
        
        view.addSubviews(titleLabel, imageView, dismissButton)
        
        imageView.contentMode = .scaleAspectFit
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.widthAnchor.constraint(equalToConstant: 40),
            
            dismissButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            dismissButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            dismissButton.heightAnchor.constraint(equalToConstant: 40),
            dismissButton.widthAnchor.constraint(equalToConstant: 40),
            
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.height/1.2),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width/1.2),
        ])
    }
    
    
    



}
