//
//  TranslationLayer.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation
import RxSwift

class TranslationLayer{
    
    func translationObject<T: Decodable>(from responseData: Data, onCompleted: @escaping (_ observable: Observable<(response: T?, error: Error?)>) -> Void) {
        let decoder = JSONDecoder()
        do {
            let response = try decoder.decode(T.self, from: responseData)
            onCompleted(Observable.just((response, nil)))
        } catch let error {
            let customError = Error(title: "Translation Error!", message: "Something went wrong while translating data.")
            onCompleted(Observable.just((nil, customError)))
            print(error)
        }
    }
    
}
