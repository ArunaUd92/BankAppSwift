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
    
    // RxSwift DisposeBag for managing memory
    fileprivate let bag = DisposeBag()
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
        transactionService.transactionService(amount: amount ?? "", reference: reference ?? "") { (registerDataObservable) in
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
    
}
