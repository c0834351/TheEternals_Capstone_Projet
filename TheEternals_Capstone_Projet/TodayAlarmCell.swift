//
//  TodayAlarmCell.swift
//  TheEternals_Capstone_Projet
//
//  Created by Ashish reddy mula on 15/03/22.
//

import UIKit

class TodayAlarmCell: UITableViewCell {

    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var medimage: UIImageView!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var afterFood: UILabel!
    
    @IBOutlet weak var medicines: UILabel!
    
    @IBOutlet weak var enabled: UISwitch!
    
    func setCell(picture: UIImage, timeValue: String, afterFoodValue: String, medicinesValue: String, enabledValue: Bool){
        medimage.image = picture
        time.text = timeValue
        afterFood.text = afterFoodValue
        medicines.text = medicinesValue
        enabled.setOn(enabledValue, animated: true)
        
        cardView.layer.shadowColor = UIColor.gray.cgColor
        cardView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        cardView.layer.cornerRadius = 14
        cardView.layer.shadowOpacity = 1.0
        cardView.layer.masksToBounds = false
    }

}
