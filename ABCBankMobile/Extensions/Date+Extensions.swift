//
//  Date+Extensions.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import Foundation

extension Date{
    
    func getDescriptiveDateString() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d, yyyy"
        let todayDate = Date()
        return  dateFormatter.string(from: todayDate)
    }
    
    func convertDateString(_ dateString: String) -> String? {
        // DateFormatter to convert the string to a Date object
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MM-yyyy"

        // Convert the string to a Date
        guard let date = inputFormatter.date(from: dateString) else {
            return nil
        }

        // DateFormatter to convert the Date object back to a string
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy" // e.g., "18 Sep 2023"

        // Convert the Date back to a string
        return outputFormatter.string(from: date)
    }

}
