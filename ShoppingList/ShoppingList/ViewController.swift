//
//  ViewController.swift
//  ShoppingList
//
//  Created by Niklas Lieven on 17.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    let shoppingList = List()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shopping List"
        
        // load list
        shoppingList.loadItems()
        
        
        // bar buttons
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
        deleteButton.tintColor = .red
        
        navigationItem.leftBarButtonItem = deleteButton
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        
        
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add item to your list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.textFields?[0].placeholder = "Milk, coffee, fruit loops..."
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let text = ac.textFields?[0].text {
                if text.isEmpty { return }
                self.shoppingList.addItem(with: text)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        shoppingList.clear()
        tableView.reloadData()
    }
    
    
    // MARK: tableView functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        
        let item = shoppingList.items[indexPath.row]
        cell.textLabel?.text = item.description
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        shoppingList.toggle(indexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.removeItem(indexPath: indexPath)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
}

extension FileManager {
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
