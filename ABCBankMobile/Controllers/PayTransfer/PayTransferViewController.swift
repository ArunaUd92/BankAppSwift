//
//  PayTransferViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit
import RxSwift

class PayTransferViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var payeesTableView: UITableView! // Table view to display payees
    
    // MARK: Properties
    fileprivate let bag = DisposeBag() // DisposeBag for RxSwift memory management
    fileprivate var payTransferVM = PayTransferViewModel() // ViewModel for pay transfer operations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Setup user interface elements
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getPayeeList() // Fetch the list of payees when the view appears
    }
    
    // Function to set up user interface elements
    func setupUI() {
        self.payeesTableView.layer.cornerRadius = 6 // Set corner radius for the table view
    }
    
    // Function triggered when the 'Add Payee' button is tapped
    @IBAction func addPayeeButtonTapped(_ sender: Any) {
        // Instantiate and present PayeeViewController
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let payeeViewController = storyboard.instantiateViewController(withIdentifier: "PayeeViewController") as! PayeeViewController
        payeeViewController.payeeViewDelegate = self
        payeeViewController.modalPresentationStyle = .overFullScreen
        self.present(payeeViewController, animated: true, completion: nil)
    }
    
    // Function to fetch the list of payees
    func getPayeeList() {
        self.showProgress() // Show a progress indicator
        payTransferVM.payeeList { observable in
            observable.subscribe(onNext: { error in
                self.hideProgress() // Hide the progress indicator
                if let error = error {
                    // Display an error message if there's an error
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Reload the table view with new data on success
                    self.payeesTableView.reloadData()
                }
            }).disposed(by: self.bag)
        }
    }
    
    // Function to initiate the deletion of a payee
    func postDeletePayee(payee: Payee) {
        self.showProgress() // Show progress indicator
        payTransferVM.payeeDelete(payee: payee) { observable in
            observable.subscribe(onNext: { error in
                self.hideProgress() // Hide progress indicator
                if let error = error {
                    // Display error message if deletion fails
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Show success message and refresh the list on successful deletion
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Payee successfully deleted.")
                    self.getPayeeList()
                }
            }).disposed(by: self.bag)
        }
    }
    
    // Function to show an alert for confirming the deletion of a payee
    func showAlertDeletePayee(payee: Payee) {
        // Create and configure the alert controller
        let alert = UIAlertController(title: "Delete Payee", message: "Are you sure do you want to delete this payee?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            // Handle the deletion action
            self.postDeletePayee(payee: payee)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table View DataSource
extension PayTransferViewController: UITableViewDataSource  {
    
    // Function to create table view cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayeeTableViewCell", for: indexPath) as! PayeeTableViewCell
        let payee = self.payTransferVM.payeeList[indexPath.row]
        cell.payeeCellViewDelegate = self
        cell.lblAccountNumber.text = "\(payee.code ?? "") | \(payee.accountNumber ?? "")"
        cell.lblPayeeName.text = "\(payee.accountNumber ?? "") - \(payee.name ?? "")"
        return cell
    }
    
    // Function to set the height for table view rows
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // Function to set the number of sections in the table view
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Function to set the number of rows in each section of the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.payTransferVM.payeeList.count
    }
}

// MARK: - Table View Delegate
extension PayTransferViewController: UITableViewDelegate {
    
    // Function to handle row selection in the table view
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Instantiate and present PaymentViewController
        let payee = self.payTransferVM.payeeList[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentViewController.payeeObject = payee
        paymentViewController.modalPresentationStyle = .overFullScreen
        self.present(paymentViewController, animated: true, completion: nil)
    }
}

// MARK: - Payee item cell delegate
extension PayTransferViewController: PayeeCellViewDelegate {
    
    // Function to handle the deletion of a payee from the cell
    func deletePayer(at cell: PayeeTableViewCell) {
        // Retrieve the index path of the cell
        guard let indexPath = payeesTableView.indexPath(for: cell) else {
            return
        }
        
        // Retrieve the payee and show the deletion alert
        let payee = self.payTransferVM.payeeList[indexPath.row]
        self.showAlertDeletePayee(payee: payee)
    }
}

// MARK: - Payee View Delegate
extension PayTransferViewController: PayeeViewDelegate {
    
    // Function to refresh the view
    func refreshView(status: Bool) {
        self.getPayeeList() // Refresh the list of payees
    }
}
