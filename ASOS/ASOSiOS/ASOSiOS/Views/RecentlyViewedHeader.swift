//
//  RecentlyViewedHeader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

final class RecentlyViewedHeader: UICollectionReusableView {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    private let button = UIButton()
    
    private lazy var stackView = UIStackView(arrangedSubviews: [label, UIView(), button])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewProperties()
        addSubviews()
    }
    
    private func setupSubviewProperties() {
        setupLabel(font: .preferredFont(forTextStyle: .title3).bold())
        
        label.text = "Recently viewed"
        button.setTitle("CLEAR", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout).bold()
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = UIColor(named: "clear-button-gray")
        button.contentEdgeInsets = .init(top: 5, left: 10, bottom: 5, right: 10)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        
        stackView.layoutMargins = .init(top: 10, left: 0, bottom: 0, right: 0)
        stackView.isLayoutMarginsRelativeArrangement = true
    }
    
    private func setupLabel(font: UIFont, textColor: UIColor = .label, textAlignment: NSTextAlignment = .center) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
    }
    
    private func addSubviews() {
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory != previousTraitCollection?.preferredContentSizeCategory.isAccessibilityCategory {
            updateStackViewAxis()
        }
    }
    
    private func updateStackViewAxis() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
}
