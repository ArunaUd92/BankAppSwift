//
//  User.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 29/12/2023.
//

import Foundation


struct UserResponse<T: Decodable>: Decodable {
    var success: Bool
    var message: String
    var data: T
}

struct UserData: Codable {
    var token: Token?
    var user: User?
    var response: String?
    var status: Int?
    var message: String?

}

struct Token: Codable {
    var expires_in: Int
    var access_token: String
}

struct User: Codable {
    var uuid: String
    var name: String
    var surname: String
    var email: String
}
