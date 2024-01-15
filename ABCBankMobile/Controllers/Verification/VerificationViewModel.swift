//
//  VerificationViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import Foundation
import RxSwift

class VerificationViewModel{
    
    var verificationCode: String? = ""
    var emailAddress: String = ""
    
    fileprivate let bag = DisposeBag()
    fileprivate var commonViewModel = CommonViewModel()
    
    
    // MARK: Functions
    // signup validation
    func verificationValidation(validationHandler: (String, Bool)->()) {
        guard let verificationCode = verificationCode, !verificationCode.isEmpty else {
            validationHandler("Verification code field cannot be empty.", false)
            return
        }
        
        validationHandler("Validation Sucess", true)
    }
    
    func verificationAccount(onCompleted:@escaping(Observable<Error?>)->Void){
        commonViewModel.verificationService(code: verificationCode ?? "") { (verificationDataObservable) in
            verificationDataObservable.subscribe(onNext: { (verificationData,error) in
                if let verificationInfo = verificationData{
                    if verificationInfo.success {
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: "Verification code not valid.")
                        onCompleted(Observable.just(error))
                    }
                }else{
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag)
        }
    }
    
    func resendCode(onCompleted:@escaping(Observable<Error?>)->Void){
        commonViewModel.verificationService(code: verificationCode ?? "") { (resendObservable) in
            resendObservable.subscribe(onNext: { (resendData,error) in
                if let resendInfo = resendData{
                    if resendInfo.success {
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: "Error")
                        onCompleted(Observable.just(error))
                        
                    }
                }else{
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag)
        }
    }
}
