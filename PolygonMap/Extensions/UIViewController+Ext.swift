//
//  UIViewController+Ext.swift
//  PolygonMap
//
//  Created by Chingiz on 01.04.24.
//

import UIKit


extension UIViewController{
    func showEmptyStateView(with message: String, in view: UIView) {
        let emptyStateView = EmptyStateView(message: message)
        emptyStateView.frame = view.bounds
        view.addSubview(emptyStateView)
    }
    
    func presentAlert(title: String, message: String, buttonTitle: String) {
        let alertVC = CustomAlertViewController(alertTitle: title, message: message, buttonTitle: buttonTitle)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        present(alertVC, animated: true)
    }
}
