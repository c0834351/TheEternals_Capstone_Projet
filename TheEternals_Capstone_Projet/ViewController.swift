//
//  ViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Ashish reddy mula on 14/03/22.
//

import UIKit
import CoreData
import WhatsNewKit

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource, todayCellDelegate  {
    
    func didChangeSwitch(with id: String, enabled: Bool) {
        var curralarm: Alarm!
        for alarm in allalarms{
            if(alarm.alarmid == id){
                curralarm = alarm
                alarm.enabled = enabled
            }
        }
        do {
            try context.save()
        } catch{
            print("error updating alarm")
        }
        if (!enabled){
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
        } else {
            CreateReminder(alarm: curralarm)
        }
    }
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ampmLabel: UILabel!
    
    @IBOutlet weak var todayAlarmsTV: UITableView!
    private var upcomingalarms = [Alarm]()
    private var allalarms = [Alarm]()
    private var todayDate = Date()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private let floatingAddButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.backgroundColor = .systemBlue
        
        let image = UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(pointSize: 27, weight: .medium))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.layer.shadowRadius = 10
        button.layer.shadowOpacity = 0.1
        //button.layer.masksToBounds = true
        button.layer.cornerRadius = 25
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
        
        view.addSubview(floatingAddButton)
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true){ (_) in
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss"
            let currentTime:String? = dateFormatter.string(from: date)
            let dateFormatter2 = DateFormatter()
            dateFormatter2.dateFormat = "MMM d, yyyy"
            let currentDate:String? = dateFormatter2.string(from: date)
            let dateFormatter3 = DateFormatter()
            dateFormatter3.dateFormat = "a"
            let amPM:String? = dateFormatter3.string(from: date)
            
            if let time = currentTime, let currdate = currentDate, let am = amPM{
            self.timeLabel.text = time
            self.dateLabel.text = currdate
            self.ampmLabel.text = am
            }
            
        }
        floatingAddButton.addTarget(self, action: #selector(didTapAdd), for: .touchUpInside)
        
        getUpcomingAlarms()
    }
    
    @objc func alarmCreated() {
        todayAlarmsTV.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        todayAlarmsTV.reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingAddButton.frame = CGRect(x: view.frame.width-80,
                                         y: view.frame.height-170,
                                         width: 50,
                                         height: 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(upcomingalarms.count == 0){
            self.todayAlarmsTV.setEmptyMessage("That's all for Today")
        } else {
            todayAlarmsTV.restore()
        }
        return upcomingalarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellimage:UIImage!
        var celltime:String = ""
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayAlarmCell", for: indexPath) as! TodayAlarmCell
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        if let v = upcomingalarms[indexPath.row].time {
            celltime = timeFormatter.string(from: v)
        }
        let pics = upcomingalarms[indexPath.row].pictures?.allObjects as! [Images]
        if (pics.count > 0){
        if let imageData = pics[0].image{
            cellimage = UIImage(data:imageData,scale:0.1)
        }
        }
        cell.delegate = self
        cell.setCell(picture: cellimage ?? UIImage(), timeValue: celltime, afterFoodValue: upcomingalarms[indexPath.row].whentotake ?? "", medicinesValue: upcomingalarms[indexPath.row].title ?? "", enabledValue: upcomingalarms[indexPath.row].enabled, alarmid: upcomingalarms[indexPath.row].alarmid ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? NewAlarmViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: vc)
        vc.alarmToEdit = upcomingalarms[indexPath.row]
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    @objc func didTapAdd() {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? NewAlarmViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: vc)
        vc.completion = { created in
            if(created){
                    self.viewDidAppear(true)
                    self.todayAlarmsTV.reloadData()
            }
        }
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func getUpcomingAlarms(){
        let request:NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do {
            self.allalarms = try context.fetch(request)
        } catch {
            print("Error load items ... \(error.localizedDescription)")
        }
        
        for alarm in allalarms {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "hh:mm a"
            let now = Date()
            if let alarmtime = alarm.time, alarmtime >= now {
                upcomingalarms.append(alarm)
            }
        }
        todayAlarmsTV.reloadData()
        
    }
    
    func CreateReminder(alarm: Alarm) {
        var notificationimage: UIImage!
        var alarmimages = [Images]()
        DispatchQueue.main.async {
        let content = UNMutableNotificationContent()
        content.title = "MedAlarm Reminder"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(alarm.audio ?? ""))
        content.body = "Time to have \(alarm.title ?? "")"
        alarmimages = alarm.pictures?.allObjects as! [Images]
        if (!alarmimages.isEmpty){
            notificationimage = self.resizeImage(image: UIImage(data: alarmimages[0].image!)!, targetSize: CGSize(width: 800, height: 800))
        }
        if let notifpic = notificationimage {
            if let attachment = UNNotificationAttachment.create(identifier: alarm.title ?? "", image: notifpic, options: nil) {
            content.attachments = [attachment]
        }
        }
            let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: alarm.time!), repeats: false)
            if let id = alarm.alarmid {
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
            if(error != nil){
                print(error?.localizedDescription ?? "")
            }
        })
        }
    }
}
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }


}
