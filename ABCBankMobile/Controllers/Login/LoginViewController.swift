//
//  LoginViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Properties
    fileprivate var loginVM = LoginViewModel()
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    // MARK: Button event action
    //Signup event button click.
    @IBAction func signupButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupViewController = storyboard.instantiateViewController(withIdentifier: "SignupViewController") as! SignupViewController
        signupViewController.modalPresentationStyle = .overFullScreen
        self.present(signupViewController, animated: true, completion: nil)
    }
    
    //Login event button click.
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.login()
    }
    
    //ForgotPassword event button click.
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {

    }
    
    //MARK: Functiona
    private func login(){
        
        loginVM.email = self.emailTextField.text
        loginVM.password = self.passwordTextField.text
        
        loginVM.loginValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                loginVM.userLoginInfo { statusCode, observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handle the error scenario
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Here you can update your UI or process the data
                            if statusCode == 403 {
                                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                let verificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
                                verificationViewController.modalPresentationStyle = .overFullScreen
                                self.present(verificationViewController, animated: true, completion: nil)
                            } else {
                                // Handle the success scenario
                                print("Successfully loaded popular movies.")
                            }
                        }
                    }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
                }
                
            } else {
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
    }

}
