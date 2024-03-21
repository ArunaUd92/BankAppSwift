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

class CommonServiceModel{

    func loginService(email: String, password: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserData>?,Error?)>)->Void){
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
    
    func registerService(email: String, password: String, name: String, surname: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<UserRegister>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postRegister).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["email": email, "password": password, "name": name, "surname": surname]

        networkLayer.getResponseJSON(for: url!, method: .post, params: params) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserRegister>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error ?? nil)))
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
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .get, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<Verification>?, error: Error?)>) in
                        observable.subscribe(onNext: { response, error in
                            if let response = response{
                                onCompleted(Observable.just((response,nil)))
                            }else{
                                onCompleted(Observable.just((nil,error ?? nil)))
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
                                onCompleted(Observable.just((nil,error ?? nil)))
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


class PayTransferService {
    // Function to add a payee
    func addPayeeService(name: String, bankName: String, accountNumber: String, code: String, user: String, onCompleted: @escaping (_ observale: Observable<(UserResponse<UserData>?, Error?)>) -> Void) {
        // Prepare the URL for the API call, with percent encoding to handle special characters
        let url = URL(string: String(format: URLConstants.Api.Path.postAddPayer).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        // Prepare the parameters for the request
        let params: Parameters = ["name": name, "bankName": bankName, "accountNumber": accountNumber, "code": code, "user": user ]
        // Set the HTTP headers, including authorization headers
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]
        
        // Make a network request using the provided URL, method, parameters, and headers
        networkLayer.getResponseJSON(for: url!, method: .post, params: params, headers: headers) { dataObservable in
            // Subscribe to the observable to handle the response
            dataObservable.subscribe(onNext: { (data, error) in
                if let responseData = data {
                    // If data is received, use the translation layer to parse it
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<UserData>?, error: Error?)>) in
                        // Subscribe to the observable to handle the parsed data
                        observable.subscribe(onNext: { response, error in
                            if let response = response {
                                // If the response is successful, pass it to the completion handler
                                onCompleted(Observable.just((response, nil)))
                            } else {
                                // If there's an error in the response, pass the error to the completion handler
                                onCompleted(Observable.just((nil, error!)))
                            }
                        }).disposed(by: bag) // Dispose of the subscription to prevent memory leaks
                    }
                } else {
                    // If there's an error in the initial network request, pass the error to the completion handler
                    onCompleted(Observable.just((nil, error!)))
                }
            }).disposed(by: bag) // Dispose of the subscription to prevent memory leaks
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
    
    func deletePayee(uuid: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<DeleteTransaction>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.deletePayee, uuid.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .delete, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<DeleteTransaction>?, error: Error?)>) in
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
    
    func transactionService(amount: String, reference: String, from: String, to: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<Transaction>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.postTransaction).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let params: Parameters = ["from": from, "to": to, "amount": amount, "reference": reference]
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

class AdminService{
    
    func getCustomerListService(onCompleted:@escaping (_ observale:Observable<(UserResponse<CustomerList>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.getCustomerList).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .get, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<CustomerList>?, error: Error?)>) in
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
    
    func deleteCustomer(uuid: String, onCompleted:@escaping (_ observale:Observable<(UserResponse<DeleteTransaction>?,Error?)>)->Void){
        let url = URL(string: String(format: URLConstants.Api.Path.deleteCustomer, uuid.description).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        let headers: HTTPHeaders = UserSessionManager.sharedInstance.setAuthorizationHeader() ?? [:]

        networkLayer.getResponseJSON(for: url!, method: .delete, headers: headers) { dataObservable in
            dataObservable.subscribe(onNext: { (data,error) in
                if let responseData = data{
                    translationLayer.translationObject(from: responseData) { (observable: Observable<(response: UserResponse<DeleteTransaction>?, error: Error?)>) in
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
