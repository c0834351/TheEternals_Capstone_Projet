//
//  AlarmsViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sravan Sriramoju on 2022-03-20.
//

import UIKit

class AlarmsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
    }

}
