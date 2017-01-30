//
//  SunMoonViewController.swift
//  WeatherApp
//
//  Created by iMac on 1/26/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class SunMoonViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource{

    @IBOutlet weak var MyCollectionView: UICollectionView!
    
    var status: [String] = []
    var images = ["sunset", "sunrise", "moonset", "moonrise"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.MyCollectionView.delegate = self
        self.MyCollectionView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collection_cell", for: indexPath) as! MyCollectionViewCell
        cell.layer.cornerRadius = 6
        
        cell.imgView.image = UIImage(named: images[indexPath.row])
        cell.myLabel.text = "\(self.images[indexPath.row]) "
        cell.StatusLbl.text = "Pukul \(self.status[indexPath.row])"
        
        return cell
    }

}
