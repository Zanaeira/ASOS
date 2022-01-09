//
//  UIFont+Ext.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

public extension UIFont {
    
    func bold() -> UIFont {
        guard let fontDescriptor = fontDescriptor.withSymbolicTraits(.traitBold) else {
            return self
        }
        
        return UIFont(descriptor: fontDescriptor, size: 0)
    }
    
}
