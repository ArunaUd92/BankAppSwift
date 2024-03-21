//
//  SignupViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import UIKit
import RxSwift

class SignupViewController: BaseViewController {

    // MARK: Outlets
    // Outlets for user input fields in the signup form.
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: Properties
    // ViewModel for handling the signup logic.
    fileprivate var signupVM = SignupViewModel()
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Additional setup after loading the view.
    }
    
    // MARK: Button event actions

    // Action for the 'Sign Up' button tap.
    @IBAction func signupButtonTapped(_ sender: Any) {
        self.signup() // Initiates the signup process.
    }
    
    // Action for the 'Log In' button tap.
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil) // Dismisses the current view controller.
    }
    
    // Private Functions

    // Handles the signup process.
    
    //MARK: Functiona
    private func signup(){
        
        // Setting user input data to the ViewModel.
        signupVM.name = self.firstNameTextField.text
        signupVM.surName = self.lastNameTextField.text
        signupVM.email = self.emailTextField.text
        signupVM.password = self.passwordTextField.text
        signupVM.confirmPassword = self.confirmPasswordTextField.text
        
        // Performs validation and registration.
          signupVM.signupValidation(validationHandler:{ errorMessage, isStatus in
              if(isStatus){
                  // If validation is successful, proceed with user registration.
                  self.showProgress()
                  signupVM.userRegister {observable in
                      observable.subscribe(onNext: { error in
                          if let error = error {
                              // Handles error scenario during registration.
                              self.hideProgress()
                              MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                          } else {
                              // Handles successful registration.
                              self.hideProgress()
                              MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Your account has been created successfully")
                              // Navigates to the Verification screen after successful signup.
                              let storyboard = UIStoryboard(name: "Main", bundle: nil)
                              let verificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                              verificationViewController.modalPresentationStyle = .overFullScreen
                              verificationViewController.emailAddress = self.emailTextField.text
                              self.present(verificationViewController, animated: true, completion: nil)
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
}
