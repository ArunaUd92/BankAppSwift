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
    
    
    
}
