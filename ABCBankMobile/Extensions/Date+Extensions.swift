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
    
    func convertDateString(from input: String) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

        guard let date = inputFormatter.date(from: input) else {
            return nil
        }

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd MMM yyyy"
        
        return outputFormatter.string(from: date)
    }
    

}
