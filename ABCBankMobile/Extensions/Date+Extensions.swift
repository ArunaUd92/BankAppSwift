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

}
