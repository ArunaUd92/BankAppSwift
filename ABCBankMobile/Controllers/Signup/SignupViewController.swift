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
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // MARK: Properties
    fileprivate var signupVM = SignupViewModel()
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    
    // MARK: Button event action
    //Signup event button click.
    @IBAction func signupButtonTapped(_ sender: Any) {
        self.signup()
    }
    
    //Login event button click.
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    //MARK: Functiona
    private func signup(){
        
        signupVM.name = self.firstNameTextField.text
        signupVM.surName = self.lastNameTextField.text
        signupVM.email = self.emailTextField.text
        signupVM.password = self.passwordTextField.text
        signupVM.confirmPassword = self.confirmPasswordTextField.text
        
        signupVM.signupValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                self.showProgress()
                signupVM.userRegister {observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handle the error scenario
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Here you can update your UI or process the data
                            // Handle the success scenario     
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Your account has been created successfully")
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let verificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                            verificationViewController.modalPresentationStyle = .overFullScreen
                            verificationViewController.emailAddress = self.emailTextField.text
                            self.present(verificationViewController, animated: true, completion: nil)
                        }
                    }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
                }
                
            } else {
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
        
    }
}
