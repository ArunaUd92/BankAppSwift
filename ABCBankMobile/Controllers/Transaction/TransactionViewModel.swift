//
//  File.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 01/01/2024.
//

import Foundation
import RxSwift

class TransactionViewModel{
    
    // MARK: Properties
    
    var transactionList: [Transaction] = []
    fileprivate let bag = DisposeBag()
    fileprivate var transactionService = TransactionService()
    
    
    func transactionList(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        transactionService.getAllTransactionService(uuid: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.transactionList = userInfo.data
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
