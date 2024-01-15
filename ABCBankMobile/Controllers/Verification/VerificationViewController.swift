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
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    // MARK: Properties
    fileprivate var verificationVM = VerificationViewModel()
    fileprivate let bag = DisposeBag()
    var emailAddress: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    // MARK: Button event action
    //Verification event button click.
    @IBAction func verificationButtonTapped(_ sender: Any) {
        self.verification()
    }
    
    @IBAction func resendCodeButtonTapped(_ sender: Any) {
        self.resendCode()
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

    //MARK: Functiona
    private func verification(){
        
        verificationVM.verificationCode = self.verificationCodeTextField.text
        
        verificationVM.verificationValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                self.showProgress()
                verificationVM.verificationAccount {observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handle the error scenario
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Here you can update your UI or process the data
                            // Handle the success scenario
                            self.hideProgress()
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                            loginViewController.modalPresentationStyle = .overFullScreen
                            self.present(loginViewController, animated: true, completion: nil)
                            
                        }
                    }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
                }
                
            } else {
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
    }
    
    private func resendCode(){
        
        verificationVM.verificationCode = self.emailAddress
        self.showProgress()
        verificationVM.verificationAccount {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.hideProgress()
                    
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
}
