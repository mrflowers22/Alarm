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
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Error performing fetchrequest: \(error)")
        }
        //7. return fetchedResultsController
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //I dont think I have to do this
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
//        return AlarmController.sharedInstance.alarms.count
        return fetchedResultsController.fetchedObjects?.count ?? 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as!  SwitchTableViewCell
//        let alarm = AlarmController.sharedInstance.alarms[indexPath.row]
//        cell.textLabel?.text = alarm.fireTimeAsString
//        cell.detailTextLabel?.text = alarm.name
        let alarm = fetchedResultsController.object(at: indexPath)
        
        cell.alarm = alarm
        cell.delegate = self
        cell.updateViews()
        // Configure the cell...
        return cell
    }
    

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //delete from data source of truth
//            let alarmToDelete = AlarmController.sharedInstance.alarms[indexPath.row]
           let alarmToDelete = fetchedResultsController.object(at: indexPath) 
            AlarmController.sharedInstance.delete(alarm: alarmToDelete)
            // Delete the row from the data source
//            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellSelected" {
            guard let destinationVC = segue.destination as? AlarmDetailTableViewController, let index = tableView.indexPathForSelectedRow else { return }
//            let alarmToPass = AlarmController.sharedInstance.alarms[index.row]
            let alarmToPass = fetchedResultsController.object(at: index)
            destinationVC.alarm = alarmToPass
        }
        
    }
}

extension AlarmListTableViewController: SwitchTableViewCellDelegate {
    func switchCellSwitchValueChanged(cell: SwitchTableViewCell) {
        //find the index of the cell that was selected
        guard let index = tableView.indexPath(for: cell) else { return }
        //find the model at the index
//        let alarmToToggle = AlarmController.sharedInstance.alarms[index.row]
        let alarmToToggle = fetchedResultsController.object(at: index)
        //toggle the model at the cell
        AlarmController.sharedInstance.toggleEnabled(for: alarmToToggle)
        //reload the table view
        tableView.reloadData()
    }
    
}

extension AlarmListTableViewController {
    //MARK: NSFRC Delegate Methods.
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //what do we want to do to the table view based on the change type?
        switch type {

        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            //insert a cell when we add a model object
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        case .move:
            //we need both indexpaths, from indexpath to newIndexpath
            guard let indexPath = indexPath, let newIndexPath = newIndexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .automatic)
        default:
            break
        }
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {

        switch type {
        case .insert:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.insertSections(indexSet, with: .automatic)
        case .delete:
            let indexSet = IndexSet(integer: sectionIndex)
            tableView.deleteSections(indexSet, with: .automatic)
        default:
            break
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
