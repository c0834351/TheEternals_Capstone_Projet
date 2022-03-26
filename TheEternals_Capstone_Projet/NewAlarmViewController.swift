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
    @IBOutlet weak var alarmToneHStackView: UIStackView!
    @IBOutlet weak var picturesHStackView: UIStackView!
    @IBOutlet weak var repeatStackView: UIStackView!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    //Constraints
    @IBOutlet weak var weekdaysSVConstraint: NSLayoutConstraint!
    @IBOutlet weak var alarmToneHSHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var picturesHSHeightConstraint: NSLayoutConstraint!
    
    //TextFields
    @IBOutlet weak var alarmTitle: UITextField!
    
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
    @IBOutlet weak var showAudioOptionsBTN: UIButton!
    @IBOutlet weak var showPicturesOptionsBTN: UIButton!
    @IBOutlet weak var whentoTake: UIButton!
    
    //DatePickers
    @IBOutlet weak var alarmTime: UIDatePicker!
    @IBOutlet weak var startDate: UIDatePicker!
    @IBOutlet weak var endDate: UIDatePicker!
    
    var imagePicker = UIImagePickerController()
    var defaultWeekdaysSVheight = 0.0
    var defaultAudioOptionsSVheight = 0.0
    var defaultPicturesOptionsSVheight = 0.0
    var alarmToEdit: Alarm!
    private var recordingSession: AVAudioSession!
    private var recorder: AVAudioRecorder!
    private var player =  AVAudioPlayer()
    private var audioFileName = ""
    private var notificationimage: UIImage!
    private var alarmimages = [Images]()
    private var repeatdays = [Repeatdays]()
    private var newAlarm: Alarm!
    private var notificationpermissiongranted: Bool = false
    public var completion: ((Bool) -> Void)?


    var alarms = [Alarm]()

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert, .badge], completionHandler: {success, error in
            if(success){
                self.notificationpermissiongranted = true
            }else if error != nil{
                print("error occured")
            }
        })
        
        if(alarmToEdit != nil){
            self.title = "Edit Reminder"
            populateFields()
        }
        
        defaultWeekdaysSVheight = weekdaysSVConstraint.constant
        defaultAudioOptionsSVheight = alarmToneHSHeightConstraint.constant
        defaultPicturesOptionsSVheight = picturesHSHeightConstraint.constant
        
        sundayButton.layer.cornerRadius = sundayButton.frame.width/2
        mondayButton.layer.cornerRadius = mondayButton.frame.width/2
        TuesdayButton.layer.cornerRadius = TuesdayButton.frame.width/2
        wednesdayButton.layer.cornerRadius = wednesdayButton.frame.width/2
        thursdayButton.layer.cornerRadius = thursdayButton.frame.width/2
        fridayButton.layer.cornerRadius = fridayButton.frame.width/2
        saturdayButton.layer.cornerRadius = thursdayButton.frame.width/2
        
        weekdaysSVConstraint.constant = 0.0
        alarmToneHSHeightConstraint.constant = 0.0
        picturesHSHeightConstraint.constant = 0.0

        
        newAlarm = Alarm(context: self.context)
        startDate.minimumDate = Date()
        endDate.minimumDate = Date()
        datesVStackview.layer.cornerRadius = 8
        recordingSession = AVAudioSession.sharedInstance()
    }
    
    
    @IBAction func repeatFlagIsON(_ sender: UISwitch) {
        newAlarm.repeatflag = repeatFlag.isOn
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
            repeatdays.removeAll()
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
                        self.showAlert(message: "Microphone permission denied")
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
    
    
    @IBAction func cameraBtnClicked(_ sender: UIButton) {
    }
    
    
    @IBAction func galleryBtnClicked(_ sender: Any) {
    }
    
    
    
    @IBAction func didTapSave() {
        guard let name = alarmTitle.text, !name.isEmpty else{
            showAlert(message: "Title for Alarm is required")
            return
        }
        
        if (alarmToEdit == nil) {
        newAlarm.alarmid = UUID().uuidString
        newAlarm.title = alarmTitle.text
        newAlarm.startdate = startDate.date
        newAlarm.enddate = endDate.date
        newAlarm.snoozeflag = snoozeSwitch.isOn
        newAlarm.repeatflag = repeatFlag.isOn
        newAlarm.time = alarmTime.date
        newAlarm.audio = audioFileName
        newAlarm.enabled = true
        newAlarm.pictures = Set(alarmimages) as NSSet
        newAlarm.repeatdays = Set(repeatdays) as NSSet
        self.saveData()
        NotificationCenter.default.post(name: Notification.Name("alarm created"), object: nil)
        completion?(true)
        self.dismiss(animated: true, completion: nil)
        } else {
            alarmToEdit.title = alarmTitle.text
            alarmToEdit.startdate = startDate.date
            alarmToEdit.enddate = endDate.date
            alarmToEdit.snoozeflag = snoozeSwitch.isOn
            alarmToEdit.repeatflag = repeatFlag.isOn
            alarmToEdit.pictures = Set(alarmimages) as NSSet
            alarmToEdit.repeatdays = Set(repeatdays) as NSSet
            self.saveData()
        }
    }
    
    
    @IBAction func didTapCancel() {
        self.context.delete(newAlarm)
        do {
            try self.context.save()
            print("Deleted empty row")
        }catch{
            print("Error deleting record")
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapShowAudioOptions(_ sender: UIButton) {
    }
    
    
    @IBAction func didTapShowPicturesOptions(_ sender: Any) {
    }
    
    func populateFields(){
        alarmTitle.text = alarmToEdit.title
        alarmTime.date = alarmToEdit.time!
        startDate.date = alarmToEdit.startdate!
        endDate.date = alarmToEdit.enddate!
        repeatFlag.setOn(alarmToEdit.repeatflag, animated: true)
        snoozeSwitch.setOn(alarmToEdit.snoozeflag, animated: true)
        alarmimages = alarmToEdit.pictures?.allObjects as! [Images]
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let soundspath = paths.appendingPathComponent("Sounds")
        do {try FileManager.default.createDirectory(atPath: soundspath.path, withIntermediateDirectories: true, attributes: nil)}
        catch{
            print(error.localizedDescription)
        }
        return soundspath
    }
    
    private func getRecordingURL(_ fileName : String) -> URL {
        return getDocumentsDirectory().appendingPathComponent(fileName)
    }
    
    private func startRec() {
        audioFileName = "recording" + UUID().uuidString + ".caf"
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

    

