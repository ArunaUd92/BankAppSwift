//
//  PayTransferViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import UIKit

class PayTransferViewController: UIViewController {

    @IBOutlet weak var payeesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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

}

// MARK: - Table View DataSource
extension PayTransferViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PayeeTableViewCell", for: indexPath) as! PayeeTableViewCell
        
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
extension PayTransferViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let paymentViewController = storyboard.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
        paymentViewController.modalPresentationStyle = .overFullScreen
        self.present(paymentViewController, animated: true, completion: nil)
    }
}
