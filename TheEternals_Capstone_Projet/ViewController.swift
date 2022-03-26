//
//  ViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Ashish reddy mula on 14/03/22.
//

import UIKit

class ViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var ampmLabel: UILabel!
    
    @IBOutlet weak var todayAlarmsTV: UITableView!
    private var upcomingalarms = [Alarm]()
    
    let pictures: [UIImage] = [UIImage(named: "dolo.jpg")!,UIImage(named: "hcq.jpg")!]
    let time: [String] = ["17:00", "18:00"]
    let afterFood: [String] = ["After Food", "Before Food"]
    let medicines: [String] = ["Dolo 650", "HCQ - 200"]
    let enabled: [Bool] = [true, false]
    
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
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        floatingAddButton.frame = CGRect(x: view.frame.width-80,
                                         y: view.frame.height-170,
                                         width: 50,
                                         height: 50)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todayAlarmCell", for: indexPath) as! TodayAlarmCell
        cell.setCell(picture: pictures[indexPath.row], timeValue: time[indexPath.row], afterFoodValue: afterFood[indexPath.row], medicinesValue: medicines[indexPath.row], enabledValue: enabled[indexPath.row])
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
        self.present(navigationController, animated: true, completion: nil)
    }


}

