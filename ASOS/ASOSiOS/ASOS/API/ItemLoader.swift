//
//  ItemLoader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 09/01/2022.
//

import Foundation

public protocol ItemLoader {
    func loadItems(from url: URL, completion: @escaping ((Result<[Item], Error>) -> Void) )
}
