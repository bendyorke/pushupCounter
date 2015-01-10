//
//  calTVC.swift
//  pushupCounter
//
//  Created by Ben Yorke on 1/9/15.
//  Copyright (c) 2015 Ben Yorke. All rights reserved.
//

import UIKit
import CoreData

class calTVC: UITableViewController {

    var delegate: pushupVC?
    
    var countPerDay: [String: Int] {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
    
        let request = NSFetchRequest(entityName: "Day")
        request.returnsObjectsAsFaults = false
        var err: NSError?
    
        let result = context.executeFetchRequest(request, error: &err) as [NSManagedObject]?
        let mapping = result!.reduce([String: Int]()) { (var dict: [String: Int], day) in
            let date = self.stringFromDate(day.valueForKey("date") as NSDate)
            let count = day.valueForKey("count") as Int
            dict[date] = count
            return dict
        }
    
        return mapping
    }
    
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func todayAndDismiss() {
        self.delegate?.day = NSDate()
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let section: Int = stringFromDate(self.delegate!.day, format: "M").toInt()! - 1
        let row: Int = stringFromDate(self.delegate!.day, format: "d").toInt()! - 1
        let indexPath = NSIndexPath(forRow: row, inSection: section)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Top, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 12
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let thisMonth = dateFromString("\(section+1)-1-2015")
        var nextMonth: NSDate
        if(section < 11) {
            nextMonth = dateFromString("\(section+2)-1-2015")
        } else {
            nextMonth = dateFromString("1-1-2016")
        }
        return Int(abs(thisMonth.timeIntervalSinceDate(nextMonth)/60/60/24))
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("day", forIndexPath: indexPath) as UITableViewCell
        let date = dateFromString("\(indexPath.section+1)-\(indexPath.row+1)-2015")
        let day = stringFromDate(date)
        cell.textLabel!.text = day
        
        if let count = countPerDay[day] {
            cell.detailTextLabel!.text = "\(count)"
        } else {
            cell.detailTextLabel!.text = "\(0)"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let date = dateFromString("\(section + 1)-1-2015")
        return stringFromDate(date, format: "MMMM")
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.day = dateFromString("\(indexPath.section+1)-\(indexPath.row+1)-2015")
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M-d-yyyy"
        return dateFormatter.dateFromString(string)!
    }
    
    func stringFromDate(date: NSDate, format: String = "MMM d, yyyy") -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.stringFromDate(date)
    }

}
