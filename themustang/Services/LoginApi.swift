//
//  LoginApi.swift
//  themustang
//
//  Created by Ashik Chalise on 8/26/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class LoginApi {

    func login(parameters:[String: AnyObject], completion: @escaping (responseCompletion<User?>)) {
        let url = LOGIN_URL
        AF.request(url, method: .post, parameters: parameters).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let user = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: user)
                    if (response.response?.statusCode) == 200 {
                        let user = self.parseUserManual(json: json)
                        completion(user,nil)
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
    
    
    private func parseUserManual(json:JSON)-> User{
        let id = json["user"]["id"].intValue
        let name = json["user"]["name"].stringValue
        let email = json["user"]["email"].stringValue
        let token = json["user"]["token"].stringValue
        return User(id: id, name: name, email: email, token: token)
    }
    
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    
    
    
}
