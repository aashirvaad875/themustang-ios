//
//  Services.swift
//  themustang
//
//  Created by Ashik Chalise on 8/26/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

//import Foundation
//import SwiftyJSON
//import Alamofire
//
//class Services{
//
//    let baseUrl = "https://themustangcanberra.com.au/api/"
//
//    init() {
//
//    }
//
//    func login(parameters:[String: AnyObject], completion:@escaping (_ callback:JSON)->())  {
//        let loginUrl = baseUrl + "login"
//        AF.request(loginUrl, method: .post, parameters: parameters).responseJSON { response in
//            if let json = response{
//               completion(JSON(json))
//            }
//        }
//
//
//    }
//
//}
