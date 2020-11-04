//
//  UIViewController+Extensions.swift
//  Locations App
//
//  Created by Tabita Marusca on 29/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String?, action: ((UIAlertAction?) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
        present(alert, animated: true)
    }
}
