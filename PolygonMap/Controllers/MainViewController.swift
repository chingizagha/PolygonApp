//
//  ViewController.swift
//  PolygonMap
//
//  Created by Chingiz on 30.03.24.
//

import UIKit
import MapKit

class MainViewController: UIViewController, MKMapViewDelegate {
    
    private var places: [Polygon] = []
    
    private var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.9)
        //button.tintColor = .systemGray
        let plusSign = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
        button.setImage(plusSign, for: .normal)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        
        
        return button
    }()
    
//    private lazy var listButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = .secondarySystemBackground.withAlphaComponent(0.9)
//        //button.tintColor = .systemGray
//        let plusSign = UIImage(systemName: "list.bullet", withConfiguration: UIImage.SymbolConfiguration(pointSize: 20, weight: .bold))
//        button.setImage(plusSign, for: .normal)
//        button.layer.cornerRadius = 8
//        button.clipsToBounds = true
//        
//        
//        return button
//    }()
    
    var drawingMode = false
    var currentPolygonPoints: [CLLocationCoordinate2D] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        view.backgroundColor = .systemBackground
        
        editButton.addTarget(self, action: #selector(toggleDrawingMode), for: .touchUpInside)
//        listButton.addTarget(self, action: #selector(goToListVC), for: .touchUpInside)
        
        // Add gesture recognizer for drawing polygons
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        mapView.addGestureRecognizer(gestureRecognizer)
        
        layoutUI()
        addNewCompass()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name("remove"), object: nil, queue: nil) { _ in
            self.updateUI()
        }
    }
    
    private func addNewCompass() {
        mapView.showsCompass = false
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        mapView.addSubview(compass)
        compass.translatesAutoresizingMaskIntoConstraints = false
        compass.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -10).isActive = true
        compass.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 250).isActive = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUI()
    }
    
    private func updateUI(){
        mapView.removeAllOverlays()
        mapView.removeAllAnnotations()
        places.removeAll()
        DatabaseManager.retrievePolygons { [weak self] result in
            switch result {
            case .success(let models):
                guard let self else {return}
                self.places = models
                for model in models {
                    let annotation = MKPointAnnotation()
                    annotation.title = model.title
                    annotation.coordinate = String.fromStringAnnotation(model.annotationCoordinate)
                    self.mapView.addOverlay(String.fromStringMKPolygon(coordinatesString: model.polygonCoordinate))
                    self.mapView.addAnnotation(annotation)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    @objc func handlePan(_ gestureRecognizer: UIPanGestureRecognizer) {
        if !drawingMode {
            return
        }
        
        let location = gestureRecognizer.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)
        
        if gestureRecognizer.state == .began {
            
            currentPolygonPoints.removeAll()
            currentPolygonPoints.append(coordinate)
        } else if gestureRecognizer.state == .changed {
            
            currentPolygonPoints.append(coordinate)
        } else if gestureRecognizer.state == .ended {
            let polygon = MKPolygon(coordinates: currentPolygonPoints, count: currentPolygonPoints.count)
            
            
            showAlert { text in
                if let text = text, !self.places.contains(where: {$0.title.contains(text)}), !text.isEmpty {
                    self.mapView.addOverlay(polygon)
                    
                    // Calculate centroid of the polygon
                    let centroid = self.calculateCentroid(for: self.currentPolygonPoints)
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = centroid
                    annotation.title = text
                    self.mapView.addAnnotation(annotation)
                    let model = Polygon(title: text, polygonCoordinate: polygon.toString(), annotationCoordinate: annotation.coordinate.toString(), images: [])
                    DatabaseManager.updateWith(model: model, actionType: .add) { error in
                        guard error != nil else {
                            self.places.append(model)
                            return
                        }
                        // Error
                    }
                } else {
                    self.presentAlert(title: "Something went wrong.", message: "Check title please.", buttonTitle: "Ok")
                    
                }
            }
            
        }
    }
    
    func calculateCentroid(for points: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        var minX = points[0].longitude
        var maxX = points[0].longitude
        var minY = points[0].latitude
        var maxY = points[0].latitude
        
        
        for point in points {
            minX = min(minX, point.longitude)
            maxX = max(maxX, point.longitude)
            minY = min(minY, point.latitude)
            maxY = max(maxY, point.latitude)
        }
        
        
        let centerX = (minX + maxX) / 2
        let centerY = (minY + maxY) / 2
        
        return CLLocationCoordinate2D(latitude: centerY, longitude: centerX)
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polygon = overlay as? MKPolygon {
            let renderer = MKPolygonRenderer(polygon: polygon)
            let color = UIColor.random()
            renderer.fillColor = color.withAlphaComponent(0.2) // Transparent blue color
            renderer.strokeColor = color
            renderer.lineWidth = 0.5
            return renderer
        }
        return MKOverlayRenderer()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
            pinView.tintColor = .red
            pinView.animatesWhenAdded = true
            pinView.canShowCallout = true
            return pinView
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? MKPointAnnotation {
            let vc = DetailViewController(titleName: annotation.title ?? "")
            
//            if places.contains(where: { $0.title == annotation.title }) {
//                
//            }
            vc.modalPresentationStyle = .pageSheet
            if let sheet = vc.sheetPresentationController {
                sheet.prefersGrabberVisible = true
                sheet.detents = [.medium(), .large()]
                present(vc, animated: true)
            }
        }
    }
    
    private func showAlert(completion: @escaping (String?) -> Void) {
        
        let alertController = UIAlertController(title: "Enter Text", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter text here"
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            // cancel
            completion(nil)
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let textField = alertController.textFields?.first, let text = textField.text else {
                completion(nil)
                return
            }
            completion(text)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func toggleDrawingMode() {
        drawingMode = !drawingMode
        
        let pencilSign = UIImage(systemName: "pencil", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .bold))
        let stopSign = UIImage(systemName: "stop.fill", withConfiguration: UIImage.SymbolConfiguration(pointSize: 23, weight: .bold))
        editButton.setImage(drawingMode ? stopSign : pencilSign, for: .normal)
        mapView.isScrollEnabled = !drawingMode
        
    }
    
    @objc
    private func goToListVC() {
        
        let nav = ListViewController()
        navigationController?.pushViewController(nav, animated: true)
        
    }
    
    private func layoutUI(){
        let buttonHeight: CGFloat = 40
        view.addSubviews(mapView, editButton)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            editButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 180),
            editButton.widthAnchor.constraint(equalToConstant: buttonHeight),
            editButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
//            listButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
//            listButton.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 225),
//            listButton.widthAnchor.constraint(equalToConstant: buttonHeight),
//            listButton.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
}

//#Preview{
//    MainViewController()
//}




