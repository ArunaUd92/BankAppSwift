//
//  AllCustomerViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 17/01/2024.
//

import Foundation
import RxSwift
import PDFKit

class AllCustomerViewModel{
    
    // MARK: Properties
    // Properties for storing payee details
    var customerList: CustomerList? = nil

    
    fileprivate let bag = DisposeBag()
    fileprivate var adminService = AdminService()
    
    func getCustomerList(onCompleted:@escaping(Observable<Error?>)->Void){
        adminService.getCustomerListService() { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                            self.customerList = userInfo.data
                        
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
    
    func customerDelete(customerData: Customer, onCompleted:@escaping(Observable<Error?>)->Void){
        adminService.deleteCustomer(uuid: customerData.user?.uuid ?? "") { (registerDataObservable) in
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
    
}
