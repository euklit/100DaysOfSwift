//
//  DetailViewController.swift
//  MilestoneProject1
//
//  Created by Niklas Lieven on 07.01.20.
//  Copyright © 2020 euklit. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    var imageName: String?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = imageName?.components(separatedBy: "@")[0].uppercased()
        navigationController?.navigationBar.prefersLargeTitles = false
        if let imageToLoad = imageName {
            imageView.image = UIImage(named: imageToLoad)
        }
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        // Do any additional setup after loading the view.
    }
    
    @objc func shareTapped() {
        guard let imageData = imageView.image?.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        let ac = UIActivityViewController(activityItems: [imageData, title ?? ""], applicationActivities: [])
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        
        
        present(ac, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
