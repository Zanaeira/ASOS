//
//  RecentlyViewedCellBackgroundView.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

public final class RecentlyViewedCellBackgroundView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundAndShadow()
    }
    
    private func setupBackgroundAndShadow() {
        backgroundColor = .white
        layer.shadowColor = UIColor.systemGray.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 1
    }
    
}
