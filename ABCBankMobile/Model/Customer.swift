//
//  Customer.swift
//  ABCBankMobile
//
//  Created by Aruna Udayanga on 17/01/2024.
//

import Foundation

struct Customer : Codable {
    let user : UserAccountData?
    let bankAccount : BankAccount?

    enum CodingKeys: String, CodingKey {

        case user = "user"
        case bankAccount = "bankAccount"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        user = try values.decodeIfPresent(UserAccountData.self, forKey: .user)
        bankAccount = try values.decodeIfPresent(BankAccount.self, forKey: .bankAccount)
    }

}

struct CustomerList : Codable {
    let users : [Customer]?

}
