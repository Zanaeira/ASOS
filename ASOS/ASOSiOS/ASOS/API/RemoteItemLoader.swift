//
//  RemoteItemLoader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 09/01/2022.
//

import UIKit

public final class RemoteItemLoader: ItemLoader, ItemUpdater {
    
    public init() {}
    
    public func loadItems(from url: URL, completion: @escaping ((Result<[Item], Error>) -> Void)) {
        guard let cacheUrl = Bundle(for: type(of: self)).url(forResource: "cache", withExtension: "json"),
              let data = try? Data(contentsOf: cacheUrl),
              let items = try? ItemMapper.map(data) else {
            completion(.success(Item.stubs))
            return
        }
        
        completion(.success(items))
    }
    
    public func update(itemId: String, updateData: ItemData) {
        
    }
    
}

private final class ItemMapper {
    
    static func map(_ data: Data) throws -> [Item] {
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.mappedItems
    }
    
}

private struct Root: Codable {
    let items: [CodableItem]
    
    var mappedItems: [Item] {
        items.map { $0.item}
    }
}

private struct CodableItem: Codable {
    let id: String
    let text: String
    let secondaryText: String
    let imageName: String
    let isLiked: Bool?
    let section: Int
    
    var item: Item {
        Item(id: id, text: text, secondaryText: secondaryText, image: !imageName.isEmpty ? UIImage(named: imageName) : nil, isLiked: isLiked ?? false, section: Section(rawValue: section) ?? .announcements)
    }
}
