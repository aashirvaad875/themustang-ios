//
//  HomeApi.swift
//  themustang
//
//  Created by Ashik Chalise on 8/30/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class HomeApi {
    
    func home(completion: @escaping (responseCompletion<Home?>)){
    
        let url = HOME_URL
        print("header \(headers)")
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let home = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: home)
    
                       if (response.response?.statusCode) == 200 {
                        let home = self.parseHomeManual(json: json)
                   
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
    
    private func parseHomeManual(json:JSON)->Home{
        let recentOrderJsonArray = json["home"]["recent_orders"]
        let recentTableBookingJsonArray = json["home"]["recent_table_bookings"]
        var notificationsCount  = json["home"]["notifications_count"].intValue
        var recentOrder = [RecentOrder]()
        var recentTableBooking = [RecentTableBooking]()
        if recentOrderJsonArray.count > 0 {
            for i in 0...recentOrderJsonArray.count-1{
                recentOrder.append(RecentOrder(order_id: recentOrderJsonArray[i]["order_id"].intValue, customer_name: recentOrderJsonArray[i]["customer_name"].stringValue, customer_address: recentOrderJsonArray[i]["customer_address"].stringValue, ordered_at: recentOrderJsonArray[i]["ordered_at"].stringValue, delivery_or_pickup_status: recentOrderJsonArray[i]["delivery_or_pickup_status"].intValue, payment_status: recentOrderJsonArray[i]["payment_status"].intValue, payment_type: recentOrderJsonArray[i]["payment_type"].intValue, image: recentOrderJsonArray[i]["image"].stringValue, total: recentOrderJsonArray[i]["total"].stringValue))
            }
        }
        if recentTableBookingJsonArray.count > 0 {
            for i in 0...recentTableBookingJsonArray.count-1{
                recentTableBooking.append(RecentTableBooking(
                    id: recentTableBookingJsonArray[i]["id"].intValue,
                    customer_name: recentTableBookingJsonArray[i]["customer_name"].stringValue,
                    number_of_persons:  recentTableBookingJsonArray[i]["number_of_persons"].stringValue,
                    customer_email:  recentTableBookingJsonArray[i]["customer_email"].stringValue,
                    customer_phone_number:  recentTableBookingJsonArray[i]["customer_phone_number"].stringValue,
                    for_date:  recentTableBookingJsonArray[i]["for_date"].stringValue,
                    extra_message:  recentTableBookingJsonArray[i]["extra_message"].stringValue,
                    book_status:  recentTableBookingJsonArray[i]["book_status"].intValue))
            }
        }
        return Home(recentOrder: recentOrder, recentTableBooking: recentTableBooking, notificationsCount: notificationsCount)
    }
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    
}

