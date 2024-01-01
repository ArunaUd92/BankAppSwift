//
//  ValidatorHelper.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation

class ValidatorHelper: NSObject {
    
    static func validateEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    static func formatAsCurrency(_ amount: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "£"
        formatter.maximumFractionDigits = 2 // For two decimal places
        formatter.minimumFractionDigits = 2 // Ensure there are always two decimal places
        formatter.usesGroupingSeparator = true // For comma separation
        formatter.locale = Locale(identifier: "en_UK") // Optional: to ensure UK-style formatting

        return formatter.string(from: NSNumber(value: amount)) ?? ""
    }
    
}
