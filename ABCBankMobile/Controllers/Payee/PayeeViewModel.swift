//
//  PayeeViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class PayeeViewModel{
    
    // MARK: Properties
    // Properties for storing payee details
    var name: String? = ""
    var bankName: String? = ""
    var accountNumber: String? = ""
    var code: String? = ""

    
    // RxSwift DisposeBag for managing memory
    fileprivate let bag = DisposeBag()
    // Service object for handling pay transfers
    fileprivate var payTransferService = PayTransferService()
    
    // Function for validating payee details
    func validation(validationHandler: (String, Bool)->()) {
        // Validation for name
        guard let name = name, !name.isEmpty else {
            validationHandler("Name field cannot be empty.", false)
            return
        }
        
        // Validation for bank name
        guard let bankName = bankName, !bankName.isEmpty else {
            validationHandler("Bank Name field cannot be empty.", false)
            return
        }
        
        // Validation for account number
        guard let accountNumber = accountNumber, !accountNumber.isEmpty else {
            validationHandler("Account number cannot be empty.", false)
            return
        }
        
        // Validation for code
        guard let code = code, !code.isEmpty else {
            validationHandler("Code cannot be empty.", false)
            return
        }
        
        // If all validations pass
        validationHandler("Validation Success", true)
    }
    
    // Function to add a new payee
    func addPayee(onCompleted:@escaping(Observable<Error?>)->Void){
        // Calls the service to add a new payee
        
        payTransferService.addPayeeService(name: name ?? "", bankName: bankName ?? "", accountNumber: accountNumber ?? "", code: code ?? "", user: UserSessionManager.sharedInstance.retrieveUser()?.uuid ?? "") { (registerDataObservable) in
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
