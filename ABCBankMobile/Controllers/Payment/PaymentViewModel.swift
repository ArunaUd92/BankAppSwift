//
//  PaymentViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class PaymentViewModel {
    
    // MARK: Properties
    // Variables to store payment details
    var amount: String? = ""
    var reference: String? = ""
    var fromUUID: String? = "" // Owner's bank account UUID
    var toUUID: String? = "" // Payee's UUID
    
    // User details and services
    var user: UserDetails? = nil
    fileprivate let bag = DisposeBag() // DisposeBag for memory management with RxSwift
    fileprivate var userService = UserService() // Service for user-related operations
    fileprivate var transactionService = TransactionService() // Service for transaction operations
    
    // MARK: Functions
    // Function to validate payment details
    func validation(validationHandler: (String, Bool) -> ()) {
        // Ensure amount is not empty
        guard let amount = amount, !amount.isEmpty else {
            validationHandler("Amount field cannot be empty.", false)
            return
        }
        
        // Ensure reference is not empty
        guard let reference = reference, !reference.isEmpty else {
            validationHandler("Reference field cannot be empty.", false)
            return
        }
        
        // If all validations pass
        validationHandler("Validation Success", true)
    }
    
    // Function to process payment
    func paymentProcess(onCompleted: @escaping (Observable<Error?>) -> Void) {
        // Call to transactionService to perform the transaction
        transactionService.transactionService(amount: amount ?? "", reference: reference ?? "", from: fromUUID ?? "", to: toUUID ?? "") { (registerDataObservable) in
            // Subscribing to the result of the service call
            registerDataObservable.subscribe(onNext: { (registerData, error) in
                if let registerInfo = registerData {
                    // Check if transaction is successful
                    if registerInfo.success {
                        // Call onCompleted with no error if transaction is successful
                        onCompleted(Observable.just(nil))
                    } else {
                        // Handle failure case
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // Handle error scenario
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Dispose to prevent memory leaks
        }
    }
    
    // Function to retrieve user details
    func userDetails(onCompleted: @escaping (Observable<Error?>) -> Void) {
        // Retrieve user from session manager
        let user = UserSessionManager.sharedInstance.retrieveUser()
        // Request user details from userService
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData, error) in
                if let userInfo = userData {
                    // Check if user details retrieval is successful
                    if userInfo.success {
                        // Store user data and call onCompleted with no error
                        self.user = userInfo.data
                        onCompleted(Observable.just(nil))
                    } else {
                        // Handle failure case
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // Handle error scenario
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag) // Dispose to prevent memory leaks
        }
    }
}
