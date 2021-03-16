//
//  SearchOrderApi.swift
//  themustang
//
//  Created by Ashik Chalise on 10/1/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class SearchOrderApi {

    func searchData(parameters:[String: AnyObject], completion: @escaping (responseCompletion<[RecentOrder]?>)) {
        let url = FILTER_ORDER
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let order = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: order)
                    print(json)
                    
                    if (response.response?.statusCode) == 200 {
                        let order = self.parseSearchManual(json: json)
                        completion(order,nil)
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
    
    
    private func parseSearchManual(json:JSON)-> [RecentOrder]{
      
        let filterArray = json["orders"]
         var filter = [RecentOrder]()
         if filterArray.count > 0 {
             for i in 0...filterArray.count-1{
                filter.append(RecentOrder(order_id: filterArray[i]["order_id"].intValue,
                                         customer_name: filterArray[i]["customer_name"].stringValue,
                                         customer_address: filterArray[i]["customer_address"].stringValue,
                                         ordered_at: filterArray[i]["ordered_at"].stringValue,
                                         delivery_or_pickup_status: filterArray[i]["delivery_or_pickup_status"].intValue,
                                         payment_status: filterArray[i]["payment_status"].intValue,
                                         payment_type: filterArray[i]["payment_type"].intValue,
                                         image: filterArray[i]["image"].stringValue,
                                         total: filterArray[i]["total"].stringValue))
             }
         }
         return filter
        
        
    }
    
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    
    

}
