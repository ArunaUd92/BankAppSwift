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
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var recentTransactionsTableView: UITableView!
    @IBOutlet weak var lblCurrentDate: UILabel!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    
    fileprivate var homeVM = HomeViewModel()
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
        self.recentTransactionsTableView.layer.cornerRadius = 6
        self.lblCurrentDate.text = Date().getDescriptiveDateString()
    }
    
    func setUserData(){
        self.lblUserName.text = "\(homeVM.user?.name ?? "") \(homeVM.user?.surname ?? "")"
        self.lblAccountNumber.text = "Account Number: \(homeVM.user?.bankAccount?.accountNumber ?? "")"
        let amountConvertToDouble = Double(homeVM.user?.bankAccount?.balance ?? "")
        self.lblBalance.text = ValidatorHelper.formatAsCurrency(amountConvertToDouble ?? 0.00)
    }
    
    func getUserData() {
        self.showProgress()
        homeVM.userDetails {observable in
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
        homeVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.hideProgress()
                    self.recentTransactionsTableView.reloadData()
                   
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
extension HomeViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
        let transaction =  self.homeVM.transactionList[indexPath.row]
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
        return 82
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = self.homeVM.transactionList.count
        self.recentTransactionsTableView.backgroundView = nil
        if count == 0 {
            self.recentTransactionsTableView.backgroundView = self.createEmptyMessageLabel()
        }
        return count
    }
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
