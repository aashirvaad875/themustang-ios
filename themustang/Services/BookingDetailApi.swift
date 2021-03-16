//
//  BookingDetail.swift
//  themustang
//
//  Created by Ashik Chalise on 9/27/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class BookingDetailApi {

    func bookingDetail(id: Int, completion: @escaping (responseCompletion<RecentTableBooking?>)){
        
        guard let url = URL(string: "\(TABLE_BOOKING_DETAIL)\(id)") else{ return }
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let home = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: home)
                    if (response.response?.statusCode) == 200 {
                        let home = self.parseBookingDetailManual(json: json)
                    
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
    
    private func parseBookingDetailManual(json:JSON)-> RecentTableBooking{
        let booking = json["table_booking"]
        return RecentTableBooking(id: booking["id"].intValue,
                                  customer_name: booking["customer_name"].stringValue,
                                  number_of_persons: booking["number_of_persons"].stringValue,
                                  customer_email: booking["customer_email"].stringValue,
                                  customer_phone_number: booking["customer_phone_number"].stringValue,
                                  for_date: booking["for_date"].stringValue,
                                  extra_message: booking["message"].stringValue,
                                  book_status: booking["book_status"].intValue
        )}
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
    

}
