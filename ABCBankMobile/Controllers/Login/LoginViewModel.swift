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
    var email: String? = ""
    var password: String? = ""
    
    fileprivate let bag = DisposeBag()
    fileprivate var commonViewModel = CommonViewModel()
    
//    init(commonViewModel:CommonViewModel) {
//        self.commonViewModel = commonViewModel
//    }
    
    // MARK: Functions
    // login validation
    func loginValidation(validationHandler: (String, Bool)->()) {
        guard let email = email, !email.isEmpty else {
            validationHandler("Email field cannot be empty.", false)
            return
        }
        
        if !ValidatorHelper.validateEmail(email: email){
            validationHandler("Email is invalid", false)
            return
        }
        
        guard let password = password, !password.isEmpty else {
            validationHandler("Password field cannot be empty.", false)
            return
        }
        
        validationHandler("Validation Sucess", true)
    }
    
    
    func userLoginInfo(onCompleted:@escaping(_ statusCode: Int, Observable<Error?>)->Void){
        commonViewModel.loginResponse { (loginDataObservable) in
            loginDataObservable.subscribe(onNext: { (loginData,error) in
                if let loginInfo = loginData{
                    if loginInfo.success {
                        UserSessionManager.sharedInstance.saveToken(loginInfo.data.token!)
                        UserSessionManager.sharedInstance.saveUser(loginInfo.data.user!)
                        onCompleted(200, Observable.just(nil))
                    } else {
                        onCompleted(403, Observable.just(nil))
                    }
                }else{
                    onCompleted(400, Observable.just(error!))
                }
            }).disposed(by: self.bag)
        }
    }

}
