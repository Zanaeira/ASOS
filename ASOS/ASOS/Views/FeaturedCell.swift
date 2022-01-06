//
//  FeaturedCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 05/01/2022.
//

import UIKit

final class FeaturedCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let secondaryTextLabel = UILabel()
    
    private var imageViewConstraints: [NSLayoutConstraint] = []
    private var textLabelConstraints: [NSLayoutConstraint] = []
    private var secondaryTextLabelConstraints: [NSLayoutConstraint] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewProperties()
        addSubviews()
        setupLayoutConstraints()
        updateLayoutConstraints()
    }
    
    func configure(with item: Item) {
        imageView.image = item.image
        textLabel.text = item.text
        secondaryTextLabel.text = item.secondaryText
    }
    
    private func setupSubviewProperties() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        setupLabel(textLabel, font: .preferredFont(forTextStyle: .body).bold())
        setupLabel(secondaryTextLabel, font: .preferredFont(forTextStyle: .callout), textColor: .systemGray)
    }
    
    private func setupLabel(_ label: UILabel, font: UIFont, textColor: UIColor = .label, textAlignment: NSTextAlignment = .center) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
    }
    
    private func addSubviews() {
        [imageView, textLabel, secondaryTextLabel].forEach(contentView.addSubview)
    }
    
    private func setupLayoutConstraints() {
        imageViewConstraints = [
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        textLabelConstraints = [
            textLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 10),
            textLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            textLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -10)
        ]
        
        secondaryTextLabelConstraints = [
            secondaryTextLabel.firstBaselineAnchor.constraint(equalToSystemSpacingBelow: textLabel.lastBaselineAnchor, multiplier: 1.25),
            secondaryTextLabel.leadingAnchor.constraint(equalTo: textLabel.leadingAnchor),
            secondaryTextLabel.trailingAnchor.constraint(equalTo: textLabel.trailingAnchor),
            secondaryTextLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor)
        ]
    }
    
    private func updateLayoutConstraints() {
        [imageViewConstraints, textLabelConstraints, secondaryTextLabelConstraints].forEach(NSLayoutConstraint.activate)
    }
    
}
