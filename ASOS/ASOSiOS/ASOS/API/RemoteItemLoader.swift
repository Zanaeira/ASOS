//
//  RemoteItemLoader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 09/01/2022.
//

import Foundation

public final class RemoteItemLoader: ItemLoader {
    
    public init() {}
    
    public func loadItems(from url: URL, completion: @escaping ((Result<[Item], Error>) -> Void)) {
        completion(.success(Item.stubs))
    }
    
}
