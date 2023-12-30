//
//  URLConstants.swift
//  YTS
//
//  Created by Sajith Konara on 4/25/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation

struct URLConstants {
    
    struct Api {
        static let HOST = "http://51.20.17.78"
        
        struct Path {
            
            static var postLogin:String{
                return HOST + "/auth/email/login"
            }
            
        }
    }
}
