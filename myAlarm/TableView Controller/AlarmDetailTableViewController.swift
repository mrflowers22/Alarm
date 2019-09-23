//
//  AlarmDetailTableViewController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    var alarm: Alarm? {
        didSet {
            loadViewIfNeeded()
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

    }
    
    private func updateViews(){
        guard let passedInAlarm = alarm, let fireDate = passedInAlarm.fireDate else { return }
        datePicker.setDate(fireDate, animated: true)
        nameTextField.text = passedInAlarm.name
        enableButtonProperties.setTitle(passedInAlarm.enabled ? "Off" : "On", for: .normal)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text, !name.isEmpty else { return }
        if let passedInAlarm = alarm {
            //update
            self.title = passedInAlarm.name
            AlarmController.sharedInstance.update(alarm: passedInAlarm, fireDate: datePicker.date, name: name, enabled: passedInAlarm.enabled)
            
        } else {
            self.title = "Please select a date."
            AlarmController.sharedInstance.createAlarm(fireDate: datePicker.date, name: name, enabled: alarmIsOn)
        }
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func enableButtonTapped(_ sender: UIButton) {
        
    }

}
