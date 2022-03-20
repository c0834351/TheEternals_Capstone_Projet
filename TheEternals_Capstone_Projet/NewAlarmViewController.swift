//
//  NewAlarmViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sai Snehitha Bhatta on 20/03/22.
//

import UIKit

class NewAlarmViewController: UIViewController {

    @IBOutlet weak var alarmTitle: UITextField!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
                gradientLayer.frame = view.bounds
                gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

                view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

    

}
