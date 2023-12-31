//
//  TransactionViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit

class TransactionViewController: UIViewController {

    // MARK: Outlets
    @IBOutlet weak var transactionsTableView: UITableView!
    @IBOutlet weak var lblAccountNumber: UILabel!
    @IBOutlet weak var lblBalance: UILabel!
    @IBOutlet weak var btnExpenses: UIButton!
    @IBOutlet weak var btnEarnings: UIButton!
    
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

}

// MARK: - Table View DataSource
extension TransactionViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

// MARK: - Table View Delegate
extension TransactionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
