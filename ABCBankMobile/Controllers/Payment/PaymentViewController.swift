//
//  PaymentViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit
import RxSwift

class PaymentViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var lblMyAccountNumber: UILabel!
    @IBOutlet weak var lblMyBalance: UILabel!
    @IBOutlet weak var lblPayeeAccountNumber: UILabel!
    @IBOutlet weak var lblPayeeName: UILabel!
    
    fileprivate var paymentVM = PaymentViewModel()
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    //Back event button click.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func payButtonTapped(_ sender: Any) {
        self.paymentProcess()
    }
    
    // MARK: Functions
    private func paymentProcess(){
        
        paymentVM.amount = self.amountTextField.text
        paymentVM.reference = self.referenceTextField.text
        
 
        paymentVM.validation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                // If validation is successful, attempt to add payee
                paymentVM.paymentProcess {observable in
                    // Observing the result from ViewModel
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Displays an error message if there's an error
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                           
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Payment successfully. ")
                            // Dismisses the current view controller
                            self.dismiss(animated: true, completion: nil)
                        }
                    }).disposed(by: self.bag) // Disposing the subscription to prevent memory leaks
                }
                
            } else {
                // If validation fails, show an error message
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
    }
}
