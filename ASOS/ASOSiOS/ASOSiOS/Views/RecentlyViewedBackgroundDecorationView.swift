//
//  RecentlyViewedBackgroundDecorationView.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

final class RecentlyViewedBackgroundDecorationView: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray.withAlphaComponent(0.2)
    }
    
}
