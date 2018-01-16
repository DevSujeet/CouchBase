//
//  Utility.swift
//  CouchbaseProject
//
//  Created by Sujeet.Kumar on 1/15/18.
//  Copyright © 2018 Sujeet.Kumar. All rights reserved.
//

import Foundation

class Utility {
    
    static func toDate(_ timeInMilliseconds: CLongLong) -> Date {
        let date = Date(timeIntervalSince1970: TimeInterval(Double(timeInMilliseconds)/1000))
        return date
    }
    
    static func toTimeInMilliseconds(_ date: Date) -> Int64 {
        return Int64(date.timeIntervalSince1970 * 1000)
    }
    
    //MARK:- date string.
    static func stringToDate(with dateString:String, format:String) ->Date? {
        let strTime = dateString//"2015-07-27 19:29:50 +0000"
        let formatter = DateFormatter()
        formatter.dateFormat = format //"yyyy-MM-dd HH:mm:ss Z"
        let date = formatter.date(from: strTime)
        return date
    }
    
    static func dateToString(format:String, date:Date) -> String { //http://nsdateformatter.com/
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.short
        formatter.timeStyle = .medium
        let gbDateFormat = DateFormatter.dateFormat(fromTemplate: format, options: 0, locale: Locale.current)
        
        formatter.dateFormat = gbDateFormat
        return "\(formatter.string(from: date))"
    }
}
