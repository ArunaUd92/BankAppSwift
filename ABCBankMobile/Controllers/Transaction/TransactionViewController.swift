//
//  TransactionViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit
import RxSwift

class TransactionViewController: UIViewController {

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
    

    func setupUI(){
        self.transactionsTableView.layer.cornerRadius = 6
        self.updateButtonStates(selectedButton: self.btnExpenses, otherButton: self.btnEarnings)
    }
    
    
    @IBAction func expensesButtonTapped(_ sender: UIButton) {
        if sender == self.btnExpenses {
            updateButtonStates(selectedButton: self.btnExpenses, otherButton: btnEarnings)
        }
    }
    
    @IBAction func earningsButtonTapped(_ sender: UIButton) {
        if sender == self.btnEarnings {
            updateButtonStates(selectedButton: self.btnEarnings, otherButton: self.btnExpenses)
        }
    }
    
    func updateButtonStates(selectedButton: UIButton, otherButton: UIButton) {
        selectedButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_BLUE), for: .normal)// Selected color
        otherButton.setTitleColor(UIColor.init(hexString: UIConstants.COLOR_APP_GARY), for: .normal)// Non-selected color
    }
    
    func getTransactionList() {
        transactionVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.transactionsTableView.reloadData()
                   
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }

}

// MARK: - Table View DataSource
extension TransactionViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
//        let transaction =  self.transactionVM.transactionList[indexPath.row]
//        cell.lblTransactionType.text = ""
//        cell.lblSubTitle.text = ""
//        cell.lblAmount.text = ""
//        
//        if let formattedDate = Date().convertDateString("18-09-2023") {
//            cell.lblDate.text = formattedDate // Output: "18 Sep 2023"
//        }
//        
//        cell.lblAmount.text =  ValidatorHelper.formatAsCurrency(9200.00)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return self.transactionVM.transactionList.count
        return 10
    }
}

// MARK: - Table View Delegate
extension TransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
