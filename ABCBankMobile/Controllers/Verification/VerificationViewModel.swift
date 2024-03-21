//
//  VerificationViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import Foundation
import RxSwift

class VerificationViewModel{
    
    // Properties for storing the verification code and email address.
    var verificationCode: String? = ""
    var emailAddress: String = ""
    
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Common service model for making network requests.
    fileprivate var commonServiceModel = CommonServiceModel()
    
    // MARK: Functions
    
    // Validates the verification code.
    func verificationValidation(validationHandler: (String, Bool)->()) {
        // Checks if the verification code is not empty.
        guard let verificationCode = verificationCode, !verificationCode.isEmpty else {
            validationHandler("Verification code field cannot be empty.", false)
            return
        }
        
        // If validation is successful, a success message is returned.
        validationHandler("Validation Success", true)
    }
    
    // Performs the account verification.
    func verificationAccount(onCompleted:@escaping(Observable<Error?>)->Void){
        // Calls the service to verify the account with the given code.
        commonServiceModel.verificationService(code: verificationCode ?? "") { (verificationDataObservable) in
            verificationDataObservable.subscribe(onNext: { (verificationData, error) in
                // Processes the response from the service.
                if let verificationInfo = verificationData{
                    if verificationInfo.success {
                        // On successful verification, an Observable with nil error is returned.
                        onCompleted(Observable.just(nil))
                    } else {
                        // On failure, an Observable with an error message is returned.
                        let error = Error(title: "Error", message: "Verification code not valid.")
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // In case of an unexpected error, it is returned.
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
    
    // Handles the resend code functionality.
    func resendCode(onCompleted:@escaping(Observable<Error?>)->Void){
        // Calls the service to resend the verification code.
        commonServiceModel.verificationService(code: verificationCode ?? "") { (resendObservable) in
            resendObservable.subscribe(onNext: { (resendData, error) in
                // Processes the response from the service.
                if let resendInfo = resendData{
                    if resendInfo.success {
                        // On successful resend, an Observable with nil error is returned.
                        onCompleted(Observable.just(nil))
                    } else {
                        // On failure, an Observable with an error message is returned.
                        let error = Error(title: "Error", message: "Error")
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // In case of an unexpected error, it is returned.
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
}
