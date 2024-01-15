//
//  ViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 20/12/2023.
//

import UIKit
//import NVActivityIndicatorView

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    //MARK: - Progress
    func showProgress(){
        NVActivityIndicator.startActivity(self.view, indicatorType: NVActivityIndicatorType.ballSpinFadeLoader)
    }
    
    func hideProgress(){
        NVActivityIndicator.stopActivity(self.view)
    }

}

