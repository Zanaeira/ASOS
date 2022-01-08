//
//  UICollectionViewListCell+Ext.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 08/01/2022.
//

import UIKit

public extension UICollectionViewListCell {
    
    func configure(with item: Item) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.backgroundColor = .black
        backgroundConfiguration = backgroundConfig
        
        var config = defaultContentConfiguration()
        config.text = item.text
        config.secondaryText = item.secondaryText
        
        config.textProperties.font = .preferredFont(forTextStyle: .title3).bold()
        config.textProperties.color = .white
        config.textProperties.alignment = .center
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
        config.secondaryTextProperties.alignment = .center
        config.secondaryTextProperties.color = .white
        
        contentConfiguration = config
        
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
    }
    
    func configure(withItem item: Item, andBackgroundView backgroundView: UIView) {
        var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
        backgroundConfig.customView = backgroundView
        backgroundConfiguration = backgroundConfig
        
        var config = defaultContentConfiguration()
        config.text = item.text
        config.secondaryText = item.secondaryText
        
        config.textProperties.font = .preferredFont(forTextStyle: .title1).bold()
        config.textProperties.color = .black
        config.textProperties.alignment = .center
        config.secondaryTextProperties.font = .preferredFont(forTextStyle: .caption1)
        config.secondaryTextProperties.alignment = .center
        config.secondaryTextProperties.color = .black
        
        contentConfiguration = config
    }
    
}
