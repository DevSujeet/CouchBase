//
//  Double+Kformatted.swift
//  Cuddle
//
//  Created by Sujeet.Kumar on 3/10/16.
//  Copyright © 2016 Fractal Analytics Inc. All rights reserved.
//

import Foundation
//import Charts

enum valueFormatterType {
    case Indian
    case Western
}

protocol valueFormatterTypeProtocol {
    var formatterType:valueFormatterType {get set}
}

extension Double  {
    ///computed value for numerical values in verbal terms.
    var westFormatted: String {
        if self >= 999999999.9 {
            return String(format:"%.1fB",self/1000000000)
        } else if self >= 999999.9 {
            return String(format:"%.1fM",self/1000000)
        } else if self >= 10 || self <= -10 { //greater than 10 or less than -10
            return String(format: self >= 1000 ? "%.1fK" : "%.0f", self >= 1000 ? self/1000 : self)
        }else if self >= 1 || self <= -1 { //greater than 1 or less than -1
            if self.truncatingRemainder(dividingBy: 1) != 0 {
                return String(format:"%.1f",self)
            }
            else {
                return String(format:"%.0f",self)
                
            }
        }else if self == 0 {
            return String(format: "%.0f",self)
        }else if self < 1 || self > -1 { //bw -1 to 1
            return String(format: "%.1f",self)  //upto two decimal place.
        }
        return ""
    }
    
    var IndFormatted: String {
        if self >= 9999999999.9 {
            return String(format:"%.2fAr",self/10000000000)
        } else if self >= 9999999.9 {
            return String(format:"%.1fCr",self/10000000)
        } else if self >= 99999.9 {
            return String(format:"%.0fLk",self/100000)
        } else if self >= 10 || self <= -10 { //greater than 10 or less than -10
            return String(format: self >= 1000 ? "%.1fK" : "%.0f", self >= 1000 ? self/1000 : self)
        }else if self >= 1 || self <= -1 { //greater than 1 or less than -1
            if self.truncatingRemainder(dividingBy: 1) != 0 {
                return String(format:"%.1f",self)
            }
            else {
                return String(format:"%.0f",self)
                
            }
        }else if self == 0 {
            return String(format: "%.0f",self)
        }else if self < 1 || self > -1 { //bw -1 to 1
            return String(format: "%.1f",self)  //upto two decimal place.
        }
        return ""
    }
}

/// A custom formatter for the graphs to show the large numberical values in readable form.
//class customLargeValueFormater:NumberFormatter,IAxisValueFormatter {
//
//    override func string(from number: NSNumber) -> String? {
//        
//        let output = number.doubleValue.westFormatted
//        
//        return output
//    }
//    
//    //IAxisValueFormatter
//    func stringForValue(_ value: Double,
//                        axis: AxisBase?) -> String{
//        let output = value.westFormatted
//        return output
//    }
//}

//class ChartDisplayValueFormatter:NumberFormatter {
//    
//    override func string(for obj: Any?) -> String? {
//        let chartDataEntry = obj as! ChartDataEntry
//        if (chartDataEntry.data != nil) {
//            return (chartDataEntry.data as! String)
//        } else {
//            let output = chartDataEntry.x.westFormatted
//            return output
//        }
//    }
//}

