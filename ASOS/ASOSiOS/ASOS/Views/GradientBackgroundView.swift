//
//  GradientBackgroundView.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

public final class GradientBackgroundView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let backgroundGradient = CAGradientLayer()
    
    private let rightColor: UIColor
    private let leftColor: UIColor
    
    public init(rightColor: UIColor, leftColor: UIColor) {
        self.rightColor = rightColor
        self.leftColor = leftColor
        
        super.init(frame: .zero)
        
        setupBackgroundGradient()
    }
    
    private func setupBackgroundGradient() {
        backgroundGradient.type = .axial
        backgroundGradient.colors = [rightColor.cgColor, leftColor.cgColor]
        backgroundGradient.startPoint = .init(x: 1.0, y: 0.5)
        backgroundGradient.endPoint = .init(x: 0.0, y: 0.5)
        
        self.layer.addSublayer(backgroundGradient)

    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        backgroundGradient.frame = bounds
    }
    
}
