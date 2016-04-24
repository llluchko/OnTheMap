//
//  SecondViewController.swift
//  OnTheMap
//
//  Created by Latchezar Mladenov on 3/22/16.
//  Copyright © 2016 Latchezar Mladenov. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: #selector(TableViewController.refresh))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(TableViewController.add))
   
        getStudentLocations()
    }

    func getStudentLocations() {
        ParseClient.sharedInstance().getLocations() { (result, error) in
            if let results = result {
                StudentStoredData.sharedInstance().locations = results
                performUIUpdatesOnMain() {
                    self.tableView.reloadData()
                }
            } else {
                performUIUpdatesOnMain() {
                    self.alert(error!)
                }
            }
        }
    }
    
    func refresh() {
        getStudentLocations()
    }
    
    func add() {
        let controller = self.storyboard?.instantiateViewControllerWithIdentifier("AddStudentLocation")
        self.presentViewController(controller!, animated: true, completion: nil)
    }
    
    func alert(text: String) {
        let alertView = UIAlertView()
        alertView.message = text
        alertView.addButtonWithTitle("OK")
        alertView.show()
    }

}

extension TableViewController {
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentStoredData.sharedInstance().locations.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("cell")!
        let studentLocation = StudentStoredData.sharedInstance().locations[indexPath.row]
        cell.textLabel?.text = "\(studentLocation.firstName) \(studentLocation.lastName)"
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named: "pin")
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let url = NSURL(string: StudentStoredData.sharedInstance().locations[indexPath.row].mediaURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}














