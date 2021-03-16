//
//  OrderDetailApi.swift
//  themustang
//
//  Created by Ashik Chalise on 9/4/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class OrderDetailApi {

    func orderDetail(id: Int, completion: @escaping (responseCompletion<OrderDetail?>)){
        
        guard let url = URL(string: "\(ORDER_DETAIL_URL)\(id)") else{ return }
        
        print("url: \(url)")

        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let home = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: home)
                    if (response.response?.statusCode) == 200 {
                        let home = self.parseOrderDetailManual(json: json)
                        completion(home,nil)
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
    
    private func parseOrderDetailManual(json:JSON)-> OrderDetail{
        let order = json["order"].stringValue
        return OrderDetail(order: order)
    }
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    

}
