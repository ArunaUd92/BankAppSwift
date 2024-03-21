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
            
            static var postAddPayer:String{
                return HOST + "/payers/payer/add"
            }
            
            static var getPayerList:String{
                return HOST + "/payers/user/%@"
            }
            
            static var deletePayee:String{
                return HOST + "/payers/payer/%@"
            }
            
            static var getAllTransactionList:String{
                return HOST + "/transactions/user/%@"
            }
            
            static var postTransaction:String{
                return HOST + "/transactions/payment/add"
            }
            
            static var getCustomerList:String{
                return HOST + "/users/list"
            }
            
            static var deleteCustomer:String{
                return HOST + "/users/user/%@"
            }
        }
        
    }
}
