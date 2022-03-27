//
//  HistoryViewController.swift
//  TheEternals_Capstone_Projet
//
//  Created by Keerthi Pavan Valluri on 2022-03-26.
//

import UIKit

class HistoryViewController: UIViewController {

    //TableViews
    @IBOutlet weak var historyTV: UITableView!
    
    //Buttons
    @IBOutlet weak var sortbyBTN: UIButton!
    
    var alarmhistory = [History]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "History"
        // Do any additional setup after loading the view.
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [UIColor.systemBlue.cgColor, UIColor.systemGray3.cgColor]

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    

}


extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (alarmhistory.count == 0){
            self.historyTV.setEmptyMessage("")
        } else {
            historyTV.restore()
        }
        return alarmhistory.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historycell", for: indexPath) as! AlarmHistoryCell
        
        return cell
    }
}
