//
//  SwitchTableViewCell.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit

protocol SwitchTableViewCellDelegate: class {
    func switchCellSwitchValueChanged(cell:  SwitchTableViewCell)
}

class SwitchTableViewCell: UITableViewCell {
    weak var delegate: SwitchTableViewCellDelegate?
    var alarm: Alarm?{
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    @IBAction func switchValueChanged(_ sender: UISwitch) {
        delegate?.switchCellSwitchValueChanged(cell: self)
    }
    
    private func updateViews(){
        guard let passedInAlarm = alarm else { return }
        timeLabel.text = passedInAlarm.fireTimeAsString
        nameLabel.text = passedInAlarm.name
        alarmSwitch.isOn = passedInAlarm.enabled
    }
    
}
