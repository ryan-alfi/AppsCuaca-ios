//
//  ModallyViewController.swift
//  WeatherApp
//
//  Created by iMac on 1/26/17.
//  Copyright © 2017 Ari Fajrianda Alfi. All rights reserved.
//

import UIKit

class ModallyViewController: UIViewController {

    @IBOutlet weak var temp_CLbl: UILabel!
    @IBOutlet weak var temp_FLbl: UILabel!
    @IBOutlet weak var langitLbl: UILabel!
    @IBOutlet weak var lembabLbl: UILabel!
    @IBOutlet weak var awanLbl: UILabel!
    @IBOutlet weak var anginLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    var value: [String] = []
    
    override func viewWillAppear(_ animated: Bool) {
        temp_CLbl.text = value[0]
        temp_FLbl.text = value[1]
        langitLbl.text = value[2]
        lembabLbl.text = value[3]
        awanLbl.text = value[4]
        anginLbl.text = value[5]
        dateLbl.text = value[6]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }


}
