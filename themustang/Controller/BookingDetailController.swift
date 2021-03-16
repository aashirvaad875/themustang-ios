//
//  BookingDetailController.swift
//  themustang
//
//  Created by Ashik Chalise on 9/18/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class BookingDetailController: UIViewController {
    var bookingDetails = BookingDetailApi()
    var detail : RecentTableBooking!
    
    var statusUpdateApi = BookingStatusApi()
    var update : TableBooking!
    var error : Error!
    var id: Int?
    
    
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var phone: UILabel!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var bookingStatus: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var checkOutBtn: UIButton!
    @IBOutlet weak var checkInBtn: UIButton!
    var BookingId : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        initBookingData()
        setUpIndictor()
        navbar()
        
        bookingStatus.layer.cornerRadius = 12
        checkOutBtn.layer.cornerRadius = 5
        checkInBtn.layer.cornerRadius = 5
        bookingStatus.clipsToBounds = true
        checkOutBtn.clipsToBounds = true
        checkInBtn.clipsToBounds = true
        
    }
    
    fileprivate func initBookingData() {
        bookingDetails.bookingDetail(id: id!) { (detail, error) in
              if let details = detail{
                  self.name.text = details.customer_name
                  self.email.text = details.customer_email
                  self.phone.text = details.customer_phone_number
                  self.message.text = details.extra_message
                  self.date.text = details.for_date
                self.BookingId = details.id
                if(details.book_status == 1){
                   self.bookingStatus.text = "Booked"
                    self.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#EAB135")
                }else if(details.book_status == 2){
                   self.bookingStatus.text = "Checked In"
                    self.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#4A90E2")
                    self.checkInBtn.isEnabled = false
                    self.checkInBtn.backgroundColor = .gray
                }else if(details.book_status == 3){
                    self.bookingStatus.text = "Checked Out"
                   self.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#E24A4A")
                    self.checkOutBtn.isEnabled = false
                    self.checkOutBtn.backgroundColor = .gray
                }
                
               
                  self.spinningActivityIndicator.stopAnimating()
                  UIApplication.shared.endIgnoringInteractionEvents()
                  self.container.removeFromSuperview()
              }
          }
        
       }
    
    
    func setUpIndictor() {
       container.frame = UIScreen.main.bounds
       container.backgroundColor = UIColor(hue: 0/360, saturation: 0/100, brightness: 0/100, alpha: 0.4)
       let loadingView: UIView = UIView()
       loadingView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
       loadingView.center = container.center
       loadingView.backgroundColor = hexStringToUIColor(hex: "#545454")
       loadingView.clipsToBounds = true
       loadingView.layer.cornerRadius = 5
       spinningActivityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
       spinningActivityIndicator.hidesWhenStopped = true
       spinningActivityIndicator.style = UIActivityIndicatorView.Style.white
       spinningActivityIndicator.center = CGPoint(x: loadingView.frame.size.width / 2, y: loadingView.frame.size.height / 2)
       loadingView.addSubview(spinningActivityIndicator)
       container.addSubview(loadingView)
       window?.addSubview(container)
       spinningActivityIndicator.startAnimating()
       UIApplication.shared.beginIgnoringInteractionEvents()
       
      
    }
    
    
    func navbar() {
         let backImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal)
              self.navigationItem.title = "Booking Detail"
              let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
              self.navigationController?.navigationBar.titleTextAttributes = textAttributes
              self.navigationController?.navigationBar.backIndicatorImage = backImage
              self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
              navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    

    @IBAction func checkedInClicked(_ sender: Any) {
        setUpIndictor()
        let parameters: [String:AnyObject] = ["id":self.BookingId as AnyObject,"book_status":"2" as AnyObject]
            statusUpdateApi.updateStatus(parameters: parameters) { (detail, error) in
                if(detail?.book_status == "2"){
                   self.bookingStatus.text = "Checked In"
                    self.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#4A90E2")
                }
                
                self.checkInBtn.isEnabled = false
                self.checkInBtn.backgroundColor = .gray
                self.checkOutBtn.isEnabled = true
                self.checkOutBtn.backgroundColor = hexStringToUIColor(hex: "#E24A4A")
                
                self.spinningActivityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                self.container.removeFromSuperview()
                
            }
        
    }
    
    @IBAction func checkOutClicked(_ sender: Any) {
        setUpIndictor()
        let parameters: [String:AnyObject] = ["id":self.BookingId as AnyObject,"book_status":"3" as AnyObject]
        statusUpdateApi.updateStatus(parameters: parameters) { (detail, error) in
             if(detail?.book_status == "3"){
                self.bookingStatus.text = "Checked Out"
               self.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#E24A4A")
            }
            self.checkOutBtn.isEnabled = false
            self.checkOutBtn.backgroundColor = .gray
            self.checkInBtn.isEnabled = true
             self.checkInBtn.backgroundColor = hexStringToUIColor(hex: "#4A90E2")
            self.spinningActivityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            self.container.removeFromSuperview()
            
        }
        
    }
}
