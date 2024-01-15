//
//  PaymentViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class PaymentViewModel{
    
    // MARK: Properties
    var amount: String? = ""
    var reference: String? = ""
    var fromUUID: String? = "" //owner bank account uuid
    var toUUID: String? = "" //payer uuid
    
    // RxSwift DisposeBag for managing memory
    var user:UserDetails? = nil
    fileprivate let bag = DisposeBag()
    fileprivate var userService = UserService()
    fileprivate var transactionService = TransactionService()
    
    // MARK: Functions
    func validation(validationHandler: (String, Bool)->()) {
        guard let amount = amount, !amount.isEmpty else {
            validationHandler("Amount field cannot be empty.", false)
            return
        }
        
        guard let reference = reference, !reference.isEmpty else {
            validationHandler("Reference field cannot be empty.", false)
            return
        }
        
        validationHandler("Validation Sucess", true)
    }
    
    
    func paymentProcess(onCompleted:@escaping(Observable<Error?>)->Void){
        transactionService.transactionService(amount: amount ?? "", reference: reference ?? "", from: fromUUID ?? "", to: toUUID ?? "" ) { (registerDataObservable) in
            // Subscribing to the result of the service call
            registerDataObservable.subscribe(onNext: { (registerData,error) in
                if let registerInfo = registerData{
                    // Check if registration is successful
                    if registerInfo.success {
                        // Call onCompleted with no error
                        onCompleted(Observable.just(nil))
                    } else {
                        // Handle failure case
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                }else{
                    // Handle error scenario
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Dispose to prevent memory leaks
        }
    }
    
    func userDetails(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.user = userInfo.data
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                }else{
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag)
        }
    }
    
}
