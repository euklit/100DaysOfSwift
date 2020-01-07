//
//  ViewController.swift
//  MilestoneProject1
//
//  Created by Niklas Lieven on 07.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var flags: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Fun with flags"
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        flags = items.filter { $0.hasSuffix(".png") }
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flags.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = flags[indexPath.row].components(separatedBy: "@")[0].uppercased()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "Detail") as! DetailViewController
        vc.imageName = flags[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

}

