//
//  BookingStatusApi.swift
//  themustang
//
//  Created by Ashik Chalise on 10/2/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BookingStatusApi {
    func updateStatus(parameters:[String: AnyObject], completion: @escaping (responseCompletion<TableBooking?>)) {
        let url =  UPDATE_BOOKING
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let order = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: order)
                    if (response.response?.statusCode) == 200 {
                        let order = self.parseBookingManual(json: json)
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
    
    private func parseBookingManual(json:JSON)-> TableBooking{
           let id = json["table_booking"]["id"].intValue
           let book_status = json["table_booking"]["book_status"].stringValue
           return TableBooking(id: id, book_status: book_status)
       }
       
       
       private func errorHandel(json:JSON)->Error{
           let error = json["error"].stringValue
           return Error(error: error)
       }
    
    
    
}
