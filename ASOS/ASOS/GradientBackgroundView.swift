//
//  GradientBackgroundView.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class GradientBackgroundView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let backgroundGradient = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundGradient()
    }
    
    private func setupBackgroundGradient() {
        backgroundGradient.type = .axial
        backgroundGradient.colors = [UIColor.systemTeal.cgColor, UIColor.systemIndigo.cgColor]
        backgroundGradient.startPoint = .init(x: 1.0, y: 0.5)
        backgroundGradient.endPoint = .init(x: 0.0, y: 0.5)
        
        self.layer.addSublayer(backgroundGradient)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradient.frame = bounds
    }
    
}
