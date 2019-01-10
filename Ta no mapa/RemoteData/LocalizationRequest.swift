//
//  LocalizationRequest.swif
//  Ta no mapa
//
//  Created by Bruno Alves on 09/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import Foundation

class LocalizationRequest {
    
    func postNewLocation(localization: LocalizationModel, success: @escaping () -> Void, errorResponse: @escaping (String) -> Void) {
        
        var request = URLRequest(url: URL(string: "https://parse.udacity.com/parse/classes/StudentLocation")!)
        request.httpMethod = "POST"
        request.addValue(Session.shared.XParseApplicationId, forHTTPHeaderField: "X-Parse-Application-Id")
        request.addValue(Session.shared.XParseRESTAPIKey, forHTTPHeaderField: "X-Parse-REST-API-Key")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONEncoder().encode(localization)
        } catch {
            errorResponse("fail to send data")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if error != nil {
                errorResponse(error!.localizedDescription)
                return
            }
            do {
                success()
            } catch {
                errorResponse("Deu error")
            }
        }
        task.resume()
    }
    
}
