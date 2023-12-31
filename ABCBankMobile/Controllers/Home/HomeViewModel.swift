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
    
    var user:UserDetails? = nil
    fileprivate let bag = DisposeBag()
    fileprivate var userService = UserService()
    
    
    func userDetails(onCompleted:@escaping(Observable<Error?>)->Void){
        let user = UserSessionManager.sharedInstance.retrieveUser()
        userService.userDetailsService(email: user?.email ?? "") { (userDataObservable) in
            userDataObservable.subscribe(onNext: { (userData,error) in
                if let userInfo = userData{
                    if userInfo.success {
                        self.user = userInfo.data
                        onCompleted(Observable.just(nil))
                    } else {
                        let error = Error(title: "Error", message: "Error")
                        onCompleted(Observable.just(error))
                    }
                }else{
                    onCompleted(Observable.just(error!))
                }
            }).disposed(by: self.bag)
        }
    }
    
}
