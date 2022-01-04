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
        
        setupCellWithDefaultStyling()
        setupStackView()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.text
        secondaryLabel.text = item.secondaryText
        imageView.image = item.image
    }
    
    private func setupCellWithDefaultStyling() {
        backgroundView = nil
        contentView.backgroundColor = .clear
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.layer.borderWidth = 0
        configureFonts(primaryTextFont: .preferredFont(forTextStyle: .body, weight: .bold), secondaryTextFont: .preferredFont(forTextStyle: .callout))
        configureFontColors(primaryTextColor: .label, secondaryTextColor: .systemGray)
    }
    
    func styleForSection(_ section: Section) {
        switch section {
        case .announcements:
            contentView.backgroundColor = .black
            contentView.layer.borderColor = UIColor.white.cgColor
            contentView.layer.borderWidth = 1
            configureFontColors(primaryTextColor: .white, secondaryTextColor: .white)
            configureFonts(primaryTextFont: .preferredFont(forTextStyle: .body, weight: .bold), secondaryTextFont: .preferredFont(forTextStyle: .caption1))
        case .sales:
            configureFonts(primaryTextFont: .preferredFont(forTextStyle: .title1, weight: .black), secondaryTextFont: .preferredFont(forTextStyle: .caption1))
            configureFontColors(primaryTextColor: .black, secondaryTextColor: .black)
            backgroundView = GradientBackgroundView(frame: .zero)
        case .featured: break
        }
    }
    
    private func configureFontColors(primaryTextColor: UIColor? = nil, secondaryTextColor: UIColor? = nil) {
        if let primaryTextColor = primaryTextColor {
            primaryLabel.textColor = primaryTextColor
        }
        
        if let secondaryTextColor = secondaryTextColor {
            secondaryLabel.textColor = secondaryTextColor
        }
    }
    
    private func configureFonts(primaryTextFont: UIFont? = nil, secondaryTextFont: UIFont? = nil) {
        if let primaryTextFont = primaryTextFont {
            primaryLabel.font = primaryTextFont
        }
        
        if let secondaryTextFont = secondaryTextFont {
            secondaryLabel.font = secondaryTextFont
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        setupCellWithDefaultStyling()
    }
    
    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.layoutMargins = .init(top: 10, left: 0, bottom: 10, right: 0)
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
