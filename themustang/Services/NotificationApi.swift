//
//  NotificationApi.swift
//  themustang
//
//  Created by Ashik Chalise on 9/5/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON



class NotificationApi {

    func notification(completion: @escaping (responseCompletion<[Notification]?>)){
        
        let url = NOTIFICATION_URL
        AF.request(url, headers: headers).responseJSON { (response) in
            switch response.result{
            case .success:
                guard let home = response.data else { return completion(nil,nil)}
                do{
                    let json = try JSON(data: home)
                    print(json)
                    
                    
                    if (response.response?.statusCode) == 200 {
                        let home = self.parseNotificationManual(json: json)
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
    
    private func parseNotificationManual(json:JSON)->[Notification]{
        let notificationArray = json["data"]["notifications"]
        var notifications = [Notification]()
        if notificationArray.count > 0 {
            for i in 0...notificationArray.count-1{
                notifications.append( Notification(notification_id: notificationArray[i]["notification_id"].intValue, reference: notificationArray[i]["reference"].stringValue, message: notificationArray[i]["message"].stringValue, type: notificationArray[i]["type"].intValue, status:  notificationArray[i]["status"].intValue, created_at: notificationArray[i]["created_at"].stringValue,object_id: notificationArray[i]["object_id"].intValue))
            }
        }
        return notifications

    }
    
    private func errorHandel(json:JSON)->Error{
        let error = json["error"].stringValue
        return Error(error: error)
    }
}
