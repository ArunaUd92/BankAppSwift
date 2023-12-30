//
//  ServiceManager.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 20/12/2023.
//

import Foundation
import Alamofire
import RxSwift

protocol ServiceManager {
    typealias onAPIRxResponse = (_ observable: Observable<(Data?, Int)>) -> Void
    static func APIRequest(url: URL, method: HTTPMethod, params: Parameters?, headers: HTTPHeaders?, onResponse: @escaping onAPIRxResponse)
}

class ServiceManagerIMPL: ServiceManager {
    static func APIRequest(url: URL, method: HTTPMethod, params: Parameters? = nil, headers: HTTPHeaders? = nil, onResponse: @escaping onAPIRxResponse) {
        
        if ReachabilityManager.isConnectedToNetwork() {
            AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers, interceptor: nil).responseJSON { response in
                if let statusCode = response.response?.statusCode {
                    onResponse(Observable.just((response.data, statusCode)))
                }
            }
        } else {
            onResponse(Observable.just((nil, 999)))
        }
    }
}

