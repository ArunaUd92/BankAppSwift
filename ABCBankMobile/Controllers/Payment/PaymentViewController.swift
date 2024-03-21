//
//  PaymentViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit
import RxSwift

class PaymentViewController: BaseViewController {
    
    // MARK: Outlets
    @IBOutlet weak var amountTextField: UITextField! // Text field to enter payment amount
    @IBOutlet weak var referenceTextField: UITextField! // Text field for payment reference
    @IBOutlet weak var lblMyAccountNumber: UILabel! // Label to display user's account number
    @IBOutlet weak var lblMyBalance: UILabel! // Label to display user's balance
    @IBOutlet weak var lblPayeeAccountNumber: UILabel! // Label to display payee's account number
    @IBOutlet weak var lblPayeeName: UILabel! // Label to display payee's name
    
    // ViewModel for managing payment logic and DisposeBag for RxSwift memory management
    fileprivate var paymentVM = PaymentViewModel()
    fileprivate let bag = DisposeBag()
    
    // Optional variable to hold payee information
    var payeeObject: Payee? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Fetch user data when the view loads
        getUserData()
    }
    
    // Function to handle back button tap
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismiss the current view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    // Function to initiate payment process when pay button is tapped
    @IBAction func payButtonTapped(_ sender: Any) {
        self.paymentProcess()
    }
    
    // Function to set data on labels from ViewModel and payee object
    func setData(){
        // Setting account number and formatted balance on respective labels
        self.lblMyAccountNumber.text = "\(paymentVM.user?.bankAccount?.accountNumber ?? "")"
        let amountConvertToDouble = Double(paymentVM.user?.bankAccount?.balance ?? "")
        self.lblMyBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
        
        // Setting payee's account number and name on respective labels
        self.lblPayeeAccountNumber.text = "\(payeeObject?.accountNumber ?? "") | \(payeeObject?.code ?? "")"
        self.lblPayeeName.text = "\(payeeObject?.name ?? "")"
    }
    
    // Function to get user data using ViewModel
    func getUserData() {
        paymentVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Show error message if there is an error
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Update UI with user data on success
                    self.setData()
                }
            }).disposed(by: self.bag)
        }
    }
    
    // Function to handle payment process
    private func paymentProcess(){
        
        // Setting values from text fields to ViewModel
        paymentVM.amount = self.amountTextField.text
        paymentVM.reference = self.referenceTextField.text
        paymentVM.fromUUID = paymentVM.user?.bankAccount?.uuid ?? ""
        paymentVM.toUUID = self.payeeObject?.uuid ?? ""
        
        
        // Valid ating the payment details
        paymentVM.validation(validationHandler: { errorMessage, isStatus in
            if isStatus {
                // If validation is successful, proceed with payment
                self.showProgress() // Show progress indicator
                paymentVM.paymentProcess { observable in
                    // Observing the result from ViewModel
                    observable.subscribe(onNext: { error in
                        self.hideProgress() // Hide progress indicator
                        if let error = error {
                            // Display error message if payment fails
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Display success message and dismiss view controller if payment succeeds
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Payment successfully.")
                            self.dismiss(animated: true, completion: nil)
                        }
                    }).disposed(by: self.bag) // Dispose subscription to prevent memory leaks
                }
            } else {
                // Show error message if validation fails
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        })
    }
}
