//
//  ItemCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

final class ItemCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let primaryLabel = UILabel(font: .preferredFont(forTextStyle: .body, weight: .bold))
    private let secondaryLabel = UILabel(font: .preferredFont(forTextStyle: .callout))
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, primaryLabel, secondaryLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabels()
        setupStackView()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.text
        secondaryLabel.text = item.secondaryText
        imageView.image = item.image
    }
    
    func configureFontColors(primaryTextColor: UIColor? = nil, secondaryTextColor: UIColor? = nil) {
        if let primaryTextColor = primaryTextColor {
            primaryLabel.textColor = primaryTextColor
        }
        
        if let secondaryTextColor = secondaryTextColor {
            secondaryLabel.textColor = secondaryTextColor
        }
    }
    
    func configureFonts(primaryTextFont: UIFont? = nil, secondaryTextFont: UIFont? = nil) {
        if let primaryTextFont = primaryTextFont {
            primaryLabel.font = primaryTextFont
        }
        
        if let secondaryTextFont = secondaryTextFont {
            secondaryLabel.font = secondaryTextFont
        }
    }
    
    private func setupLabels() {
        configureFontColors(secondaryTextColor: .systemGray)
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}

private extension UILabel {
    
    convenience init(font: UIFont, textColor: UIColor = .label) {
        self.init(frame: .zero)
        
        self.font = font
        self.textColor = textColor
        textAlignment = .center
        adjustsFontForContentSizeCategory = true
        adjustsFontSizeToFitWidth = true
        numberOfLines = 0
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}

private extension UIImageView {
    
    convenience init(contentMode: UIView.ContentMode) {
        self.init()
        
        self.contentMode = contentMode
        clipsToBounds = true
        translatesAutoresizingMaskIntoConstraints = false
    }
    
}
