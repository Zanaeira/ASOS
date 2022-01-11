//
//  RemoteItemLoader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 09/01/2022.
//

import UIKit

public final class RemoteItemLoader: ItemLoader {
    
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
    
}

private final class ItemMapper {
    
    static func map(_ data: Data) throws -> [Item] {
        let root = try JSONDecoder().decode(Root.self, from: data)
        
        return root.mappedItems
    }
    
}

private struct Root: Decodable {
    let items: [DecodableItem]
    
    var mappedItems: [Item] {
        items.map { .init(text: $0.text, secondaryText: $0.secondaryText, image: !$0.imageName.isEmpty ? UIImage(named: $0.imageName) : nil, section: Section(rawValue: $0.section) ?? .announcements) }
    }
}

private struct DecodableItem: Decodable {
    let text: String
    let secondaryText: String
    let imageName: String
    let section: Int
}
