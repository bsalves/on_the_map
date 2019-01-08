//
//  LoginModel.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

struct LoginModel {
    
    struct Request: Codable {
        var username: String
        var password: String
    }
    
    struct Response: Codable {
        var account: AccountModel
        var session: SessionModel
    }
    
}
