//
//  ProfileViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class ProfileViewModel{
    
    // MARK: Properties
    // Profile fields to be used for updating user details.
    var name: String? = ""
    var surName: String? = ""
    var email: String? = ""
    var phone: String? = ""
    var address: String? = ""
    var postalCode: String? = ""
    var birthDay: String? = ""
    
    // DisposeBag for managing the RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Service object for interacting with user-related data.
    fileprivate var userService = UserService()
    // Model to store current user details.
    var user: UserDetails? = nil
    
    // MARK: Functions
    
    // Validates the profile update fields.
    func profileUpdateValidation(validationHandler: (String, Bool)->()) {
        // Validation checks for each field.
        // If any field is empty, it returns a corresponding error message.
        guard let name = name, !name.isEmpty else {
            validationHandler("First Name field cannot be empty.", false)
            return
        }
        
        // ... [similar validation for other fields]

        // If all validations pass, the handler is called with a success status.
        validationHandler("Validation Success", true)
    }
    
    // Performs the profile update operation.
    func userProfileUpdate(onCompleted:@escaping(Observable<Error?>)->Void){
        // Calling the service to update the user's profile with the provided details.
        userService.updateProfileService(email: email ?? "", phone: phone ?? "", name: name ?? "", surname: surName ?? "", birthday: birthDay ?? "", address: address ?? "", postalCode: postalCode ?? "") { (registerDataObservable) in
            registerDataObservable.subscribe(onNext: { (registerData, error) in
                // Processing the response from the service.
                if let registerInfo = registerData{
                    // If the update is successful, an Observable with nil error is returned.
                    if registerInfo.success {
                        onCompleted(Observable.just(nil))
                    } else {
                        // If the update fails, an Observable with an error message is returned.
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // In case of an unexpected error, it is returned.
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
    
    // Fetches user details.
    func userDetails(onCompleted:@escaping(Observable<Error?>)->Void){
        // Retrieving the current user's email from the session manager.
        let user = UserSessionManager.sharedInstance.retrieveUser()
        // Requesting user details from the user service.
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData, error) in
                // Processing the response from the service.
                if let userInfo = userData{
                    // If user details are successfully fetched, update the user model.
                    if userInfo.success {
                        self.user = userInfo.data
                        onCompleted(Observable.just(nil))
                    } else {
                        // If the fetch fails, an Observable with an error message is returned.
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // In case of an unexpected error, it is returned.
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag)
        }
    }

    // Handles user sign-out logic.
    func userSignout(){
        // Removes user's token and details from the session manager.
        UserSessionManager.sharedInstance.removeToken()
        UserSessionManager.sharedInstance.removeUser()
    }
    
}
