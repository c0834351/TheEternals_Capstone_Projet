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
        var celltime:String = ""
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm"
        if let v = allalarms[indexPath.row].time {
            celltime = timeFormatter.string(from: v)
        }
        cell.setCell(picture: cellimage, timeValue: celltime, afterFoodValue: allalarms[indexPath.row].whentotake ?? "", medicinesValue: allalarms[indexPath.row].title ?? "", enabledValue: allalarms[indexPath.row].enabled)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "add") as? NewAlarmViewController else {
            return
        }
        let navigationController = UINavigationController(rootViewController: vc)
        navigationController.modalPresentationStyle = .fullScreen
        vc.alarmToEdit = allalarms[indexPath.row]
        self.present(navigationController, animated: true, completion: nil)
        
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

extension AlarmsViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            getAlarms()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }else{
            searchAlarms(searchText: searchText)
        }
    }
    
    func searchAlarms( searchText: String){
        
        let request:NSFetchRequest<Alarm> = Alarm.fetchRequest()
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchText)
        print(searchText)
        request.predicate = predicate
        do {
            self.allalarms = try context.fetch(request)
        } catch
        let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        allAlarmsTV.reloadData()
    }
    
}
