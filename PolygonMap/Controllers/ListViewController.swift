//
//  ListViewController.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit

class ListViewController: UIViewController {
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private var polygons: [Polygon]! = [Polygon]() {
        didSet{
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Polygons"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        view.backgroundColor = .systemBackground
        layoutUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DatabaseManager.retrievePolygons { result in
            switch result {
            case .success(let models):
                self.updateUI(with: models)
            case .failure(let error):
                print(error)
            }
        }
    }
    
//    override func updateContentUnavailableConfiguration(using state: UIContentUnavailableConfigurationState) {
//        if polygons.isEmpty {
//            var config = UIContentUnavailableConfiguration.empty()
//            config.image = .init(systemName: "exclamationmark.circle")
//            config.text = "No Polygons"
//            config.secondaryText = "Add a polygon on the list screen"
//            contentUnavailableConfiguration = config
//        } else {
//            contentUnavailableConfiguration = nil
//        }
//    }
    
    func updateUI(with polygons: [Polygon]) {
        if polygons.isEmpty {
            self.showEmptyStateView(with: "No Polygons?\nAdd one on the map screen.", in: self.view)
        } else  {
            self.polygons = polygons
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.bringSubviewToFront(self.tableView)
            }
        }
    }
    
    private func layoutUI(){
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.rowHeight = 80
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        polygons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let polygon = polygons[indexPath.row]
        
        //let areaSize = String.fromStringMKPolygon(coordinatesString: polygon.polygonCoordinate).area

        // Calculate the area size (in square meters) from the bounding map rectangle
        
        
        var content = cell.defaultContentConfiguration()
        content.text = polygon.title
        //content.secondaryText = String("\(areaSize) m2")
        
        cell.contentConfiguration = content
        cell.accessoryType = .disclosureIndicator
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else {return}
        let polygon = polygons[indexPath.row]
        
        DatabaseManager.updateWith(model: polygon, actionType: .remove) { [weak self] error in
            guard let self else {return}
            guard let error else {
                self.polygons.remove(at: indexPath.row)
                updateUI(with: polygons)
                //tableView.deleteRows(at: [indexPath], with: .left)
                return
            }
            DispatchQueue.main.async {
                print(error)
                return
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let polygon = polygons[indexPath.row]
        
        let vc = DetailViewController(titleName: polygon.title)
        //vc.title = annotation.title ?? ""
        //navigationController?.pushViewController(vc, animated: true)
        
        ///
        vc.modalPresentationStyle = .pageSheet
        if let sheet = vc.sheetPresentationController {
            sheet.prefersGrabberVisible = true
            sheet.detents = [.large()]
            present(vc, animated: true)
        }
    }
}
