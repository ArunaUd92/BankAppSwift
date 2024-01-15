//
//  ProfileViewController.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import UIKit
import RxSwift

class ProfileViewController: BaseViewController {

    // MARK: Outlets
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    // MARK: Properties
    let datePicker = UIDatePicker()
    fileprivate var profileVM = ProfileViewModel()
    fileprivate let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func signoutButtonTapped(_ sender: Any) {
        self.showAlertSignout()
    }
    
    func getUserData() {
        self.showProgress()
        profileVM.userDetails {observable in
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
        
        profileVM.name = self.txtFirstName.text
        profileVM.surName = self.txtLastName.text
        profileVM.email = self.txtEmail.text
        profileVM.phone = self.txtPhone.text
        profileVM.address = self.txtAddress.text
        profileVM.postalCode = self.txtPostalCode.text
        profileVM.birthDay = self.txtBirthday.text
        
        profileVM.profileUpdateValidation(validationHandler:{ errorMessage, isStatus in
            if(isStatus){
                self.showProgress()
                profileVM.userProfileUpdate {observable in
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
        
        let user = profileVM.user
        self.txtFirstName.text = user?.name
        self.txtLastName.text = user?.surname
        self.txtEmail.text = user?.email
        self.txtAccountNumber.text = user?.bankAccount?.accountNumber ?? ""
//        self.txtPhone.text = user.
//        self.txtAddress.text =
//        self.txtPostalCode.text =
//        self.txtBirthday.text = user.
    }


   private func showAlertSignout(){
        // Create the alert controller
        let alert = UIAlertController(title: "Signing Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        // Create the action
        let action = UIAlertAction(title: "Sign out", style: .destructive, handler: { (action) in
            // This code will be executed when the 'OK' button is tapped
            self.profileVM.userSignout()
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let signupViewController = storyboard.instantiateViewController(withIdentifier: "LoginNavigationController") as! LoginNavigationController
            signupViewController.modalPresentationStyle = .overFullScreen
            self.present(signupViewController, animated: true, completion: nil)
            
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        // Add the action to the alert controller
        alert.addAction(action)
        // Present the alert
        self.present(alert, animated: true, completion: nil)
    }
}
