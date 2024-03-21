//
//  LoginViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import UIKit
import RxSwift

class LoginViewController: BaseViewController {

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
                self.showProgress()
                loginVM.userLoginInfo { statusCode, observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handle the error scenario
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            if statusCode == 403 {
                                self.hideProgress()
                                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: "Email or Password does not match, please try again.")
                            } else {
                                // Handle the success scenario
                                // Here you can update your UI or process the data
                                
                                self.hideProgress()
                                if !self.loginVM.isAdminStatus {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    let dashboardTabBarController = storyboard.instantiateViewController(withIdentifier: "DashboardTabBarController") as! DashboardTabBarController
                                    dashboardTabBarController.modalPresentationStyle = .overFullScreen
                                    self.present(dashboardTabBarController, animated: true, completion: nil)
                                } else {
                                    let storyboard = UIStoryboard(name: "Admin", bundle: nil)
                                    let AdminPortalViewController = storyboard.instantiateViewController(withIdentifier: "AdminPortalViewController") as! AdminPortalViewController
                                    AdminPortalViewController.modalPresentationStyle = .overFullScreen
                                    self.present(AdminPortalViewController, animated: true, completion: nil)
                                }
                            }
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
