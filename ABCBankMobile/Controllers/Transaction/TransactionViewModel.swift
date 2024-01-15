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
    
    var allTransactionList: [Transaction] = []
    var filteredTransactions: [Transaction] = []
    var user:UserDetails? = nil
    fileprivate let bag = DisposeBag()
    fileprivate var transactionService = TransactionService()
    fileprivate var userService = UserService()
    
    enum TransactionType: String, Codable {
        case expenses = "minus"
        case earnings = "plus"
    }
    
    var transactionType: TransactionType = .expenses
    
    func userDetails(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.user = userInfo.data
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                }else{
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag)
        }
    }
    
    func transactionList(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        transactionService.getAllTransactionService(uuid: user?.uuid ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.allTransactionList = userInfo.data
                        self.filterTransactions(by: .expenses) // Default filter
                                  
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
    
    func filterTransactions(by type: TransactionType) {
        filteredTransactions = allTransactionList.filter { $0.type == type.rawValue }
    }
}
