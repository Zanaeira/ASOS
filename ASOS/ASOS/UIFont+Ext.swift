//
//  UIFont+Ext.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

extension UIFont {
    
    static func preferredFont(forTextStyle style: TextStyle, weight: Weight) -> UIFont {
        let fontMetrics = UIFontMetrics(forTextStyle: style)
        let fontDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style)
        let font = UIFont.systemFont(ofSize: fontDescriptor.pointSize, weight: weight)
        
        return fontMetrics.scaledFont(for: font)
    }
    
}
