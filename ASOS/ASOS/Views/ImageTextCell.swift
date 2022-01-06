//
//  ImageTextCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

final class ImageTextCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let secondaryTextLabel = UILabel()
    
    private lazy var textLabelStackView = UIStackView(arrangedSubviews: [textLabel])
    private lazy var secondaryLabelStackView = UIStackView(arrangedSubviews: [secondaryTextLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewProperties()
        addSubviews()
    }
    
    func configure(with item: Item) {
        textLabel.text = item.text
        secondaryTextLabel.text = item.secondaryText
        imageView.image = item.image
    }
    
    private func setupSubviewProperties() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        setupLabel(textLabel, font: .preferredFont(forTextStyle: .title1).bold())
        setupLabel(secondaryTextLabel, font: .preferredFont(forTextStyle: .title2).bold())
    }
    
    private func setupLabel(_ label: UILabel, font: UIFont, textColor: UIColor = .label, textAlignment: NSTextAlignment = .center) {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = font
        label.textColor = textColor
        label.textAlignment = textAlignment
        label.adjustsFontForContentSizeCategory = false
        label.numberOfLines = 0
    }
    
    private func addSubviews() {
        [textLabel, secondaryTextLabel].forEach({$0.textColor = .black})
        
        [textLabelStackView, secondaryLabelStackView].forEach({ stackView in
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .white
            let padding: CGFloat = 8
            stackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
            stackView.isLayoutMarginsRelativeArrangement = true
        })
        
        [imageView, textLabelStackView, secondaryLabelStackView].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 450),
            
            secondaryLabelStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            secondaryLabelStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            textLabelStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            textLabelStackView.bottomAnchor.constraint(equalTo: secondaryLabelStackView.topAnchor, constant: -8)
        ])
    }

}
