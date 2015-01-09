//
//  statsTVC.swift
//  pushupCounter
//
//  Created by Ben Yorke on 1/8/15.
//  Copyright (c) 2015 Ben Yorke. All rights reserved.
//

import UIKit
import CoreData

class statsTVC: UITableViewController {

    var stats: [String: String] {
        return [
          "Total Pushups": "\(totalPushups())",
          "Avg Pushups per Day": "\(avgPushupsPerDay())"
        ]
    }
    
    var days: [NSManagedObject]? {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Day")
        request.returnsObjectsAsFaults = false
        var err: NSError?
        
        return context.executeFetchRequest(request, error: &err) as [NSManagedObject]?
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalPushups()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func totalPushups() -> Int {
        return days!
            .map { $0.valueForKey("count") as Int }
            .reduce(0, +)
    }
    
    func avgPushupsPerDay() -> Double {
        var date: NSDate = dateFromString("Jan 1, 2015")
        var daysInYear: Double = abs(ceil(date.timeIntervalSinceNow / 60 / 60 / 24))
        return (round((Double(totalPushups()) / daysInYear) * 100)) / 100.0
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.stats.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("stat") as UITableViewCell
        var key: String = [String](self.stats.keys)[indexPath.row]
        cell.textLabel?.text = key
        cell.detailTextLabel?.text = self.stats[key]
        
        return cell
    }
    
    func dateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.dateFromString(string)!
    }
}
