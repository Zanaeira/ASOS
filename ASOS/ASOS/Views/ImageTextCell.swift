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
    
    private let primaryLabel = UILabel(font: .preferredFont(forTextStyle: .title2, weight: .bold))
    private let secondaryLabel = UILabel(font: .preferredFont(forTextStyle: .title3, weight: .regular))
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLabels()
        setupSubviews()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.text
        secondaryLabel.text = item.secondaryText
        imageView.image = item.image
    }
    
    private func setupLabels() {
        [primaryLabel, secondaryLabel].forEach({ label in
            label.backgroundColor = .white
            label.textColor = .black
        })
    }
    
    private func setupSubviews() {
        [imageView, primaryLabel, secondaryLabel].forEach(contentView.addSubview)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            secondaryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            secondaryLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -16),
            
            primaryLabel.centerXAnchor.constraint(equalTo: imageView.centerXAnchor),
            primaryLabel.bottomAnchor.constraint(equalTo: secondaryLabel.topAnchor, constant: -8)
        ])
    }

}
