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
    
    private let primaryLabel = UILabel(font: .preferredFont(forTextStyle: .title1, weight: .bold))
    private let secondaryLabel = UILabel(font: .preferredFont(forTextStyle: .title2, weight: .bold))
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    
    private lazy var primaryLabelStackView = UIStackView(arrangedSubviews: [primaryLabel])
    private lazy var secondaryLabelStackView = UIStackView(arrangedSubviews: [secondaryLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviews()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.text
        secondaryLabel.text = item.secondaryText
        imageView.image = item.image
    }
    
    private func setupSubviews() {
        [primaryLabel, secondaryLabel].forEach({$0.textColor = .black})
        
        [primaryLabelStackView, secondaryLabelStackView].forEach({ stackView in
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.backgroundColor = .white
            let padding: CGFloat = 8
            stackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
            stackView.isLayoutMarginsRelativeArrangement = true
        })
        
        [imageView, primaryLabelStackView, secondaryLabelStackView].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 450),
            
            secondaryLabelStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            secondaryLabelStackView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),

            primaryLabelStackView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            primaryLabelStackView.bottomAnchor.constraint(equalTo: secondaryLabelStackView.topAnchor, constant: -8)
        ])
    }

}
