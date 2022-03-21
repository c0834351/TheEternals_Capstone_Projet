//
//  NewAlarmViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sai Snehitha Bhatta on 20/03/22.
//

import UIKit

class NewAlarmViewController: UIViewController {
    
    //StackViews
    @IBOutlet weak var datesVStackview: UIStackView!
    @IBOutlet weak var weekdaysStackView: UIStackView!
    @IBOutlet weak var alarmToneVStackView: UIStackView!
    @IBOutlet weak var picturesHStackView: UIStackView!
    @IBOutlet weak var repeatStackView: UIStackView!
    
    //Constraints
    @IBOutlet weak var weekdaysSVConstraint: NSLayoutConstraint!
    @IBOutlet weak var alarmToneVSHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picturesHSHeightConstraint: NSLayoutConstraint!
    
    //TextFields
    @IBOutlet weak var alarmTitle: UITextField!
    
    //ImageViews
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    
    //Switches
    @IBOutlet weak var snoozeSwitch: UISwitch!
    @IBOutlet weak var repeatFlag: UISwitch!
    
    //Buttons
    @IBOutlet weak var sundayButton: UIButton!
    @IBOutlet weak var mondayButton: UIButton!
    @IBOutlet weak var TuesdayButton: UIButton!
    @IBOutlet weak var wednesdayButton: UIButton!
    @IBOutlet weak var thursdayButton: UIButton!
    @IBOutlet weak var fridayButton: UIButton!
    @IBOutlet weak var saturdayButton: UIButton!
    @IBOutlet weak var recordBtnLB: UIButton!
    @IBOutlet weak var playBtnLB: UIButton!
    @IBOutlet weak var setDefaultToneBtnLB: UIButton!
    @IBOutlet weak var showAudioOptionsBTN: UIButton!
    @IBOutlet weak var showPicturesOptionsBTN: UIButton!
    
    //DatePickers
    @IBOutlet weak var alarmTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    private var newAlarm: Alarm!
    private var audioFileName = ""


    var alarms = [Alarm]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    
    
    @IBAction func repeatFlagIsON(_ sender: UISwitch) {
    }
    
    
    @IBAction func snoozeSwitchTapped(_ sender: UISwitch) {
    }
    
    
    
    @IBAction func recordBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func playBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func setDefaultToneClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func galleryBtnClicked(_ sender: Any) {
    }
    
    
    
    @IBAction func didTapSave() {
        guard let name = alarmTitle.text, !name.isEmpty else{
            showAlert(message: "Title for Alarm is required")
            return
        }
        let timeformat = DateFormatter()
        timeformat.dateFormat = "hh:mm a"
        newAlarm.title = alarmTitle.text
        newAlarm.startdate = startDate.date
        newAlarm.enddate = endDate.date
        newAlarm.taken = false
        newAlarm.snoozeflag = snoozeSwitch.isOn
        newAlarm.repeatflag = repeatFlag.isOn
        newAlarm.time = timeformat.string(from: alarmTime.date)
        newAlarm.audio = audioFileName
        newAlarm.enabled = true
        self.alarms.append(newAlarm)
        self.saveData()
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapCancel() {
    }
    
    
    @IBAction func didTapShowAudioOptions(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapShowPicturesOptions(_ sender: Any) {
    }
    
    private func saveData () {
        do {
            try context.save()
        } catch {
            print("Error saving data.. \(error.localizedDescription)")
        }
    }
    
    //to show alerts
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}
