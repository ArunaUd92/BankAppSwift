//
//  URLConstants.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation

struct URLConstants {
    
    struct Api {
        static let HOST = "http://51.20.17.78"
        
        struct Path {
            
            static var postLogin:String{
                return HOST + "/auth/email/login"
            }
            
            static var postRegister:String{
                return HOST + "/auth/email/register"
            }
            
            static var getVerificationCode:String{
                return HOST + "/auth/email/verify/%@"
            }
            
            static var getResendCode:String{
                return HOST + "/auth/email/resend-verification/%@"
            }
            
            static var getUserDetails:String{
                return HOST + "/users/user/%@"
            }
            
            static var postProfileUpdate:String{
                return HOST + "/users/profile/update"
            }
            
            
        }
        
    }
}
