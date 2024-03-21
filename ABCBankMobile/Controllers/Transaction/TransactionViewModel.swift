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
    
    // Stores all transactions retrieved from the service.
    var allTransactionList: [Transaction] = []
    // Stores transactions filtered based on the selected transaction type.
    var filteredTransactions: [Transaction] = []
    // User details of the currently logged-in user.
    var user: UserDetails? = nil
    // DisposeBag used for memory management of RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Service objects for fetching transaction and user data.
    fileprivate var transactionService = TransactionService()
    fileprivate var userService = UserService()
    
    // Enum to define types of transactions for filtering purposes.
    enum TransactionType: String, Codable {
        case expenses = "minus" // Representing an expense transaction.
        case earnings = "plus" // Representing an earnings transaction.
    }
    
    // Current selected type of transaction for filtering.
    var transactionType: TransactionType = .expenses
    
    // Fetches user details and handles the response.
    func userDetails(onCompleted:@escaping(Observable<Error?>)->Void){
        // Retrieving the current user's email from the session manager.
        let user = UserSessionManager.sharedInstance.retrieveUser()
        // Requesting user details from the user service.
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData, error) in
                if let userInfo = userData{
                    if userInfo.success {
                        // Setting user details if the request was successful.
                        self.user = userInfo.data
                        // Callback with no error.
                        onCompleted(Observable.just(nil))
                    } else {
                        // Callback with an error if the request failed.
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // Callback with an error if there is an error in the response.
                    onCompleted(Observable.just(error ?? nil))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
    
    // Fetches the list of transactions and handles the response.
    func transactionList(onCompleted:@escaping(Observable<Error?>)->Void){
        // Retrieving the current user's UUID from the session manager.
        let user = UserSessionManager.sharedInstance.retrieveUser()
        // Requesting transaction list from the transaction service.
        transactionService.getAllTransactionService(uuid: user?.uuid ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData, error) in
                if let userInfo = userData{
                    if userInfo.success {
                        // Setting all transactions and applying default filter.
                        self.allTransactionList = userInfo.data
                        self.filterTransactions(by: .expenses)
                        // Callback with no error.
                        onCompleted(Observable.just(nil))
                    } else {
                        // Callback with an error if the request failed.
                        let error = Error(title: "Error", message: UIConstants.ERROR_MESSAGE_RESPONSE_ERROR)
                        onCompleted(Observable.just(error))
                    }
                } else {
                    // Callback with an error if there is an error in the response.
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag) // Disposing of the subscription to avoid memory leaks.
        }
    }
    
    // Filters the transactions based on the specified type.
    func filterTransactions(by type: TransactionType) {
        // Applying filter to the allTransactionList based on transaction type.
        filteredTransactions = allTransactionList.filter { $0.type == type.rawValue }
    }
}
