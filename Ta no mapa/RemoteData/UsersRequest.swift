//
//  UsersRequest.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

class UsersRequest {
    
    func users(success: @escaping (UsersModel) -> Void, errorResponse: @escaping (String) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "GET"
        request.addValue(Session.shared.XParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Session.shared.XParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                errorResponse(error!.localizedDescription)
                return
            }
            do {
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 403 {
                        errorResponse("Usuário inválido")
                        return
                    }
                }
                let decoded = try JSONDecoder().decode(UsersModel.self, from: data!)
                success(decoded)
            } catch {
                errorResponse("Deu error")
            }
        }
        task.resume()
    }
    
    func fetchMe(success: @escaping (Bool) -> Void, errorResponse: @escaping (String) -> Void) {
        
        guard let account = Session.shared.account else {
            errorResponse("Error in session")
            return
        }
        
        var urlComponents = URLComponents(string: "https://parse.udacity.com/parse/classes/StudentLocation")!
        urlComponents.queryItems = [
            URLQueryItem(name: "where", value: "{\"uniqueKey\":\"\(account.key)\"}")
        ]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue(Session.shared.XParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Session.shared.XParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                errorResponse(error!.localizedDescription)
                return
            }
            do {
                let decoded = try JSONDecoder().decode(UsersModel.self, from: data!)
                if let results = decoded.results {
                    if results.count > 0 {
                        success(true)
                    } else {
                        success(false)
                    }
                }
            } catch {
                errorResponse("Deu error")
            }
        }
        task.resume()
    }
    
}
