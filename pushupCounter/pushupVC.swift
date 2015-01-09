//
//  ViewController.swift
//  pushupCounter
//
//  Created by Ben Yorke on 1/6/15.
//  Copyright (c) 2015 Ben Yorke. All rights reserved.
//

import UIKit
import CoreData

class pushupVC: UIViewController {
    
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(NSDate())
    }
    
    var currentCount: Int? {
        return counter.text!.toInt()
    }
    
    @IBOutlet weak var counter: UILabel!
    
    @IBAction func increment(sender: AnyObject) {
        setCount(currentCount! + 1)
    }

    @IBAction func decrement(sender: AnyObject) {
        setCount(currentCount! - 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = formattedDate(NSDate())
        counter.text = String(fetchDay().valueForKey("count") as Int)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCount(newCount: Int) {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
        
        let day = fetchDay()
        
        day.setValue(newCount, forKey: "count")
        counter.text = String(newCount)
        context.save(nil)
    }
    
    func fetchDay() -> NSManagedObject {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
        
        let request = NSFetchRequest(entityName: "Day")
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "date = %@", startOfDay)
        var err: NSError?
        
        let results = context.executeFetchRequest(request, error: &err) as [NSManagedObject]?
        println(results)
        if (results!.count > 0) {
            return results![0]
        } else {
            return createDay(appDel, context: context)
        }
    }
    
    func createDay(appDel: AppDelegate, context: NSManagedObjectContext) -> NSManagedObject {
        let entity = NSEntityDescription.entityForName("Day", inManagedObjectContext: context)
        let day = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: context)
        var err: NSError?
        
        day.setValue(startOfDay, forKey: "date")
        day.setValue(0, forKey: "count")
        
        context.save(&err)
        
        return day
    }
    
    func formattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.stringFromDate(date)
    }

}
