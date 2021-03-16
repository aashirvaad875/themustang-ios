//
//  OrderApi.swift
//  themustang
//
//  Created by Ashik Chalise on 9/9/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class OrderApi {
    
    func orderFun(completion: @escaping (responseCompletion<[Order]?>)){
        
        let url = ORDER_URL
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let order = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: order)
                    if (response.response?.statusCode) == 200 {
                        let order = self.parseOrderManual(json: json)
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
    
    private func parseOrderManual(json:JSON)->[Order]{
       
        let orders = json["orders"]
        var order = [RecentOrder]()
        var orderDate = String()
        var orderArray = [Order]()
        
        if orders.count > 0{
            for i in 0...orders.count-1{
                 order.removeAll()
                 orderDate = orders[i]["order_date"].stringValue
                for j in 0...orders[i]["orders"].count-1{
                    
                    order.append(RecentOrder(order_id: orders[i]["orders"][j]["order_id"].intValue,
                                             customer_name: orders[i]["orders"][j]["customer_name"].stringValue,
                                             customer_address: orders[i]["orders"][j]["customer_address"].stringValue,
                                             ordered_at: orders[i]["orders"][j]["ordered_at"].stringValue,
                                             delivery_or_pickup_status: orders[i]["orders"][j]["delivery_or_pickup_status"].intValue,
                                             payment_status: orders[i]["orders"][j]["payment_status"].intValue,
                                             payment_type:orders[i]["orders"][j]["payment_type"].intValue,
                                             image: orders[i]["orders"][j]["image"].stringValue,
                                             total: orders[i]["orders"][j]["total"].stringValue))
                }
                orderArray.append(Order(order_date: orderDate, orders: order ))
            }
        }
        
       return  orderArray
    }
    
    
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    
}
