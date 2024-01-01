//
//  HomeViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit
import RxSwift

class HomeViewController: UIViewController {

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
    }
    
    func setupUI(){
        self.recentTransactionsTableView.layer.cornerRadius = 6
        self.lblCurrentDate.text = Date().getDescriptiveDateString()
    }
    
    func setUserData(){
        self.lblUserName.text = "\(homeVM.user?.name ?? "") \(homeVM.user?.surname ?? "")"
//        self.lblAccountNumber.text = ""
//        self.lblBalance.text = ""
    }
    
    func getUserData() {
        homeVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.setUserData()
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    func getTransactionList() {
        homeVM.transactionList {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.recentTransactionsTableView.reloadData()
                   
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }

}

// MARK: - Table View DataSource
extension HomeViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecentTransactionsTableViewCell", for: indexPath) as! RecentTransactionsTableViewCell
//        let transaction =  self.homeVM.transactionList[indexPath.row]
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
        return 82
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return self.homeVM.transactionList.count
        return 10
    }
}

// MARK: - Table View Delegate
extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
