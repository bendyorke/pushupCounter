// Playground - noun: a place where people can play

import UIKit


let dateFormatter = NSDateFormatter()
dateFormatter.dateFormat = "MMM d, yyyy"
var date = dateFormatter.dateFromString("Jan 1, 2015")!
var today = NSDate()

var sev = abs(ceil(date.timeIntervalSinceNow / 60 / 60 / 24))

var dec = 1 / sev

Double(1)


round(1.53445 * 100) / 100.0

NSString(format: "%.2f", "1.2345")

