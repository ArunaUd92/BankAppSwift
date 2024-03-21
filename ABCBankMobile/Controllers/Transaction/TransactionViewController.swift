//
//  TransactionViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit
import RxSwift

class TransactionViewController: BaseViewController {

    // MARK: Outlets
    // UI components connected to the storyboard.
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnExpenses: UIButton!
    @IBOutlet weak var btnEarnings: UIButton!
    
    // ViewModel for transactions and a DisposeBag for managing RxSwift subscriptions.
    fileprivate var transactionVM = TransactionViewModel()
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
        self.transactionsTableView.layer.cornerRadius = 6
        // Setting initial button states for filtering transactions.
        self.updateButtonStates(selectedButton: self.btnExpenses, otherButton: self.btnEarnings)
    }
    
    // Action for the expenses filter button tap.
    @IBAction func expensesButtonTapped(_ sender: UIButton) {
        // Update UI and filter transactions for expenses.
        if sender == self.btnExpenses {
            updateButtonStates(selectedButton: self.btnExpenses, otherButton: btnEarnings)
        }
        self.transactionVM.filterTransactions(by: .expenses)
        self.transactionsTableView.reloadData()
    }
    
    // Action for the earnings filter button tap.
    @IBAction func earningsButtonTapped(_ sender: UIButton) {
        // Update UI and filter transactions for earnings.
        if sender == self.btnEarnings {
            updateButtonStates(selectedButton: self.btnEarnings, otherButton: self.btnExpenses)
        }
        self.transactionVM.filterTransactions(by: .earnings)
        self.transactionsTableView.reloadData()
    }
    
    // Updates the UI state of filter buttons.
    func updateButtonStates(selectedButton: UIButton, otherButton: UIButton) {
        selectedButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_BLUE), for: .normal) // Highlight selected button.
        otherButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_GARY), for: .normal) // Dim other button.
    }
    
    // Updates UI with user data.
    func setUserData(){
        // Displaying user's account number and balance.
        self.lblAccountNumber.text = " Account Number: \(transactionVM.user?.bankAccount?.accountNumber ?? "")"
        let amountConvertToDouble = Double(transactionVM.user?.bankAccount?.balance ?? "")
        self.lblBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
    }
    
    // Fetches user data from ViewModel.
    func getUserData() {
        self.showProgress() // Showing loading indicator.
        transactionVM.userDetails {observable in
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
        transactionVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handling error scenario.
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Handling success scenario.
                    self.hideProgress()
                    self.transactionsTableView.reloadData() // Reloading table view with new data.
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
extension TransactionViewController: UITableViewDataSource  {
    
    // Configures and returns a cell for each row in the table view.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
        // Fetching transaction for the current row.
        let transaction =  self.transactionVM.filteredTransactions[indexPath.row]
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
            cell.lblDate.text = formattedDate // Output: "18 Sep 2023"
        }
        
        return cell
    }
    
    // Specifies the height for each row in the table view.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    // Returns the number of sections in the table view.
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Returns the number of rows in each section of the table view.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.transactionVM.filteredTransactions.count
        // Displaying an empty message if there are no transactions.
        self.transactionsTableView.backgroundView = nil
        if count == 0 {
            self.transactionsTableView.backgroundView = self.createEmptyMessageLabel()
        }
        return count
    }
}

// MARK: - Table View Delegate
extension TransactionViewController: UITableViewDelegate {
    
    // Handles selection of a row in the table view.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}

