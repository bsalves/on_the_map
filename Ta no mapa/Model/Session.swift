//
//  Session.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

class Session {
    
    var data: LoginModel.Response!
    static var shared = Session()
    private init () {}
    
}
