//
//  LoginViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation
import RxSwift

class LoginViewModel{
    
    // MARK: Properties
    // Email and password properties for the login credentials.
    var email: String? = ""
    var password: String? = ""
    
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Common service model for making network requests.
    fileprivate var commonServiceModel = CommonServiceModel()
    // Flag to indicate if the logged-in user is an admin.
    var isAdminStatus: Bool = false
    
    // MARK: Functions
    
    // Validates the login fields.
    func loginValidation(validationHandler: (String, Bool)->()) {
        // Checks if the email field is not empty.
        guard let email = email, !email.isEmpty else {
            validationHandler("Email field cannot be empty.", false)
            return
        }
        
        // Validates the email format.
        if !ValidatorHelper.validateEmail(email: email){
            validationHandler("Email is invalid.", false)
            return
        }
        
        // Checks if the password field is not empty.
        guard let password = password, !password.isEmpty else {
            validationHandler("Password field cannot be empty.", false)
            return
        }
        
        // If all validations pass, a success message is returned.
        validationHandler("Validation Success", true)
    }
    
    // Performs the login operation.
    func userLoginInfo(onCompleted:@escaping(_ statusCode: Int?, Observable<Error?>)->Void){
        // Calls the service to log in the user with the provided credentials.
        commonServiceModel.loginService(email: email ?? "", password: password ?? "") { (loginDataObservable) in
            loginDataObservable.subscribe(onNext: { (loginData, error) in
                // Processes the response from the service.
                if let loginInfo = loginData{
                    if loginInfo.success {
                        // Stores the token and user information upon successful login.
                        UserSessionManager.sharedInstance.saveToken(loginInfo.data.token!)
                        UserSessionManager.sharedInstance.saveUser(loginInfo.data.user!)
                        // Checks if the user is an admin.
                        if loginInfo.data.user?.roles[0] == "Admin"{
                            self.isAdminStatus = true
                        }
                        // Returns the status code 200 for successful login.
                        onCompleted(200, Observable.just(nil))
                    } else {
                        // Returns the status code 403 for unsuccessful login.
                        onCompleted(403, Observable.just(nil))
                    }
                } else {
                    // Returns the status code 400 in case of an unexpected error.
                    onCompleted(400, Observable.just(error!))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
}
