//
//  PayTransferViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit
import RxSwift

class PayTransferViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var payeesTableView: UITableView!
    
    
    // MARK: Properties
    fileprivate let bag = DisposeBag()
    fileprivate var payTransferVM = PayTransferViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPayeeList()
    }
    
    func setupUI(){
        self.payeesTableView.layer.cornerRadius = 6
    }
    
    
    @IBAction func addPayeeButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let payeeViewController = storyboard.instantiateViewController(withIdentifier: "PayeeViewController") as! PayeeViewController
        payeeViewController.modalPresentationStyle = .overFullScreen
        self.present(payeeViewController, animated: true, completion: nil)
    }
    
    func getPayeeList() {
        payTransferVM.payeeList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.payeesTableView.reloadData()
                   
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    func postDeletePayee(payee: Payee) {
        payTransferVM.payeeDelete(payee: payee) {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.payeesTableView.reloadData()
                   
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    func showAlertDeletePayee(payee: Payee){
        // Create the alert controller
        let alert = UIAlertController(title: "Delete Payee", message: "Are you sure do you want to delete this payee?", preferredStyle: .alert)
        // Create the action
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            // This code will be executed when the 'OK' button is tapped
            self.postDeletePayee(payee: payee)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // Add the action to the alert controller
        alert.addAction(action)
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table View DataSource
extension PayTransferViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayeeTableViewCell", for: indexPath) as! PayeeTableViewCell
//        let payee =  self.payTransferVM.payeeList[indexPath.row]
//        cell.payeeCellViewDelegate = self
//        cell.lblAccountNumber.text = "\(payee.code ?? "") \(payee.accountNumber ?? "")"
//        cell.lblPayeeName.text = payee.accountNumber ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return self.payTransferVM.payeeList.count
        return 10
    }
}

// MARK: - Table View Delegate
extension PayTransferViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //  let payee =  self.payTransferVM.payeeList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentViewController.modalPresentationStyle = .overFullScreen
        self.present(paymentViewController, animated: true, completion: nil)
    }
}

// MARK: - Payee item cell delegate
extension PayTransferViewController: PayeeCellViewDelegate {
    
    func deletePayer(at cell: PayeeTableViewCell) {
        
        guard let indexPath = payeesTableView.indexPath(for: cell) else {
            return
        }
        
        let payee =  self.payTransferVM.payeeList[indexPath.row]
        self.showAlertDeletePayee(payee: payee)
        
    }
}
