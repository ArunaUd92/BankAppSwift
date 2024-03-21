//
//  HomeViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation
import RxSwift

class HomeViewModel{
    
    // MARK: Properties
    
    // Stores details of the logged-in user.
    var user: UserDetails? = nil
    // Array to hold the list of transactions for the user.
    var transactionList: [Transaction] = []
    // DisposeBag used to manage the memory of RxSwift observables.
    fileprivate let bag = DisposeBag()
    // Service objects to fetch user and transaction data.
    fileprivate var userService = UserService()
    fileprivate var transactionService = TransactionService()
    
    
    // Function to fetch user details and handle the response.
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
    
    // Function to fetch the list of transactions and handle the response.
    func transactionList(onCompleted:@escaping(Observable<Error?>)->Void){
        // Retrieving the current user's UUID from the session manager.
        let user = UserSessionManager.sharedInstance.retrieveUser()
        // Requesting transactions from the transaction service.
        transactionService.getAllTransactionService(uuid: user?.uuid ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData, error) in
                if let userInfo = userData{
                    if userInfo.success {
                        // Setting transaction list if the request was successful.
                        self.transactionList = userInfo.data
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
    
}

