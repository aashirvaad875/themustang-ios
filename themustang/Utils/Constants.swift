//
//  Constants.swift
//  themustang
//
//  Created by Ashik Chalise on 8/22/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit
let black_bg = UIColor.black.cgColor
import Alamofire


let BASE_URL = "https://themustangcanberra.com.au/api/"
let LOGIN_URL = BASE_URL + "login"
let HOME_URL = BASE_URL + "home"
let ORDER_DETAIL_URL = BASE_URL + "order/"
let NOTIFICATION_URL = BASE_URL + "notifications"
let ORDER_URL = BASE_URL + "orders"
let TABLE_BOOKING = BASE_URL + "table/bookings"
let TABLE_BOOKING_DETAIL = BASE_URL + "table/booking/"
let FILTER_ORDER = BASE_URL + "order/date"
let UPDATE_BOOKING = BASE_URL + "table/booking/update"
let LOGOUT = BASE_URL + "logout"



var headers : HTTPHeaders  = [
    "Authorization": "Bearer \(UserDefaults.standard.string(forKey: "token")!)",
    "user_id" : UserDefaults.standard.string(forKey: "id")!,
    "Content-Type": "application/x-www-form-urlencoded",
    "Accept": "application/json"

]

typealias responseCompletion<T> = (T,Error?)->Void


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}




class BlackButtonBg: UIButton {
    override func awakeFromNib() {
        layer.backgroundColor = black_bg
        layer.cornerRadius = 22
    }
}

class btnSwitch: UISwitch {
    override func awakeFromNib() {
        let standardHeight: CGFloat = 31
        let standardWidth: CGFloat = 51
        let heightRatio = 20 / standardHeight
        let widthRatio = 20 / standardWidth

        transform = CGAffineTransform(scaleX: widthRatio, y: heightRatio)
    }
}
class BadgeBarButtonItem: UIBarButtonItem
{
    @IBInspectable
    public var badgeNumber: Int = 0 {
        didSet {
            self.updateBadge()
        }
    }
    
    private let label: UILabel

    required public init?(coder aDecoder: NSCoder)
    {
        let label = UILabel()
        label.backgroundColor = .red
        label.alpha = 0.9
        label.layer.cornerRadius = 9
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.layer.zPosition = 1
        label.font  =   label.font.withSize(12)
        self.label = label
        
        super.init(coder: aDecoder)
        
        self.addObserver(self, forKeyPath: "view", options: [], context: nil)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?)
    {
        self.updateBadge()
    }
    
    private func updateBadge()
    {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        self.label.text = "\(badgeNumber)"
        
        if self.badgeNumber > 0 && self.label.superview == nil
        {
            view.addSubview(self.label)
            
            self.label.widthAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.heightAnchor.constraint(equalToConstant: 18).isActive = true
            self.label.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 9).isActive = true
            self.label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -9).isActive = true
        }
        else if self.badgeNumber == 0 && self.label.superview != nil
        {
            self.label.removeFromSuperview()
        }
    }
    
    deinit {
        self.removeObserver(self, forKeyPath: "view")
    }
}






