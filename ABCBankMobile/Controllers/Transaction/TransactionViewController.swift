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
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnExpenses: UIButton!
    @IBOutlet weak var btnEarnings: UIButton!
    
    fileprivate var transactionVM = TransactionViewModel()
    fileprivate let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData()
        self.getTransactionList()
    }
    

    func setupUI(){
        self.transactionsTableView.layer.cornerRadius = 6
        self.updateButtonStates(selectedButton: self.btnExpenses, otherButton: self.btnEarnings)
    }
    
    
    @IBAction func expensesButtonTapped(_ sender: UIButton) {
        if sender == self.btnExpenses {
            updateButtonStates(selectedButton: self.btnExpenses, otherButton: btnEarnings)
        }
        self.transactionVM.filterTransactions(by: .expenses)
        self.transactionsTableView.reloadData()
        
    }
    
    @IBAction func earningsButtonTapped(_ sender: UIButton) {
        if sender == self.btnEarnings {
            updateButtonStates(selectedButton: self.btnEarnings, otherButton: self.btnExpenses)
        }
        self.transactionVM.filterTransactions(by: .earnings)
        self.transactionsTableView.reloadData()
    }
    
    func updateButtonStates(selectedButton: UIButton, otherButton: UIButton) {
        selectedButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_BLUE), for: .normal)// Selected color
        otherButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_GARY), for: .normal)// Non-selected color
    }
    
    func setUserData(){
        self.lblAccountNumber.text = " Account Number: \(transactionVM.user?.bankAccount?.accountNumber ?? "")"
        let amountConvertToDouble = Double(transactionVM.user?.bankAccount?.balance ?? "")
        self.lblBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
    }
    
    func getUserData() {
        self.showProgress()
        transactionVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.hideProgress()
                    self.setUserData()
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    func getTransactionList() {
        self.showProgress()
        transactionVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.hideProgress()
                    self.transactionsTableView.reloadData()
                   
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
        let transaction =  self.transactionVM.filteredTransactions[indexPath.row]
        let amountConvertToDouble = Double(transaction.amount ?? "")
        if transaction.type == "plus" {
            cell.lblTransactionType.text = "Received"
            cell.lblAmount.text = "+ \(ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00))"
            cell.lblAmount.textColor =  UIColor.init(hexString: UIConstants.COLOR_TRANSACTION_PLUS)
        } else {
            cell.lblTransactionType.text = "Transfered"
            cell.lblAmount.text = "- \(ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00))"
            cell.lblAmount.textColor =  UIColor.init(hexString: UIConstants.COLOR_TRANSACTION_MINE)
        }
        
        cell.lblSubTitle.text = transaction.reference
        if let formattedDate = Date().convertDateString(from: transaction.date ?? "") {
            cell.lblDate.text = formattedDate // Output: "18 Sep 2023"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.transactionVM.filteredTransactions.count
        self.transactionsTableView.backgroundView = nil
        if count == 0 {
            self.transactionsTableView.backgroundView = self.createEmptyMessageLabel()
        }
        return count
    }
}

// MARK: - Table View Delegate
extension TransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
