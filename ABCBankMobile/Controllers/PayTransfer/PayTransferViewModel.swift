//
//  PayTransferViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class PayTransferViewModel{
    
    // MARK: Properties
    // Properties for storing payee details
    var payeeList: [Payee] = []

    
    fileprivate let bag = DisposeBag()
    fileprivate var payTransferService = PayTransferService()
    
    func payeeList(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        payTransferService.getPayeeListService(uuid: user?.uuid ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.payeeList = userInfo.data
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
    
    func payeeDelete(payee: Payee, onCompleted:@escaping(Observable<Error?>)->Void){
        payTransferService.deletePayee(uuid: payee.uuid ?? "") { (registerDataObservable) in
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
