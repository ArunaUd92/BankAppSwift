//
//  CommonViewModel.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.

import Foundation
import RxSwift
import Alamofire

fileprivate var bag = DisposeBag()
fileprivate let networkLayer = NetworkLayerIMPL()
fileprivate let translationLayer = TranslationLayer()

class CommonViewModel{

    func loginResponse(email: String, password: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postLogin).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["email": email, "password": password]
        
        networkLayer.getResponseJSON(for: url!, method: .post, params: params) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func registerResponse(email: String, password: String, name: String, surname: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postRegister).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["email": email, "password": password, "name": name, "surname": surname]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func verificationService(code: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<Verification>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getVerificationCode, code.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

        networkLayer.getResponseJSON(for: url!, method: .get) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<Verification>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func resendCodeService(email: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<Verification>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getResendCode, email.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)

        networkLayer.getResponseJSON(for: url!, method: .get) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<Verification>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    
}


class UserService{
   
    func userDetailsService(email: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserDetails>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getUserDetails, email.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .get, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserDetails>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func updateProfileService(email: String, phone: String, name: String, surname: String, birthday: String, address: String, postalCode: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postProfileUpdate).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["name": name, "surname": surname, "email": email, "phone": phone, "birthdaydate": birthday, "Address": address, "postalCode" : postalCode ]
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
}


class PayTransferService{
    
    
    func addPayeeService(name: String, bankName: String, accountNumber: String, code: String, user: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postAddPayer).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["name": name, "bankName": bankName, "accountNumber": accountNumber, "code": code, "user": user ]
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    
    func getPayeeListService(uuid: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<[Payee]>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getPayerList, uuid.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .get, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<[Payee]>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func deletePayee(uuid: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.deletePayee).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["name": uuid ]
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
}


class TransactionService{
    
    func getAllTransactionService(uuid: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<[Transaction]>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getAllTransactionList, uuid.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .get, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<[Transaction]>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
    
    func transactionService(amount: String, reference: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<Transaction>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postTransaction).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["amount": amount, "reference": reference]
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<Transaction>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error!)))
                            }
                        }).disposed(by: bag)
                    }
                }else{
                    onCompleted(Observable.just((nil,error!)))
                }
            }).disposed(by: bag)
        }
    }
}
