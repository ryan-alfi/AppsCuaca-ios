//
//  ViewController.swift
//  WeatherApp
//
//  Created by iMac on 1/24/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var conditionLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var viewDetailBtn: UIButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var degree: Int!
    var condition: String!
    var imgURL: String!
    var city: String!
    
    
    var exist: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchBar.delegate = self
        viewDetailBtn.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.cityLbl.isHidden = true
        self.loadingIndicator.isHidden = false
        
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/current.json?key=1941af355f954410af965752172401&q=\(searchBar.text!.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil{
                do{
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    if let current = json["current"] as? [String : AnyObject]{
                        if let temp = current["temp_c"] as? Int {
                            self.degree = temp
                        }
                        if let condition = current["condition"] as? [String : AnyObject] {
                            self.condition = condition["text"] as! String
                            let icon = condition["icon"] as! String
                            self.imgURL = "http:\(icon)"    
                        }
                    }
                    
                    if let location = json["location"] as?  [String: AnyObject] {
                        self.city = location["name"] as! String
                    }
                    
                    if let _ = json["error"] {
                        self.exist = false
                    }
                    
                    DispatchQueue.main.async {
                        if self.exist{
                            self.cityLbl.isHidden = false
                            self.degreeLbl.isHidden = false
                            self.conditionLbl.isHidden = false
                            self.imgView.isHidden = false
                            self.viewDetailBtn.isHidden = false
                            self.loadingIndicator.isHidden = true
                            self.degreeLbl.text = "\(self.degree.description)°"
                            self.cityLbl.text = self.city
                            self.conditionLbl.text = self.condition
                            self.imgView.downloadImage(from: self.imgURL!)
                        }else{
                            self.loadingIndicator.isHidden = true
                            self.degreeLbl.isHidden = true
                            self.conditionLbl.isHidden = true
                            self.imgView.isHidden = true
                            self.viewDetailBtn.isHidden = true
                            self.cityLbl.text = "Nama kota tidak ditemukan."
                            self.exist = true
                        }
                    }
                    
                }catch let jsonError{
                    print(jsonError.localizedDescription)
                }
            }
        }
        task.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? DetailViewController {
            destination.citySelected = city
        }
    }

}

extension UIImageView {
    
    func downloadImage(from url: String){
        
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if error == nil {
                DispatchQueue.main.async {
                    self.image = UIImage(data: data!)
                }
            }
        }
        task.resume()
    }
    
}

extension String {
    var byWords: [String] {
        var result:[String] = []
        enumerateSubstrings(in: startIndex..<endIndex, options: .byWords) {
            guard let word = $0 else { return }
            print($1,$2,$3)
            result.append(word)
        }
        return result
    }
    var lastWord: String {
        return byWords.last ?? ""
    }
    func lastWords(_ max: Int) -> [String] {
        return Array(byWords.suffix(max))
    }
}

