//
//  UserSessionManager.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 30/12/2023.
//

import Foundation
import Alamofire

class UserSessionManager {
    
    static let sharedInstance = UserSessionManager()
    
    func saveToken(_ token: Token) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(token) {
            UserDefaults.standard.set(encoded, forKey: "token")
        }
    }

    func saveUser(_ user: User) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(user) {
            UserDefaults.standard.set(encoded, forKey: "user")
        }
    }
    
    func retrieveToken() -> Token? {
        if let tokenData = UserDefaults.standard.data(forKey: "token") {
            let decoder = JSONDecoder()
            if let token = try? decoder.decode(Token.self, from: tokenData) {
                return token
            }
        }
        return nil
    }

    func retrieveUser() -> User? {
        if let userData = UserDefaults.standard.data(forKey: "user") {
            let decoder = JSONDecoder()
            if let user = try? decoder.decode(User.self, from: userData) {
                return user
            }
        }
        return nil
    }

    func setAuthorizationHeader() -> HTTPHeaders? {
        if let token = retrieveToken() {
            let headers: HTTPHeaders = [
                "Authorization": "Bearer \(token.access_token)",
                "Accept": "application/json"
            ]
            return headers
        } else {
            print("Token not found.")
            return nil
        }
    }
}
