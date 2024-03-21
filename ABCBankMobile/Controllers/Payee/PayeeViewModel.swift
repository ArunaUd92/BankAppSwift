//
//  PayeeViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class PayeeViewModel {
    
    // MARK: Properties
    // Properties to store payee details
    var name: String? = ""
    var bankName: String? = ""
    var accountNumber: String? = ""
    var code: String? = ""

    // RxSwift DisposeBag for managing memory in reactive programming
    fileprivate let bag = DisposeBag()
    // Service object to handle pay transfer operations
    fileprivate var payTransferService = PayTransferService()
    
    // Function to validate payee details
    func validation(validationHandler: (String, Bool) -> ()) {
        // Validate that name is not empty
        guard let name = name, !name.isEmpty else {
            validationHandler("Name field cannot be empty.", false)
            return
        }
        
        // Validate that bank name is not empty
        guard let bankName = bankName, !bankName.isEmpty else {
            validationHandler("Bank Name field cannot be empty.", false)
            return
        }
        
        // Validate that account number is not empty
        guard let accountNumber = accountNumber, !accountNumber.isEmpty else {
            validationHandler("Account number cannot be empty.", false)
            return
        }
        
        // Validate that code is not empty
        guard let code = code, !code.isEmpty else {
            validationHandler("Code cannot be empty.", false)
            return
        }
        
        // Pass validation success if all checks are passed
        validationHandler("Validation Success", true)
    }
    
    // Function to add a new payee
    func addPayee(onCompleted: @escaping (Observable<Error?>) -> Void) {
        // Call the service to add a new payee with provided details
        payTransferService.addPayeeService(name: name ?? "", bankName: bankName ?? "", accountNumber: accountNumber ?? "", code: code ?? "", user: UserSessionManager.sharedInstance.retrieveUser()?.uuid ?? "") { (registerDataObservable) in
            // Subscribe to the observable to handle the response
            registerDataObservable.subscribe(onNext: { (registerData, error) in
                if let registerInfo = registerData {
                    // If registration is successful
                    if registerInfo.success {
                        // Notify caller with no error
                        onCompleted(Observable.just(nil))
                    } else {
                        // Handle failure case by passing an error
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // Handle error scenario if no data is received
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Dispose the subscription to prevent memory leaks
        }
    }
}
