//
//  String+Extensions.swift
//  Locations App
//
//  Created by Tabita Marusca on 29/10/2020.
//  Copyright © 2020 Tabita Marusca. All rights reserved.
//

import UIKit

extension String {
    var toImage: UIImage? {
        guard let imageData = Data.init(base64Encoded: self, options: .init(rawValue: 0)) else { return nil }
        return UIImage(data: imageData)
    }
    
    var date: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
}
