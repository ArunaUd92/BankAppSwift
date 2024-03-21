//
//  AdminPortalViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 14/01/2024.
//

import UIKit

class AdminPortalViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    //All Customer event button click.
    @IBAction func allCustomerButtonTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Admin", bundle: nil)
        let allCustomerListViewController = storyboard.instantiateViewController(withIdentifier: "AllCustomerListViewController") as! AllCustomerListViewController
        allCustomerListViewController.modalPresentationStyle = .overFullScreen
        self.present(allCustomerListViewController, animated: true, completion: nil)
    }
    
    //Create Account event button click.
    @IBAction func createAccountButtonTapped(_ sender: Any) {
        
    }
    

}
