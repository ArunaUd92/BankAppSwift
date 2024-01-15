//
//  PayeeViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit
import RxSwift

protocol  PayeeViewDelegate : AnyObject {
    func refreshView(status : Bool )
}

class PayeeViewController: BaseViewController {

    // MARK: Outlets
    // UI elements connected from storyboard
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bankNameTextField: UITextField!
    @IBOutlet weak var accountNumberTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    
    // MARK: Properties
    // ViewModel for handling Payee logic and data
    fileprivate var payeeVM = PayeeViewModel()
    // DisposeBag for managing memory in RxSwift
    fileprivate let bag = DisposeBag()
    
    weak var payeeViewDelegate: PayeeViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Any additional setup after loading the view.
    }
    
    // Function triggered when the back button is tapped
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismisses the current view controller
        self.dismiss(animated: true, completion: nil)
    }

    // Function triggered when the add payee button is tapped
    @IBAction func addPayeeButtonTapped(_ sender: Any) {
        // Calls the function to add a new payee
        self.addPayee()
    }
    
    
    // MARK: Functions
    // Function to add a new payee
    private func addPayee(){
        
        // Assigns user input from text fields to the ViewModel properties
        payeeVM.name = self.nameTextField.text
        payeeVM.bankName = self.bankNameTextField.text
        payeeVM.accountNumber = self.accountNumberTextField.text
        payeeVM.code = self.codeTextField.text
        
        // Validates the payee details
        payeeVM.validation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                // If validation is successful, attempt to add payee
                self.showProgress()
                payeeVM.addPayee {observable in
                    // Observing the result from ViewModel
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Displays an error message if there's an error
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Displays a success message if payee is added successfully
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Payee successfully added.")
                            // Dismisses the current view controller
                            self.payeeViewDelegate?.refreshView(status: true)
                            self.dismiss(animated: true, completion: nil)
                        }
                    }).disposed(by: self.bag) // Disposing the subscription to prevent memory leaks
                }
                
            } else {
                // If validation fails, show an error message
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
        
    }
    
}

