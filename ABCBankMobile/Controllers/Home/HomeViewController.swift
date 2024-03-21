//
//  HomeViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit
import RxSwift

class HomeViewController: BaseViewController {

    // MARK: Outlets
    // UI components connected to the storyboard.
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var recentTransactionsTableView: UITableView!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    // ViewModel for the Home view and a DisposeBag for managing RxSwift subscriptions.
    fileprivate var homeVM = HomeViewModel()
    fileprivate let bag = DisposeBag()
    
    // Called after the controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() // Setting up UI elements.
    }
    
    // Called each time the view is about to appear on the screen.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData() // Fetching user data.
        self.getTransactionList() // Fetching transaction list.
    }
    
    // Configures UI elements.
    func setupUI(){
        // Styling for the transactions table view.
        self.recentTransactionsTableView.layer.cornerRadius = 6
        // Setting current date in label.
        self.lblCurrentDate.text = Date().getDescriptiveDateString()
    }
    
    // Updates UI elements with user data.
    func setUserData(){
        // Setting user's name and surname.
        self.lblUserName.text = "\(homeVM.user?.name ?? "") \(homeVM.user?.surname ?? "")"
        // Setting user's account number.
        self.lblAccountNumber.text = "Account Number: \(homeVM.user?.bankAccount?.accountNumber ?? "")"
        // Formatting and setting account balance.
        let amountConvertToDouble = Double(homeVM.user?.bankAccount?.balance ?? "")
        self.lblBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
    }
    
    // Fetches user data from ViewModel.
    func getUserData() {
        self.showProgress() // Showing loading indicator.
        homeVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handling error scenario.
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Handling success scenario.
                    self.hideProgress()
                    self.setUserData() // Updating UI with user data.
                }
            }).disposed(by: self.bag) // Managing subscription with DisposeBag.
        }
    }
    
    // Fetches transaction list from ViewModel.
    func getTransactionList() {
        self.showProgress() // Showing loading indicator.
        homeVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handling error scenario.
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Handling success scenario.
                    self.hideProgress()
                    self.recentTransactionsTableView.reloadData() // Reloading table view with new data.
                   
                }
            }).disposed(by: self.bag) // Managing subscription with DisposeBag.
        }
    }
    
    // Creates and configures a label for empty transaction list.
    private func createEmptyMessageLabel() -> UILabel {
        let messageLabel = UILabel()
        messageLabel.text = "No transactions available"
        messageLabel.textAlignment = .center
        messageLabel.textColor = .gray
        messageLabel.numberOfLines = 0
        messageLabel.font = UIFont.systemFont(ofSize: 16)
        return messageLabel
    }

}

// MARK: - Table View DataSource
extension HomeViewController: UITableViewDataSource  {
    
    // Configures and returns a cell for each row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
        let transaction =  self.homeVM.transactionList[indexPath.row]
        // Formatting the transaction amount and setting cell data.
        let amountConvertToDouble = Double(transaction.amount ?? "")
        // Setting the cell data based on transaction type.
        if transaction.type == "plus" {
            cell.lblTransactionType.text = "Received"
            cell.lblAmount.text = "+ \(ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00))"
            cell.lblAmount.textColor =  UIColor.init(hexString: UIConstants.COLOR_TRANSACTION_PLUS)
        } else {
            cell.lblTransactionType.text = "Transfered"
            cell.lblAmount.text = "- \(ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00))"
            cell.lblAmount.textColor =  UIColor.init(hexString: UIConstants.COLOR_TRANSACTION_MINE)
        }
        
        // Setting subtitle and date for transaction.
        cell.lblSubTitle.text = transaction.reference
        if let formattedDate = Date().convertDateString(from: transaction.date ?? "") {
            cell.lblDate.text = formattedDate
        }
        
        return cell
    }
    
    // Specifies the height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    // Returns the number of sections in the table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the number of rows in each section of the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.homeVM.transactionList.count
        // Displaying an empty message if there are no transactions.
        self.recentTransactionsTableView.backgroundView = nil
        if count == 0 {
            self.recentTransactionsTableView.backgroundView = self.createEmptyMessageLabel()
        }
        return count
    }
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate {
    
    // Handles selection of a row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
