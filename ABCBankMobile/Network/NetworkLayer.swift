//
//  MovieServiceLayer.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 20/12/2023.
//

import Foundation
import RxSwift
import Alamofire

protocol NetworkLayer {
    typealias DataObservable = (_ observable:Observable<(data:Data?,error:Error?)>)->Void
    func getResponseJSON(for url:URL, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?, onCompleted:@escaping DataObservable)
}

class NetworkLayerIMPL:NetworkLayer{
    
    fileprivate let bag = DisposeBag()
    
    func getResponseJSON(for url: URL, method: HTTPMethod, params: Parameters? = nil, headers: HTTPHeaders? = nil,  onCompleted: @escaping (Observable<(data: Data?, error: Error?)>) -> Void) {
        ServiceManagerIMPL.APIRequest(url: url, method: method, params: params, headers: headers) { responseObservable in
            responseObservable.subscribe(onNext: { responseData,responseCode in
                if responseCode == 200{
                    onCompleted(Observable.just((responseData!,nil)))
                }else if responseCode == 999{
                    let error = Error(title: "No Connectivity!", message: "You are appear to be offline.")
                    onCompleted(Observable.just((nil,error)))
                }else{
                    let error = Error(title: "Data Error!", message: "Something went wrong while retrieving data.")
                    onCompleted(Observable.just((nil,error)))
                }
            }).disposed(by: self.bag)
        }
    }
}
