//
//  ProfileViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDatePicker()
        
    }
    
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        txtBirthday.placeholder = "Select a date"
        txtBirthday.inputView = datePicker
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Set your desired format
        txtBirthday.text = dateFormatter.string(from: datePicker.date)
    }


    // MARK: Button event action
    //Edit profile event button click.
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        
    }

}
