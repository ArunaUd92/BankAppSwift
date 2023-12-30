//
//  MessageView.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation
import UIKit
import SwiftMessages

class MessageViewPopUp {
    
    // Message Type
    static let ErrorMessage = 1
    static let InfoMessage = 2
    static let WarningMessage = 3
    static let SuccessMessage = 4
    
    // Show Message - validation & Errors
    static func showMessage(type: Int, title: String, message: String) {
        if !message.isEmpty {
            let error = MessageView.viewFromNib(layout: .messageView)
            var config = SwiftMessages.defaultConfig
            config.presentationContext = .window(windowLevel: UIWindow.Level.normal)
            
            switch type {
            case ErrorMessage:
                error.configureTheme(.error)
                error.configureTheme(backgroundColor: UIColor.init(hexString: "#C4014B", alpha: 1), foregroundColor: UIColor.white, iconImage: UIImage(named:"la_warning.png"), iconText: nil)
                error.titleLabel?.isHidden = true
                
            case InfoMessage:
                error.configureTheme(.info)
                
            case WarningMessage:
                error.configureTheme(.warning)
                
            case SuccessMessage:
                error.configureTheme(.success)
                
            default:
                error.configureTheme(.info)
            }
            
            error.configureContent(title: "", body: message)
            error.button?.setTitle("Stop", for: .normal)
            error.button?.isHidden = true
            
            SwiftMessages.show(config: config, view: error)
        }
    }

}
