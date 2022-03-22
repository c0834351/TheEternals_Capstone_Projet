//
//  AlarmsViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Sravan Sriramoju on 2022-03-20.
//

import UIKit
import CoreData

class AlarmsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var searchBar: UISearchBar!
    

    @IBOutlet weak var allAlarmsTV: UITableView!
    var cellimage:UIImage!
    
    private var allalarms = [Alarm]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.backgroundImage = UIImage()
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(allalarms.count == 0){
            self.allAlarmsTV.setEmptyMessage("No alarms created")
        } else {
            allAlarmsTV.restore()
        }
        return allalarms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmcell", for: indexPath) as! AlarmCellTableViewCell
        if let imagedata = allalarms[indexPath.row].value(forKey: "image1") as? Data{
            cellimage = UIImage(data: imagedata)
        }
        
        cell.setCell(picture: cellimage, timeValue: allalarms[indexPath.row].time ?? "", afterFoodValue: allalarms[indexPath.row].whentotake ?? "", medicinesValue: allalarms[indexPath.row].title ?? "", enabledValue: allalarms[indexPath.row].enabled)
        return cell
    }
    
    private func getAlarms(){
        let request:NSFetchRequest<Alarm> = Alarm.fetchRequest()
        do {
            self.allalarms = try context.fetch(request)
        } catch {
            print("Error load items ... \(error.localizedDescription)")
        }
    }

}

extension UITableView {

    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont(name: "TrebuchetMS", size: 15)
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
