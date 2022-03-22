//
//  NewAlarmViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sai Snehitha Bhatta on 20/03/22.
//

import UIKit
import CoreData
import AVFoundation

class NewAlarmViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate  {
    
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
    
    var imagePicker = UIImagePickerController()
    var defaultWeekdaysSVheight = 0.0
    var defaultAudioOptionsSVheight = 0.0
    var defaultPicturesOptionsSVheight = 0.0
    private var recordingSession: AVAudioSession!
    private var recorder: AVAudioRecorder!
    private var player =  AVAudioPlayer()
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
        
        newAlarm = Alarm(context: self.context)
        startDate.minimumDate = Date()
        endDate.minimumDate = Date()
        defaultWeekdaysSVheight = weekdaysSVConstraint.constant
        weekdaysSVConstraint.constant = 0.0
        datesVStackview.layer.cornerRadius = 8
        
    }
    
    
    @IBAction func repeatFlagIsON(_ sender: UISwitch) {
        if (repeatFlag.isOn){
            let bIsHidden = weekdaysStackView.isHidden

            if bIsHidden {
                weekdaysStackView.isHidden = false
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.weekdaysSVConstraint.constant = self.weekdaysSVConstraint.constant > 0 ? 0 : self.defaultWeekdaysSVheight
                self.view.layoutIfNeeded()
            })
        } else {
            let bIsHidden = weekdaysStackView.isHidden
            
            if !bIsHidden {
                weekdaysStackView.isHidden = true
            }

            UIView.animate(withDuration: 0.3, animations: {
                self.weekdaysSVConstraint.constant = 0.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func snoozeSwitchTapped(_ sender: UISwitch) {
    }
    
    
    
    @IBAction func recordBtnClicked(_ sender: UIButton) {
        if (recordBtnLB.titleLabel?.text == "Record"){
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.startRec()
                    } else {
                        showAlert(message: "Microphone permission denied")
                    }
                }
            }
        } catch {
            showAlert(message: "Recording failed")
        }
        }
        else {
            print("recorder is nil")
            recorder?.stop()
            recorder = nil
            recordBtnLB.setTitle("Record", for: .normal)
            recordBtnLB.setImage(UIImage(systemName: "mic.fill"), for: .normal)
        }
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
        guard let name = alarmTitle.text else{
            showAlert(message: "Title for Alarm is required")
            return
        }
        let timeformat = DateFormatter()
        timeformat.dateFormat = "hh:mm a"
        newAlarm.title = name
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
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapShowAudioOptions(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapShowPicturesOptions(_ sender: Any) {
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    private func getRecordingURL(_ fileName : String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func startRec() {
        audioFileName = "recording" + UUID().uuidString + ".m4a"
        let audioURL = getRecordingURL(audioFileName)
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        do {
            recorder = try AVAudioRecorder(url: audioURL, settings: settings)
            recorder.delegate = self
            recorder.record()
            recordBtnLB.setImage(UIImage(systemName: "mic.slash.fill"), for: .normal)
            recordBtnLB.setTitle("Stop", for: .normal)
            print("start recording")
        } catch {
            print("Error in recording \(error.localizedDescription)")
        }
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

    

