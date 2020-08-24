//
//  ViewController.swift
//  Reminder
//
//  Created by Sofiia Krasnokutska on 22.08.20.
//  Copyright © 2020 Sofiia Krasnokutska. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    @IBOutlet var table: UITableView!
    var models = [Reminder]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    @IBAction func didTapAdd() {
        guard let addVC = storyboard?.instantiateViewController(withIdentifier:  "add") as? AddViewController else {
            return
        }
        
        addVC.title = "Add New Reminder"
        addVC.completion = { title, body, date in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                let new = Reminder(title: title, date: date, identifier: "id_\(title)")
                self.models.append(new)
                self.table.reloadData()
                
                let content = UNMutableNotificationContent()
                content.title = title
                content.sound = .default
                content.body = body
                
                let targetDate = date
                let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month,
                .day, .hour, .minute, .second], from: targetDate), repeats: false)
                
                let request = UNNotificationRequest(identifier: "id", content: content, trigger: trigger)
                UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
                    if error != nil {
                        print("error")
                    }
                
                })
            }
        }
        navigationController?.pushViewController(addVC, animated: true)
        
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models[indexPath.row].title
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM, dd, YYYY"
        cell.detailTextLabel?.text = formatter.string(from: date)
        cell.textLabel?.font = UIFont(name: "Avenir Next", size: 25)
        cell.detailTextLabel?.font = UIFont(name: "Avenir Next", size: 22)
        return cell
        
    }
    
    
}

struct Reminder {
    let title: String
    let date: Date
    let identifier: String
}
