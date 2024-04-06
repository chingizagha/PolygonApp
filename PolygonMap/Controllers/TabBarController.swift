//
//  TabBarController.swift
//  PolygonMap
//
//  Created by Chingiz on 31.03.24.
//

import UIKit

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .systemBackground.withAlphaComponent(0.8)
        
        self.tabBar.standardAppearance = tabBarAppearance
        self.tabBar.scrollEdgeAppearance = tabBarAppearance
        
        viewControllers = [createMainNC(), createListNC()]
        
    }
    
    func createMainNC() -> UINavigationController {
        let mainVC = MainViewController()
        mainVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(systemName: "map"), tag: 0)
        
        return UINavigationController(rootViewController: mainVC)
    }
    
    func createListNC() -> UINavigationController {
        let listVC = ListViewController()
        listVC.tabBarItem = UITabBarItem(title: "List", image: UIImage(systemName: "list.triangle"), tag: 1)
        
        return UINavigationController(rootViewController: listVC)
    }
    
}
