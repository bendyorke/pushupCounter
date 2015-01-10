// Playground - noun: a place where people can play

import UIKit


let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "M-d-yyyy"
var date = dateFormatter.dateFromString("1-1-2015")!
var nextDate = dateFormatter.dateFromString("2-1-2015")!
var today = NSDate()

abs(date.timeIntervalSinceDate(nextDate) / 60 / 60 / 24)

var sev = abs(ceil(date.timeIntervalSinceNow / 60 / 60 / 24))

var dec = 1 / sev

Double(1)


round(1.53445 * 100) / 100.0

NSString(format: "%.2f", "1.2345")

var dict = [String: Int]()
dict["hello world 11111111111111112345678234567834567"] = 1
dict

var opt: Int? = 2


var bang = (opt? != nil ? opt : 1)

class Tri {
    var day: NSDate {
        return NSDate()
    }
    
    func init() {
        println(day)
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "M-d-yyyy"
        self.day = dateFormatter.dateFromString("2-1-2015")!
    }
}