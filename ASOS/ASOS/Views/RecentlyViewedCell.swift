//
//  RecentlyViewedCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

final class RecentlyViewedCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let label = UILabel()
    private let button = UIButton()
    private let imageView = UIImageView()
    
    private lazy var buttonWrapperStackView = UIStackView(arrangedSubviews: [UIView(), button])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, buttonWrapperStackView, label])
    
    private lazy var normalImageViewHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 200)
    private lazy var accessibilityImageViewHeightConstraint = imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 400)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBackgroundView()
        setupSubviewProperties()
        setupSubviews()
        addSubviews()
        updateImageHeightConstraint()
    }
    
    func configure(with item: Item) {
        label.text = item.text
        imageView.image = item.image
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
    }
    
    private func setupSubviews() {
        stackView.axis = .vertical
        stackView.spacing = 10
        
        let padding: CGFloat = 10
        stackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
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
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory != previousTraitCollection?.preferredContentSizeCategory.isAccessibilityCategory {
            updateImageHeightConstraint()
            updateButtonImages()
        }
    }
    
    private func updateButtonImages() {
        let isAccessibilityCategory = traitCollection.preferredContentSizeCategory.isAccessibilityCategory
        if isAccessibilityCategory {
            let config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .medium)
            let normalImage =  UIImage(systemName: "heart", withConfiguration: config)
            let selectedImage =  UIImage(systemName: "heart.fill", withConfiguration: config)
            button.setImage(normalImage, for: .normal)
            button.setImage(selectedImage, for: .selected)
        } else {
            let config = UIImage.SymbolConfiguration(textStyle: .largeTitle, scale: .small)
            let normalImage =  UIImage(systemName: "heart", withConfiguration: config)
            let selectedImage =  UIImage(systemName: "heart.fill", withConfiguration: config)
            button.setImage(normalImage, for: .normal)
            button.setImage(selectedImage, for: .selected)
        }
    }
    
}
