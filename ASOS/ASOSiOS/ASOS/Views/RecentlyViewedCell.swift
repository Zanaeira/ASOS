//
//  RecentlyViewedCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

public final class RecentlyViewedCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    private let button = UIButton()
    private let imageView = UIImageView()
    
    private lazy var normalImageViewHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
    private lazy var accessibilityImageViewHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
    
    public var onLikePressed: ((Bool) -> Void)?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundView()
        setupSubviewProperties()
        addSubviews()
        updateImageHeightConstraint()
    }
    
    public func configure(with item: Item) {
        label.text = item.text
        imageView.image = item.image
        button.isSelected = item.isLiked
    }
    
    private func setupBackgroundView() {
        backgroundView = RecentlyViewedCellBackgroundView(frame: .zero)
    }
    
    private func setupSubviewProperties() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        updateButtonImages()
        
        button.addTarget(self, action: #selector(favouritePressed), for: .touchUpInside)
        
        setupLabel(font: .preferredFont(forTextStyle: .callout), textColor: .systemGray, textAlignment: .natural, numberOfLines: 2)
    }
    
    private func setupLabel(font: UIFont, textColor: UIColor = .label, textAlignment: NSTextAlignment = .center, numberOfLines: Int = 0) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = numberOfLines
    }
    
    @objc private func favouritePressed() {
        button.isSelected.toggle()
        onLikePressed?(button.isSelected)
    }
    
    public func undoLikePressed() {
        button.isSelected.toggle()
    }
    
    private func addSubviews() {
        [imageView, button, label].forEach(contentView.addSubview)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            button.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            button.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            
            label.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
            label.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    private func updateImageHeightConstraint() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            NSLayoutConstraint.deactivate([normalImageViewHeightConstraint])
            NSLayoutConstraint.activate([accessibilityImageViewHeightConstraint])
        } else {
            NSLayoutConstraint.deactivate([accessibilityImageViewHeightConstraint])
            NSLayoutConstraint.activate([normalImageViewHeightConstraint])

        }
    }
    
    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        if traitCollection != previousTraitCollection {
            updateImageHeightConstraint()
            updateButtonImages()
        }
    }
    
    private func updateButtonImages() {
        let config: UIImage.SymbolConfiguration
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .medium)
        } else {
            config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .small)
        }
        
        let normalImage =  UIImage(systemName: "heart", withConfiguration: config)
        let selectedImage =  UIImage(systemName: "heart.fill", withConfiguration: config)
        button.setImage(normalImage, for: .normal)
        button.setImage(selectedImage, for: .selected)
        button.tintColor = .black
    }
    
}
