//
//  AllCustomerListViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 17/01/2024.
//

import UIKit
import RxSwift

class AllCustomerListViewController: BaseViewController {

    @IBOutlet weak var AllCustomersTableView: UITableView!
    @IBOutlet weak var lblNumberOfCustomer: UILabel!
    
    // MARK: Properties
    fileprivate let bag = DisposeBag() // DisposeBag for RxSwift memory management
    fileprivate var allCustomerVM = AllCustomerViewModel() // ViewModel for pay transfer operations
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAllCustomerList()
    }
    
    
    // Function triggered when the back button is tapped
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismisses the current view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func getAllCustomerList() {
        self.showProgress() // Show a progress indicator
        allCustomerVM.getCustomerList { observable in
            observable.subscribe(onNext: { error in
                self.hideProgress() // Hide the progress indicator
                if let error = error {
                    // Display an error message if there's an error
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Reload the table view with new data on success
                    self.AllCustomersTableView.reloadData()
                    self.lblNumberOfCustomer.text = "Number of Customers: \(self.allCustomerVM.customerList?.users?.count ?? 0)"
                }
            }).disposed(by: self.bag)
        }
    }
    
    func postDeleteCustomer(customer: Customer) {
        self.showProgress() // Show progress indicator
        allCustomerVM.customerDelete(customerData: customer) { observable in
            observable.subscribe(onNext: { error in
                self.hideProgress() // Hide progress indicator
                if let error = error {
                    // Display error message if deletion fails
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Show success message and refresh the list on successful deletion
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.SuccessMessage, title: "Success", message: "Customer successfully deleted.")
                    self.getAllCustomerList()
                }
            }).disposed(by: self.bag)
        }
    }
    
    func showAlertDeleteCustomer(customer: Customer) {
        // Create and configure the alert controller
        let alert = UIAlertController(title: "Delete Payee", message: "Are you sure do you want to delete this customer?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Delete", style: .destructive, handler: { (action) in
            // Handle the deletion action
            self.postDeleteCustomer(customer: customer)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - Table View DataSource
extension AllCustomerListViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomerTableViewCell", for: indexPath) as! CustomerTableViewCell
        let customer =  self.allCustomerVM.customerList?.users?[indexPath.row]
        cell.lblCustomerName.text = "\(customer?.user?.name ?? "") \(customer?.user?.surname ?? "")"
        cell.lblCustomerEmail.text = "\(customer?.user?.email ?? "")"
        cell.customerCellViewDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allCustomerVM.customerList?.users?.count ?? 0
    }
}

// MARK: - Table View Delegate
extension AllCustomerListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}


extension AllCustomerListViewController: CustomerCellViewDelegate {

    // Function to handle the deletion of a customer from the cell
    func deleteCustomer(at cell: CustomerTableViewCell) {
        // Retrieve the index path of the cell
        guard let indexPath = AllCustomersTableView.indexPath(for: cell) else {
            return
        }
        
        // Retrieve the customer and show the deletion alert
        let customer =  self.allCustomerVM.customerList?.users?[indexPath.row]
        self.showAlertDeleteCustomer(customer: customer!)
    }
    
    func editCustomer(at cell: CustomerTableViewCell) {
        guard let indexPath = AllCustomersTableView.indexPath(for: cell) else {
            return
        }
        
        let customer =  self.allCustomerVM.customerList?.users?[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let adminEditProfileViewController = storyboard.instantiateViewController(withIdentifier: "AdminEditProfileViewController") as! AdminEditProfileViewController
        adminEditProfileViewController.customerData = customer
        adminEditProfileViewController.modalPresentationStyle = .overFullScreen
        self.present(adminEditProfileViewController, animated: true, completion: nil)
    }
}
