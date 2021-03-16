//
//  LogoutApi.swift
//  themustang
//
//  Created by Ashik Chalise on 10/4/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LogoutApi {

    func logout(parameters:[String: AnyObject], completion: @escaping (responseCompletion<Logout?>)) {
        let url = LOGOUT
        AF.request(url, method: .post, parameters: parameters , headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let user_logout = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: user_logout)
                    print("message \(json)")
                    
                    if (response.response?.statusCode) == 200 {
                        let user_logout = self.parseUserOutManual(json: json)
                        completion(user_logout,nil)
                    }else if(response.response?.statusCode) == 401{
                        let errors = self.errorHandel(json: json)
                        completion(nil,errors)
                    }
                }catch{
                    debugPrint(error.localizedDescription)
                    completion(nil,nil)
                }
                
                
                break
            case .failure:
                completion(nil,nil)
                return
            }
        }
    }
    
    
    private func parseUserOutManual(json:JSON)-> Logout{
        let message = json["message"].stringValue
        return Logout(message: message)
    }
    
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    
    
    
}
