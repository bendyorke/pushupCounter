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
    
    var overrideDate: NSDate?
    var count: Int?
    
    var day: NSDate {
        get {
            if self.overrideDate? != nil {
                return self.overrideDate!
            } else {
                return NSDate()
            }
        }
        set(date) {
            self.overrideDate = date
            loadDay()
        }
    }
    
    var startOfDay: NSDate {
        return NSCalendar.currentCalendar().startOfDayForDate(day)
    }
    
    var currentCount: Int? {
        return counter.text!.toInt()
    }
    
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var motivation: UILabel!
    
    @IBAction func increment(sender: AnyObject) {
        setCount(currentCount! + 1)
    }

    @IBAction func decrement(sender: AnyObject) {
        setCount(currentCount! - 1)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDay()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "cal") {
            var dvc = (segue.destinationViewController.viewControllers as [AnyObject])[0] as calTVC
            dvc.delegate = self
        }
    }
    
    func loadDay() {
        title = formattedDate(day)
        self.count = fetchDay().valueForKey("count") as? Int
        counter.text = String(self.count!)
        motivation.text = motivationalExpression()
    }
    
    func setCount(newCount: Int) {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
        
        let day = fetchDay()
        
        day.setValue(newCount, forKey: "count")
        self.count = newCount
        counter.text = String(newCount)
        motivation.text = motivationalExpression()
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
    
    func motivationalExpression() -> String {
        let appDel = UIApplication.sharedApplication().delegate as AppDelegate
        let context = appDel.managedObjectContext!
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        
        let request = NSFetchRequest(entityName: "Day")
        request.returnsObjectsAsFaults = false
        var err: NSError?
        
        let totalPushups = (context.executeFetchRequest(request, error: &err) as [NSManagedObject]?)!
            .map { $0.valueForKey("count") as Int }
            .reduce(0, +)

        let date: NSDate = dateFormatter.dateFromString("Jan 1, 2016")!
        let daysInYear: Double = abs(ceil(date.timeIntervalSinceNow / 60 / 60 / 24))
        let avgPerDay = Int(ceil(Double(20000 - totalPushups) / daysInYear))
        
        if self.count != nil {
            if self.count! < avgPerDay {
                return "Do \(avgPerDay - self.count!) more pushups to stay on track!"
            } else {
                return "Yeah I know we all complain about the pain when it ends"
            }
        } else {
            return "Do \(avgPerDay) pushups to stay on track!"
        }
    }
    
    func formattedDate(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.stringFromDate(date)
    }

}

