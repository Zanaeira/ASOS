//
//  UILabel+Ext.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

extension UILabel {
    
    convenience init(font: UIFont, textAlignment: NSTextAlignment = .center, numberOfLines: Int = 0, adjustsFontSizeToFitWidth: Bool = true) {
        self.init(frame: .zero)
        
        self.font = font
        self.textAlignment = textAlignment
        adjustsFontForContentSizeCategory = true
        if #available(iOS 15, *) {
            maximumContentSizeCategory = .large
        } else {
            let fontDescriptor = self.font.fontDescriptor
            self.font = UIFont(descriptor: fontDescriptor, size: min(fontDescriptor.pointSize, 30))
        }
        self.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
        self.numberOfLines = numberOfLines
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
