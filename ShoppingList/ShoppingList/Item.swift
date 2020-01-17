//
//  Item.swift
//  ShoppingList
//
//  Created by Niklas Lieven on 17.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import Foundation

struct Item: Codable {
    let description: String
    var checked = false
}

class List {
    private(set) var items = [Item]()
    
    let filename = FileManager().getDocumentsDirectory().appendingPathComponent("shoppingList")
    
    func loadItems() {
        let decoder = JSONDecoder()
        
        if let decoded = try? decoder.decode([Item].self, from: Data(contentsOf: filename)) {
            items = decoded
            return
        }
    }
    
    func saveList() {
        let encoder = JSONEncoder()
        do {
            if let savedItems = try? encoder.encode(items) {
                try savedItems.write(to: filename)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func clear() {
        items = []
        saveList()
    }
    
    func removeItem(indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        saveList()
    }
    
    func addItem(with description: String) {
        items.insert(Item(description: description), at: 0)
        saveList()
    }
    
    func toggle(indexPath: IndexPath) {
        items[indexPath.row].checked.toggle()
        saveList()
    }
    
}
