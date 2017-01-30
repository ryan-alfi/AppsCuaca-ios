//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by iMac on 1/24/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {
    
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    var citySelected: String!
    var kondisi: [String] = []
    var imgUrl: [String] = []
    var waktu: [String] = []
    var tanggal: [String] = []
    var temperatur: [Int] = []

    var found: Bool = true
    var statusAstro: [String] = []
    var selected: Int! = 0
    
    var m_celcius: [String] = []
    var m_faren:[Int] = []
    var m_langit: [String] = []
    var m_lembab: [Int] = []
    var m_awan: [Int] = []
    var m_angin: [Double] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadData()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadData(){
        let urlRequest = URLRequest(url: URL(string: "http://api.apixu.com/v1/forecast.json?key=1941af355f954410af965752172401&q=\(citySelected.replacingOccurrences(of: " ", with: "%20"))")!)
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, err) in
            if err == nil {
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String : AnyObject]
                    
                    if let forecast = json["forecast"] as? [String : AnyObject] {
                        if let forecastday = forecast["forecastday"] as? [[String : AnyObject]], let day = forecastday.first {
                            if let hour = day["hour"] as? [[String : AnyObject]] {
                                for h in hour {
                                    if let time = h["time"] as? String {
                                        let sureTime = time.components(separatedBy: " ")
                                        self.waktu.append(sureTime.last!)
                                        self.tanggal.append(sureTime.first!)
                                    }
                                    
                                    if let temp = h["temp_c"] as? Int{
                                        self.temperatur.append(temp)
                                    }
                                    
                                    if let condition = h["condition"] as? [String : AnyObject] {
                                        let tmp_text = condition["text"] as! String
                                        let tmp_icon_pre = condition["icon"] as! String
                                        let tmp_icon = "http:\(tmp_icon_pre)"
                                        self.kondisi.append(tmp_text)
                                        self.imgUrl.append(tmp_icon)
                                    }
                                    
                                    if let tempf = h["temp_f"] as? Int{
                                        self.m_faren.append(tempf)
                                    }
                                    
                                    if let day = h["is_day"] as? Int{
                                        if day == 1 {
                                            self.m_langit.append("Terang")
                                        }else{
                                            self.m_langit.append("Gelap")
                                        }
                                    }
                                    
                                    if let humadity = h["humidity"] as? Int {
                                        self.m_lembab.append(humadity)
                                    }
                                    
                                    if let cloud = h["cloud"] as? Int  {
                                        self.m_awan.append(cloud)
                                    }
                                    
                                    if let wind = h["wind_mph"] as? Double {
                                        self.m_angin.append(wind)
                                    }
                                }
                                
                            }
                            
                            if let astro = day["astro"] as? [String : AnyObject] {
                                self.statusAstro.append(astro["sunrise"] as! String)
                                self.statusAstro.append(astro["sunset"] as! String)
                                self.statusAstro.append(astro["moonrise"] as! String)
                                self.statusAstro.append(astro["moonset"] as! String)
                            }
                        }
                    }
                    
                    DispatchQueue.main.async(execute: {self.do_table_refresh()})
                    
                    if let _ = json["error"] {
                        self.found = false
                    }
                    
                }catch let jsonErr {
                    print(jsonErr.localizedDescription)
                }
            }
        }
        task.resume()
    }
    

    // MARK: - UITableView
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return kondisi.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomViewCell
        cell.selectionStyle = .default
        tableView.tableFooterView?.isHidden = true
        
        cell.kondisi?.text = kondisi[indexPath.row]
        cell.waktu?.text = "Pukul \(waktu[indexPath.row])"
        cell.temperatur?.text = "\(temperatur[indexPath.row].description)°"
        cell.img?.downloadImage(from: imgUrl[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        dateFormatter.locale = Locale(identifier: "id_ID")
        
        let date = Date()
        return " \(dateFormatter.string(from:date))"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
    }
    
    
    func do_table_refresh()
    {
        self.tableView.reloadData()
        self.loadIndicator.isHidden = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSunMoon" {
            if let dest = segue.destination as? SunMoonViewController {
                dest.status = self.statusAstro
            }
        }else if segue.identifier == "modalDetails"{
            if let destination = segue.destination as? ModallyViewController{
//                destination.temp_CLbl.text = self.temperatur[selected].description
//                destination.temp_FLbl.text = self.m_faren[selected].description
//                destination.langitLbl.text = self.m_langit[selected]
//                destination.lembabLbl.text = self.m_lembab[selected].description
//                destination.awanLbl.text = self.m_awan[selected].description
//                destination.anginLbl.text = self.m_angin[selected]
                let idx = tableView.indexPathForSelectedRow?.row
                destination.value.append("\(self.temperatur[idx!].description)°")
                destination.value.append("\(self.m_faren[idx!].description)°")
                destination.value.append(self.m_langit[idx!])
                destination.value.append(self.m_lembab[idx!].description)
                destination.value.append(self.m_awan[idx!].description)
                destination.value.append(self.m_angin[idx!].description)
                destination.value.append("\(self.tanggal[idx!]) \(self.waktu[idx!])")
            }
        }
    }
    

}


