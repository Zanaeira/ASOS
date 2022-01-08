//
//  Item.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 03/01/2022.
//

import UIKit

public struct Item: Hashable {
    
    private let id = UUID()
    public let text: String
    public let secondaryText: String
    public let image: UIImage?
    
    public init(text: String = "", secondaryText: String = "", image: UIImage? = nil) {
        self.text = text
        self.secondaryText = secondaryText
        self.image = image
    }
    
}
