//
//  NewAlarmViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sai Snehitha Bhatta on 20/03/22.
//

import UIKit

class NewAlarmViewController: UIViewController {
    
    @IBOutlet weak var datesVStackview: UIStackView!
    @IBOutlet weak var weekdaysStackView: UIStackView!
    @IBOutlet weak var alarmToneVStackView: UIStackView!
    @IBOutlet weak var picturesHStackView: UIStackView!
    @IBOutlet weak var repeatStackView: UIStackView!
    
    @IBOutlet weak var weekdaysSVConstraint: NSLayoutConstraint!
    @IBOutlet weak var alarmToneVSHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picturesHSHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var alarmTitle: UITextField!
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var repeatFlag: UISwitch!
    
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var TuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    
    
    
    @IBOutlet weak var alarmTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
                gradientLayer.frame = view.bounds
                gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

                view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    

    

}
