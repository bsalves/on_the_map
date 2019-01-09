//
//  UsersResultModel.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 08/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

class UsersResultModel: Codable {
    
    var objectId: String?
    var uniqueKey: String?
    var firstName: String?
    var lastName: String?
    var mapString: String?
    var mediaURL: String?
    var latitude: Double?
    var longitude: Double?
    
}
