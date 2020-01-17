//
//  ViewController.swift
//  ShoppingList
//
//  Created by Niklas Lieven on 17.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import UIKit

struct Item: Codable {
    let name: String
    var checked = false
}

class ViewController: UITableViewController {
    var shoppingList: [String] = []
    let filename = FileManager().getDocumentsDirectory().appendingPathComponent("shoppingList")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        title = "Shopping List"
        
        // load list
        if let items = try? String(contentsOf: filename) {
            shoppingList = items.components(separatedBy: ",")
        }
        
        
        // bar buttons
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(clearList))
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Add an item to your list", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let newItem = ac.textFields?[0].text {
                if newItem.isEmpty { return }
                self.shoppingList.insert(newItem, at: 0)
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
                self.saveList()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        ac.addAction(cancelAction)
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func clearList() {
        shoppingList = []
        saveList()
        tableView.reloadData()
    }
    
    func saveList() {
        let joinedList = shoppingList.joined(separator: ",")
        do {
            try joinedList.write(to: filename, atomically: true, encoding: String.Encoding.utf8)
        } catch {
            print("save unsuccesful")
        }
    }
    
    // MARK: tableView functions
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath)
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            shoppingList.remove(at: indexPath.row)
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
