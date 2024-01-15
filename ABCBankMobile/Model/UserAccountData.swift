//
//  UserAccountData.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 03/01/2024.
//

import Foundation

struct UserDetails : Codable {
    let uuid : String?
    let name : String?
    let surname : String?
    let email : String?
    let phone:String?
    let address:String?
    let postalCode:String?
    let bankAccount : BankAccount?
    let payers : [Payee]?

    enum CodingKeys: String, CodingKey {

        case uuid = "uuid"
        case name = "name"
        case surname = "surname"
        case email = "email"
        case phone = "phone"
        case address = "address"
        case postalCode = "postalCode"
        case bankAccount = "bankAccount"
        case payers = "payers"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        surname = try values.decodeIfPresent(String.self, forKey: .surname)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        phone = try values.decodeIfPresent(String.self, forKey: .phone)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        postalCode = try values.decodeIfPresent(String.self, forKey: .postalCode)
        bankAccount = try values.decodeIfPresent(BankAccount.self, forKey: .bankAccount)
        payers = try values.decodeIfPresent([Payee].self, forKey: .payers)
    }

}

struct UserAccountData : Codable {
    let auth : Auth?
    let date : String?
    let uuid : String?
    let name : String?
    let surname : String?
    let email : String?
    let password : String?
    let roles : [String]?
    let _id : String?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case auth = "auth"
        case date = "date"
        case uuid = "uuid"
        case name = "name"
        case surname = "surname"
        case email = "email"
        case password = "password"
        case roles = "roles"
        case _id = "_id"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        auth = try values.decodeIfPresent(Auth.self, forKey: .auth)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        surname = try values.decodeIfPresent(String.self, forKey: .surname)
        email = try values.decodeIfPresent(String.self, forKey: .email)
        password = try values.decodeIfPresent(String.self, forKey: .password)
        roles = try values.decodeIfPresent([String].self, forKey: .roles)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }

}


struct BankAccount : Codable {
    let _id : String?
    let date : String?
    let name : String?
    let bankName : String?
    let accountNumber : String?
    let user : UserAccountData?
    let primary : Bool?
    let balance : String?
    let uuid : String?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case date = "date"
        case name = "name"
        case bankName = "bankName"
        case accountNumber = "accountNumber"
        case user = "user"
        case primary = "primary"
        case balance = "balance"
        case uuid = "uuid"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        user = try values.decodeIfPresent(UserAccountData.self, forKey: .user)
        primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
        balance = try values.decodeIfPresent(String.self, forKey: .balance)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }

}

struct Email : Codable {
    let valid : Bool?

    enum CodingKeys: String, CodingKey {

        case valid = "valid"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        valid = try values.decodeIfPresent(Bool.self, forKey: .valid)
    }

}

struct Auth : Codable {
    let email : Email?

    enum CodingKeys: String, CodingKey {

        case email = "email"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        email = try values.decodeIfPresent(Email.self, forKey: .email)
    }

}
