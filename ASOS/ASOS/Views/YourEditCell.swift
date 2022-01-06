//
//  YourEditCell.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 04/01/2022.
//

import UIKit

final class YourEditCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let textLabel = UILabel()
    private let secondaryTextLabel = UILabel()
    
    private lazy var textLabelStackView = UIStackView(arrangedSubviews: [textLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemIndigo
        setupSubviewProperties()
        addSubviews()
    }
    
    func configure(with item: Item) {
        textLabel.text = item.text
        secondaryTextLabel.text = item.secondaryText
    }
    
    private func setupSubviewProperties() {
        setupLabel(textLabel, font: .preferredFont(forTextStyle: .title2).bold(), textColor: .systemIndigo)
        setupLabel(secondaryTextLabel, font: .preferredFont(forTextStyle: .title3).bold(), textColor: .white)
        
        textLabelStackView.backgroundColor = .white
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
        let padding: CGFloat = 8
        textLabelStackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
        textLabelStackView.isLayoutMarginsRelativeArrangement = true
        
        [textLabelStackView, secondaryTextLabel].forEach({ subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subview)
        })
        
        NSLayoutConstraint.activate([
            textLabelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            secondaryTextLabel.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor, constant: 10),
            secondaryTextLabel.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor, constant: -10),
            secondaryTextLabel.topAnchor.constraint(equalTo: textLabelStackView.bottomAnchor, constant: 8),
            secondaryTextLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
