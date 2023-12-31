//
//  SignupViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import Foundation
import RxSwift

class SignupViewModel{
    
    // MARK: Properties
    var email: String? = ""
    var password: String? = ""
    var confirmPassword: String? = ""
    var name: String? = ""
    var surName: String? = ""
    
    fileprivate let bag = DisposeBag()
    fileprivate var commonViewModel = CommonViewModel()
    
    // MARK: Functions
    // signup validation
    func signupValidation(validationHandler: (String, Bool)->()) {
        guard let name = name, !name.isEmpty else {
            validationHandler("First Name field cannot be empty.", false)
            return
        }
        
        guard let surName = surName, !surName.isEmpty else {
            validationHandler("Last Name field cannot be empty.", false)
            return
        }
        
        guard let email = email, !email.isEmpty else {
            validationHandler("Email field cannot be empty.", false)
            return
        }
        
        if !ValidatorHelper.validateEmail(email: email){
            validationHandler("Email is invalid.", false)
            return
        }
        
        guard let password = password, !password.isEmpty else {
            validationHandler("Password field cannot be empty.", false)
            return
        }
        
        guard let confirmPassword = confirmPassword, !confirmPassword.isEmpty else {
            validationHandler("Confirm password field cannot be empty.", false)
            return
        }
        
        if password != confirmPassword {
            validationHandler("Password and confirm password does not match.", false)
            return
        }
        
        validationHandler("Validation Sucess", true)
    }
    
    func userRegister(onCompleted:@escaping(Observable<Error?>)->Void){
        commonViewModel.registerResponse(email: email ?? "", password: password ?? "", name: name ?? "", surname: surName ?? "") { (registerDataObservable) in
            registerDataObservable.subscribe(onNext: { (registerData,error) in
                if let registerInfo = registerData{
                    if registerInfo.success {
                        onCompleted(Observable.just(nil))
                    } else {
                        if registerInfo.data.status == 500 {
                            let error = Error(title: "Error", message: "Email already exists.")
                            onCompleted(Observable.just(error))
                        }
                    }
                }else{
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag)
        }
    }
}
