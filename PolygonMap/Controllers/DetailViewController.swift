//
//  DetailViewController.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let titleLabel = TitleLabel(textAlignment: .left, fontSize: 35)
    private let addImageButton = CustomButton(backgroundColor: .systemBlue, title: "Add Images")
    private let removeButton = CustomButton(backgroundColor: .systemRed, title: "Remove")
    
    private var titleName: String!
    private var model: Polygon!
    
    init(titleName: String){
        super.init(nibName: nil, bundle: nil)
        self.titleName = titleName
        self.titleLabel.text = titleName
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private var images: [UIImage]! = [UIImage]() {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 240, height: 300)
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .systemBackground
        view.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identifier)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true

        DatabaseManager.retrieveOnePolygon(title: titleName) { result in
            switch result {
            case .success(let model):
                self.model = model
                guard let dataImages = model.images else {return}
                for dataImage in dataImages {
                    let decoded = try! PropertyListDecoder().decode(Data.self, from: dataImage)
                    let realImage = UIImage(data: decoded)
                    self.images.append(realImage ?? UIImage(systemName: "person")!)
                }
            case .failure(let error):
                print(error)
            }
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.backgroundColor = .systemBackground
        
        
        
        addImageButton.addTarget(self, action: #selector(selectImage), for: .touchUpInside)
        removeButton.addTarget(self, action: #selector(removePolygon), for: .touchUpInside)
        
        layoutUI()
    }
    
    private func layoutUI(){
        view.addSubviews(titleLabel, addImageButton, removeButton, collectionView)
//        guard let images = model.images, !images.isEmpty else {
//            collectionView.isHidden = true
//            return
//        }
        
        NSLayoutConstraint.activate([
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            
            removeButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            removeButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            removeButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            removeButton.heightAnchor.constraint(equalToConstant: 50),
            
            addImageButton.bottomAnchor.constraint(equalTo: removeButton.topAnchor, constant: -20),
            addImageButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            addImageButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            addImageButton.heightAnchor.constraint(equalToConstant: 50),
            
            collectionView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 100),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
    
    @objc private func selectImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
        
    }
    
    @objc private func removePolygon() {
        DatabaseManager.updateWith(model: model, actionType: .remove) { error in
            guard error != nil else {return}
        }
        NotificationCenter.default.post(name: NSNotification.Name("remove"), object: nil)
        dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {return}
        dismiss(animated: true)
        
        images.append(image)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        let encoded = try! PropertyListEncoder().encode(data)
        DatabaseManager.updateWith(model: model, actionType: .remove) { error in
            guard error != nil else {return}
        }
        model.images?.append(encoded)
        DatabaseManager.updateWith(model: model, actionType: .remove) { error in
            guard error != nil else {return}
        }
        DatabaseManager.updateWith(model: model, actionType: .add) { error in
            guard error != nil else {return}
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.identifier, for: indexPath) as? ImageCell else {fatalError()}
        let image = images[indexPath.row]
        cell.configure(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = images[indexPath.row]
        let vc = ImageViewController(title: titleName, image: image)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    
}
