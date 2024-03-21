//
//  VerificationViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import UIKit
import RxSwift

class VerificationViewController: BaseViewController {

    // MARK: Outlets
    // Outlet for the verification code text field.
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    // MARK: Properties
    // ViewModel for handling verification logic.
    fileprivate var verificationVM = VerificationViewModel()
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Email address for which verification is being performed.
    var emailAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view.
    }
    
    // MARK: Button event actions

    // Action for the 'Verify' button tap.
    @IBAction func verificationButtonTapped(_ sender: Any) {
        self.verification() // Initiates the verification process.
    }
    
    // Action for the 'Resend Code' button tap.
    @IBAction func resendCodeButtonTapped(_ sender: Any) {
        self.resendCode() // Initiates the code resend process.
    }
    
    // Action for the 'Back' button tap.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) // Dismisses the current view controller.
    }
    
    // Private Functions

    // Handles the verification process.
    private func verification(){
        // Setting the verification code from the text field to the ViewModel.
        verificationVM.verificationCode = self.verificationCodeTextField.text
        
        // Validates the code and performs the verification.
        verificationVM.verificationValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                // If validation is successful, proceed with verification.
                self.showProgress()
                verificationVM.verificationAccount {observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handles error scenario during verification.
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Handles successful verification.
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Your account has been verified successfully.")
                            // Navigates to the Login screen after successful verification.
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.modalPresentationStyle = .overFullScreen
                            self.present(loginViewController, animated: true, completion: nil)
                        }
                    }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
                }
            } else {
                // If validation fails, show an error message.
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
    }
    
    // Handles resending the verification code.
    private func resendCode(){
        // Setting the email address to resend the verification code.
        verificationVM.verificationCode = self.emailAddress
        // Initiates the resend process.
        self.showProgress()
        verificationVM.verificationAccount {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handles error scenario during code resend.
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Handles successful code resend.
                    self.hideProgress()
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
}

