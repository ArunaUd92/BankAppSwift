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
    var name: String? = ""
    var surName: String? = ""
    var email: String? = ""
    var phone: String? = ""
    var address: String? = ""
    var postalCode: String? = ""
    var birthDay: String? = ""
    
    fileprivate let bag = DisposeBag()
    fileprivate var userService = UserService()
    
    // MARK: Functions
    // signup validation
    func profileUpdateValidation(validationHandler: (String, Bool)->()) {
        guard let name = name, !name.isEmpty else {
            validationHandler("First Name field cannot be empty.", false)
            return
        }
        
        guard let surName = surName, !surName.isEmpty else {
            validationHandler("Last Name field cannot be empty.", false)
            return
        }
        
        guard let phone = phone, !phone.isEmpty else {
            validationHandler("Phone field cannot be empty.", false)
            return
        }
        
        guard let address = address, !address.isEmpty else {
            validationHandler("Address field cannot be empty.", false)
            return
        }
        
        guard let postalCode = postalCode, !postalCode.isEmpty else {
            validationHandler("Postal code field cannot be empty.", false)
            return
        }
        
        guard let birthDay = birthDay, !birthDay.isEmpty else {
            validationHandler("birthDay field cannot be empty.", false)
            return
        }
        
        validationHandler("Validation Sucess", true)
    }
    
    func userProfileUpdate(onCompleted:@escaping(Observable<Error?>)->Void){
        userService.updateProfileService(email: email ?? "", phone: phone ?? "", name: name ?? "", surname: surName ?? "", birthday: birthDay ?? "", address: address ?? "", postalCode: postalCode ?? "") { (registerDataObservable) in
            registerDataObservable.subscribe(onNext: { (registerData,error) in
                if let registerInfo = registerData{
                    if registerInfo.success {
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                }else{
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag)
        }
    }
    
    func userSignout(){
        UserSessionManager.sharedInstance.removeToken()
        UserSessionManager.sharedInstance.removeUser()
    }
    
}
