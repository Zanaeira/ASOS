//
//  RecentlyViewedBackgroundDecorationView.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

public final class RecentlyViewedBackgroundDecorationView: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public static let sectionBackgroundDecorationElementKind = "section-background-element-kind"
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray.withAlphaComponent(0.2)
    }
    
}
