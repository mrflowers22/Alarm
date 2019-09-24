//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController, AlarmScheduler {

    var alarm: Alarm? {
        didSet {
           // loadViewIfNeeded()
            updateViews()
        }
    }
    var alarmIsOn: Bool {
        return alarm?.enabled ?? true
    }
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var enableButtonProperties: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
    }
    
    private func updateViews(){
        guard let passedInAlarm = alarm, isViewLoaded, let fireDate = passedInAlarm.fireDate else {
            self.title = "Please select a date."
            return }
        datePicker.setDate(fireDate, animated: true)
        nameTextField.text = passedInAlarm.name
        enableButtonProperties.setTitle(alarmIsOn ? "Off" : "On", for: .normal)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
    
        if let passedInAlarm = alarm {
            //update
        
            self.title = passedInAlarm.name
            print("\(datePicker.date)")
            
            AlarmController.sharedInstance.update(alarm: passedInAlarm, fireDate: datePicker.date, name: name, enabled: passedInAlarm.enabled)
            
        } else {
            AlarmController.sharedInstance.createAlarm(fireDate: datePicker.date, name: name, enabled: alarmIsOn)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        guard let passedInAlarm = alarm else { print("Error right here for alarm"); return }
        if passedInAlarm.enabled {
            scheduleUserNotifications(for: passedInAlarm)
        } else {
            cancelUserNotifications(for: passedInAlarm)
        }
        
        updateViews()
        //this would work but it would violate MVC adopt the alarmScheduler protocol
//        AlarmController.sharedInstance.toggleEnabled(for: passedInAlarm)
        
    }

}
