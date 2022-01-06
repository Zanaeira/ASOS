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
    
    private let primaryLabel = UILabel(font: .preferredFont(forTextStyle: .title2).bold())
    private let secondaryLabel = UILabel(font: .preferredFont(forTextStyle: .title3).bold())
    
    private lazy var primaryLabelStackView = UIStackView(arrangedSubviews: [primaryLabel])
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .systemIndigo
        setupSubviews()
    }
    
    func configure(with item: Item) {
        primaryLabel.text = item.text
        secondaryLabel.text = item.secondaryText
    }
    
    private func setupSubviews() {
        primaryLabelStackView.backgroundColor = .white
        primaryLabel.textColor = .systemIndigo
        secondaryLabel.textColor = .white
        
        let padding: CGFloat = 8
        primaryLabelStackView.layoutMargins = .init(top: padding, left: padding, bottom: padding, right: padding)
        primaryLabelStackView.isLayoutMarginsRelativeArrangement = true
        
        [primaryLabelStackView, secondaryLabel].forEach({ subview in
            subview.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview(subview)
        })
        
        NSLayoutConstraint.activate([
            primaryLabelStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            primaryLabelStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),

            secondaryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondaryLabel.topAnchor.constraint(equalTo: primaryLabelStackView.bottomAnchor, constant: 8),
            secondaryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
}
