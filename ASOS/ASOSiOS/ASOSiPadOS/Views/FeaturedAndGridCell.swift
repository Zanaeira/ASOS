//
//  FeaturedAndGridCell.swift
//  ASOSiPadOS
//
//  Created by Suhayl Ahmed on 08/01/2022.
//

import UIKit
import ASOS

final class FeaturedAndGridCell: UICollectionViewCell {
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    private let imageView = UIImageView()
    private let textLabel = UILabel()
    private let secondaryTextLabel = UILabel()
    
    private lazy var labelsStackView = UIStackView(arrangedSubviews: [textLabel, secondaryTextLabel])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, labelsStackView])
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewProperties()
        addSubviews()
    }
    
    public func configure(with item: Item) {
        imageView.image = item.image
        textLabel.text = item.text
        secondaryTextLabel.text = item.secondaryText
    }
    
    private func setupSubviewProperties() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        
        setupLabel(textLabel, font: .preferredFont(forTextStyle: .body).bold())
        setupLabel(secondaryTextLabel, font: .preferredFont(forTextStyle: .callout), textColor: .systemGray)
        
        labelsStackView.translatesAutoresizingMaskIntoConstraints = false
        labelsStackView.axis = .vertical
        labelsStackView.distribution = .fill
        labelsStackView.spacing = 7
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 5
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
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
