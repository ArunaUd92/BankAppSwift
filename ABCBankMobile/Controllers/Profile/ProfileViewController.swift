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
    // Text fields for user's profile information.
    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var txtAddress: UITextField!
    @IBOutlet weak var txtPhone: UITextField!
    @IBOutlet weak var txtPostalCode: UITextField!
    @IBOutlet weak var txtBirthday: UITextField!
    
    // MARK: Properties
    // Date picker for selecting the birthday.
    let datePicker = UIDatePicker()
    // ViewModel instance for managing profile data.
    fileprivate var profileVM = ProfileViewModel()
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    
    
    // Called when the view controller's view is loaded into memory.
    override func viewDidLoad() {
        super.viewDidLoad()
        setUserProfileData() // Populating initial user data in the view.
        setupDatePicker() // Initializing the date picker for birthday field.
    }
    
    // Called just before the view controller's view is displayed.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getUserData() // Fetches and updates user data.
    }
    
    // Sets up the date picker for the birthday text field.
    func setupDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        txtBirthday.placeholder = "Select a date"
        txtBirthday.inputView = datePicker
    }
    
    // Updates the birthday text field when the date picker value changes.
    @objc func dateChanged(datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy" // Desired date format.
        txtBirthday.text = dateFormatter.string(from: datePicker.date)
    }

    // MARK: Button event actions

    // Action for the 'Edit Profile' button tap.
    @IBAction func editProfileButtonTapped(_ sender: Any) {
        self.editProfileUpdate() // Initiates the profile update process.
    }
    
    // Action for the 'Sign Out' button tap.
    @IBAction func signoutButtonTapped(_ sender: Any) {
        self.showAlertSignout() // Shows the sign-out confirmation alert.
    }
    
    // Fetches user data and updates the view.
    func getUserData() {
        self.showProgress() // Shows a loading indicator.
        profileVM.userDetails {observable in
            observable.subscribe(onNext: { error in
                if let error = error {
                    // Handles error scenario.
                    self.hideProgress()
                    MessageViewPopUp.showMessage(type: MessageViewPopUp.ErrorMessage, title: "Error", message: error.message)
                } else {
                    // Updates UI with user data on successful fetch.
                    self.hideProgress()
                    self.setUserProfileData()
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
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
