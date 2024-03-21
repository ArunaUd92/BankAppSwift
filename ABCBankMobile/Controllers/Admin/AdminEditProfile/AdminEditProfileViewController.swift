//
//  AdminEditProfileViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 19/01/2024.
//

import UIKit
import RxSwift

class AdminEditProfileViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    // MARK: Properties
    let datePicker = UIDatePicker()
    fileprivate var adminEditProfileVM = AdminEditProfileViewModel()
    fileprivate let bag = DisposeBag()
    
    var customerData: Customer? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.adminEditProfileVM.customerDetails = customerData
        setUserProfileData()
        setupDatePicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData()
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
        self.editProfileUpdate()
    }
    
    // Function triggered when the back button is tapped
    @IBAction func backButtonTapped(_ sender: Any) {
        // Dismisses the current view controller
        self.dismiss(animated: true, completion: nil)
    }
    
    func getUserData() {
        self.showProgress()
        adminEditProfileVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handle the error scenario
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Here you can update your UI or process the data
                    // Handle the success scenario
                    self.hideProgress()
                    self.setUserProfileData()
                }
            }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
        }
    }
    
    private func editProfileUpdate(){
        
        adminEditProfileVM.name = self.txtFirstName.text
        adminEditProfileVM.surName = self.txtLastName.text
        adminEditProfileVM.address = self.txtAddress.text
        adminEditProfileVM.postalCode = self.txtPostalCode.text
        adminEditProfileVM.birthDay = self.txtBirthday.text
        
        adminEditProfileVM.profileUpdateValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                self.showProgress()
                adminEditProfileVM.userProfileUpdate {observable in
                    observable.subscribe(onNext: { error in
                        if let error = error {
                            // Handle the error scenario
                            self.hideProgress()
                            MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                        } else {
                            // Here you can update your UI or process the data
                            // Handle the success scenario
                            self.hideProgress()
                            
                        }
                    }).disposed(by: self.bag) // Assuming 'bag' is a DisposeBag for RxSwift
                }
                
            } else {
                self.hideProgress()
                MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: errorMessage)
            }
        });
        
    }
    
    private func setUserProfileData(){
        
        let user = adminEditProfileVM.customerDetails
        self.txtFirstName.text = user?.user?.name
        self.txtLastName.text = user?.user?.surname

    }
}
