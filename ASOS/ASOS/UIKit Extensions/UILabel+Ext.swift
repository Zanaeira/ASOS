//
//  UILabel+Ext.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

extension UILabel {
    
    convenience init(font: UIFont) {
        self.init(frame: .zero)
        
        self.font = font
        textAlignment = .center
        adjustsFontForContentSizeCategory = true
        if #available(iOS 15, *) {
            maximumContentSizeCategory = .large
        } else {
            let fontDescriptor = self.font.fontDescriptor
            self.font = UIFont(descriptor: fontDescriptor, size: min(fontDescriptor.pointSize, 30))
        }
        adjustsFontSizeToFitWidth = true
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
