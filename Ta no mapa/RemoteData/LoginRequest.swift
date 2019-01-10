//
//  LoginRequest.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

class LoginRequest {
    
    func login(username: String, password: String, success: @escaping (LoginModel.Response) -> Void, errorResponse: @escaping (String) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/session")!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: String.Encoding.utf8)

        let session = URLSession.shared

        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            
            if error != nil {
                errorResponse(error!.localizedDescription)
                return
            }
            
            do {
                
                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        errorResponse("Usuário inválido")
                        return
                    }
                }
                
                let str = String(data: data!, encoding: String.Encoding.utf8) as String?
                let sliced = String((str?.dropFirst(5))!)
                let finalData = sliced.data(using: String.Encoding.utf8)
                let decoded = try JSONDecoder().decode(LoginModel.Response.self, from: finalData!)
                
                Session.shared.account = decoded.account
                Session.shared.session = decoded.session
                
                success(decoded)
            } catch {
            }
        }
        task.resume()
        
    }
    
}
