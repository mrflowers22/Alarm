//
//  AlarmListTableViewController.swift
//  myAlarm
//
//  Created by Michael Flowers on 9/23/19.
//  Copyright © 2019 trevorAdcock. All rights reserved.
//

import UIKit
import CoreData

class AlarmListTableViewController: UITableViewController,  NSFetchedResultsControllerDelegate {

    lazy var fetchedResultsController: NSFetchedResultsController<Alarm> =  {
        //1. set up the fetch request
        let fetchRequest: NSFetchRequest<Alarm> = Alarm.fetchRequest()
        //2. set up sortDiscriptors - Optional
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //3. get the moc
        let moc = CoreDataStack.shared.mainContext
        //4. initialize the fetchedResultsController
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        //5. set this class as the  delegate of fetchedResultController
        fetchedResultsController.delegate = self
        //6. perform fetch
        try? fetchedResultsController.performFetch()
        //7. return fetchedResultsController
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return AlarmController.sharedInstance.alarms.count
//        return fetchedResultsController.fetchedObjects?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as!  SwitchTableViewCell
        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
//        let alarm = fetchedResultsController.object(at: indexPath)
//        cell.textLabel?.text = alarm.fireTimeAsString
//        cell.detailTextLabel?.text = alarm.name
        cell.alarm = alarm
        // Configure the cell...
        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete from data source of truth
            let alarmToDelete = AlarmController.sharedInstance.alarms[indexPath.row]
            AlarmController.sharedInstance.delete(alarm: alarmToDelete)
            
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSelected" {
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController, let index = tableView.indexPathForSelectedRow else { return }
            let alarmToPass = AlarmController.sharedInstance.alarms[index.row]
            destinationVC.alarm = alarmToPass
        }
        
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        //find the index of the cell that was selected
        guard let index = tableView.indexPath(for: cell) else { return }
        //find the model at the index
        let alarmToToggle = AlarmController.sharedInstance.alarms[index.row]
        //toggle the model at the cell
        AlarmController.sharedInstance.toggleEnabled(for: alarmToToggle)
        //reload the table view
        tableView.reloadData()
    }
    
    
}
