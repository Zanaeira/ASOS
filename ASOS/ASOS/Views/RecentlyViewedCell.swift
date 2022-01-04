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
    
    private let label = UILabel(font: .preferredFont(forTextStyle: .callout), textAlignment: .natural, numberOfLines: 2, adjustsFontSizeToFitWidth: false)
    private let button = UIButton()
    private let imageView = UIImageView(contentMode: .scaleAspectFill)
    
    private lazy var buttonWrapperStackView = UIStackView(arrangedSubviews: [UIView(), button])
    private lazy var stackView = UIStackView(arrangedSubviews: [imageView, buttonWrapperStackView, label])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupSubviewProperties()
        setupSubviews()
    }
    
    func configure(with item: Item) {
        label.text = item.text
        imageView.image = item.image
    }
    
    private func setupSubviewProperties() {
        label.textColor = .systemGray
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        button.addTarget(self, action: #selector(favouritePressed), for: .touchUpInside)
        imageView.heightAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
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
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
}
