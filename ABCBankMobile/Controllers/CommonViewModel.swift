//
//  CommonViewModel.swift
//  YTS
//
//  Created by Sajith Konara on 5/2/20.
//  Copyright © 2020 Sajith Konara. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class CommonViewModel{
    
    fileprivate var bag = DisposeBag()
   // fileprivate var modelLayer:ModelLayerIMPL
    fileprivate let networkLayer = NetworkLayerIMPL()
    fileprivate let translationLayer = TranslationLayer()
    
//    init(modelLayer:ModelLayerIMPL) {
//        self.modelLayer = modelLayer
//    }
    
     func loginResponse(onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postLogin).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["email": "user4@mail.com", "password": "123456",]
       // let headers: HTTPHeaders = [:]
        
        networkLayer.getResponseJSON(for: url!, method: .post, params: params) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    self.translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: self.bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: self.bag)
        }
    }
    
}
