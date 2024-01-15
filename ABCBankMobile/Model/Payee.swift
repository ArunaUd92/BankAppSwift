//
//  Payee.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 31/12/2023.
//

import Foundation


struct Payee: Codable {
    let _id : String?
    let uuid : String?
    let name : String?
    let bankName : String?
    let accountNumber : String?
    let code : String?
    let date : String?
    let user : UserAccountData?
    let __v : Int?

    enum CodingKeys: String, CodingKey {

        case _id = "_id"
        case uuid = "uuid"
        case name = "name"
        case bankName = "bankName"
        case accountNumber = "accountNumber"
        case code = "code"
        case date = "date"
        case user = "user"
        case __v = "__v"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        _id = try values.decodeIfPresent(String.self, forKey: ._id)
        uuid = try values.decodeIfPresent(String.self, forKey: .uuid)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        bankName = try values.decodeIfPresent(String.self, forKey: .bankName)
        accountNumber = try values.decodeIfPresent(String.self, forKey: .accountNumber)
        code = try values.decodeIfPresent(String.self, forKey: .code)
        date = try values.decodeIfPresent(String.self, forKey: .date)
        user = try values.decodeIfPresent(UserAccountData.self, forKey: .user)
        __v = try values.decodeIfPresent(Int.self, forKey: .__v)
    }
}
