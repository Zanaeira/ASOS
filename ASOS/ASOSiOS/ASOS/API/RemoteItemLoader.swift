//
//  RemoteItemLoader.swift
//  ASOS
//
//  Created by Suhayl Ahmed on 09/01/2022.
//

import UIKit

public final class RemoteItemLoader: ItemLoader, ItemUpdater {
    
    public enum UpdateError: Error {
        case unableToSaveChanges
    }
    
    public init() {}
    
    private let cacheFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cache.json")
    
    private var items = [Item]()
    
    public func loadItems(from url: URL, completion: @escaping ((Result<[Item], Error>) -> Void)) {
        items = []
        
        guard let cacheData = try? Data(contentsOf: cacheFilePath),
              let cachedItems = try? ItemMapper.map(cacheData) else {
            Item.stubs.forEach { items.append($0) }
            completion(.success(Item.stubs))
            return
        }
        
        cachedItems.forEach { self.items.append($0) }
        
        completion(.success(items))
    }
    
    public func update(itemId: String, updateData: ItemData, completion: @escaping (Result<[Item], Error>) -> Void) {
        var updatedItems = [CodableItem]()
        for (item, imageName) in zip(items, Item.imageNameStubs) {
            if item.id.uuidString == itemId {
                updatedItems.append(item.toCodableItem(usingImageName: imageName ?? "", isLiked: updateData.itemLiked))
            } else {
                updatedItems.append(item.toCodableItem(usingImageName: imageName ?? "", isLiked: item.isLiked))
            }
        }
        
        let root = Root(items: updatedItems)
        
        do {
            let encodedItems = try JSONEncoder().encode(root)
            try encodedItems.write(to: cacheFilePath)
        } catch {
            completion(.failure(UpdateError.unableToSaveChanges))
        }
        
        items = root.mappedItems
        completion(.success(items))
    }
    
}

private extension Item {
    func toCodableItem(usingImageName imageName: String, isLiked: Bool) -> CodableItem {
        .init(id: id.uuidString, text: text, secondaryText: secondaryText, imageName: imageName, isLiked: isLiked, section: section.rawValue)
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
