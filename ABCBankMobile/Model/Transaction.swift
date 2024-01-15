//
//  Transaction.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 01/01/2024.
//

import Foundation

struct Transaction : Codable {
    let uuid : String?
    let date : String?
    let from : TransactionUserInfo?
    let to : TransactionUserInfo?
    let reference : String?
    let amount : String?
    let _id : String?
    let __v : Int?
    let type : String?

    enum CodingKeys: String, CodingKey {

        case uuid = "uuid"
        case date = "date"
        case from = "from"
        case to = "to"
        case reference = "reference"
        case amount = "amount"
        case _id = "_id"
        case __v = "__v"
        case type = "type"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        from = try values.decodeIfPresent(TransactionUserInfo.self, forKey: .from)
        to = try values.decodeIfPresent(TransactionUserInfo.self, forKey: .to)
        reference = try values.decodeIfPresent(String.self, forKey: .reference)
        amount = try values.decodeIfPresent(String.self, forKey: .amount)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }

}

struct TransactionUserInfo : Codable {
    let uuid : String?
    let date : String?
    let name : String?
    let bankName : String?
    let accountNumber : String?
    let balance : String?
    let user : UserAccountData?
    let primary : Bool?
    let _id : String?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case uuid = "uuid"
        case date = "date"
        case name = "name"
        case bankName = "bankName"
        case accountNumber = "accountNumber"
        case balance = "balance"
        case user = "user"
        case primary = "primary"
        case _id = "_id"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        balance = try values.decodeIfPresent(String.self, forKey: .balance)
        user = try values.decodeIfPresent(UserAccountData.self, forKey: .user)
        primary = try values.decodeIfPresent(Bool.self, forKey: .primary)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }

}

struct DeleteTransaction: Codable {
 

}

