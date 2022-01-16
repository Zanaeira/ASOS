//
//  ItemUpdater.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 11/01/2022.
//

import Foundation

public protocol ItemUpdater {
    func update(itemId: String, updateData: ItemData)
}
