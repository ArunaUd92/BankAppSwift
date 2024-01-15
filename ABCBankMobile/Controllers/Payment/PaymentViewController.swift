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
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var referenceTextField: UITextField!
    @IBOutlet weak var lblMyAccountNumber: UILabel!
    @IBOutlet weak var lblMyBalance: UILabel!
    @IBOutlet weak var lblPayeeAccountNumber: UILabel!
    @IBOutlet weak var lblPayeeName: UILabel!
    
    fileprivate var paymentVM = PaymentViewModel()
    fileprivate let bag = DisposeBag()
    var payeeObject: Payee? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getUserData()
    }
    

    //Back event button click.
    @IBAction func backButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func payButtonTapped(_ sender: Any) {
        self.paymentProcess()
    }
    
    func setData(){
        self.lblMyAccountNumber.text = "\(paymentVM.user?.bankAccount?.accountNumber ?? "")"
        let amountConvertToDouble = Double(paymentVM.user?.bankAccount?.balance ?? "")
        self.lblMyBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
        
        self.lblPayeeAccountNumber.text = "\(payeeObject?.accountNumber ?? "") | \(payeeObject?.code ?? "")"
        self.lblPayeeName.text = "\(payeeObject?.name ?? "")"
    }
    
    func getUserData() {
        paymentVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.setData()
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    // MARK: Functions
    private func paymentProcess(){
        
        paymentVM.amount = self.amountTextField.text
        paymentVM.reference = self.referenceTextField.text
        paymentVM.fromUUID = paymentVM.user?.bankAccount?.uuid ?? ""
        paymentVM.toUUID = self.payeeObject?.uuid ?? ""
 
        paymentVM.validation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                // If validation is successful, attempt to add payee
                self.showProgress()
                paymentVM.paymentProcess {observable in
                    // Observing the result from ViewModel
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Displays an error message if there's an error
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Payment successfully.")
                            // Dismisses the current view controller
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
