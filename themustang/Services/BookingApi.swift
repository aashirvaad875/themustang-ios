//
//  TableBooking.swift
//  themustang
//
//  Created by Ashik Chalise on 9/13/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class BookingApi{
    
    
    func booking(completion: @escaping (responseCompletion<[RecentTableBooking]?>)){
        
        let url = TABLE_BOOKING
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let booking = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: booking)
                    if (response.response?.statusCode) == 200 {
                        let booking = self.parseBookingManual(json: json)
                        completion(booking,nil)
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
    
        
        private func parseBookingManual(json:JSON)->[RecentTableBooking]{
            let bookingArray = json["table_bookings"]
            var booking = [RecentTableBooking]()
            if bookingArray.count > 0 {
                for i in 0...bookingArray.count-1{
                    booking.append(RecentTableBooking(id: bookingArray[i]["id"].intValue,
                                                      customer_name: bookingArray[i]["customer_name"].stringValue,
                                                      number_of_persons:  bookingArray[i]["number_of_persons"].stringValue,
                                                      customer_email:  bookingArray[i]["customer_email"].stringValue,
                                                      customer_phone_number:  bookingArray[i]["customer_phone_number"].stringValue,
                                                      for_date:  bookingArray[i]["for_date"].stringValue,
                                                      extra_message:  bookingArray[i]["extra_message"].stringValue,
                                                      book_status:  bookingArray[i]["book_status"].intValue))
                }
            }
           return booking
            
        }
        
        private func errorHandel(json:JSON)->Error{
            let error = json["error"].stringValue
            return Error(error: error)
        }
        
    
    
    
    
}
