//
//  Item.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

struct Item: Hashable {
    private let id = UUID()
    let text: String
    let secondaryText: String
    let image: UIImage?
    
    init(text: String = "", secondaryText: String = "", image: UIImage? = nil) {
        self.text = text
        self.secondaryText = secondaryText
        self.image = image
    }
}
