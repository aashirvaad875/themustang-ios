//
//  AllRecentTableBookingController.swift
//  themustang
//
//  Created by Ashik Chalise on 9/4/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class AllRecentTableBookingController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    
    
    var bookingData = BookingApi()
    var error : Error!
    var recentBooking : RecentTableBooking!
    var bookingList = [RecentTableBooking]()
    let backgroundColour:[String] = ["#12979D","#E24A4A","#EAB135"]

    @IBOutlet weak var tableBookingTable: UITableView!
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        initBookingData()
        tableBookingTable.tableFooterView = UIView()
        setUpIndictor()
        
    

    }
    
    fileprivate func initBookingData() {
        bookingData.booking { (booking, error) in
            if booking != nil{
                if let bookingData = booking{
                    self.bookingList.append(contentsOf: bookingData)
                    self.tableBookingTable.reloadData()
                    self.spinningActivityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.container.removeFromSuperview()
                    
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookingList.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "timelineBookingCell", for: indexPath) as! TimeLineBookingCell
//        cell.bookingDate.text = recentBookings[indexPath.row].for_date
        cell.date.text = bookingList[indexPath.row].for_date
        
        if (bookingList[indexPath.row].extra_message == "") {
            cell.message.text = "no message"
        }else{
             cell.message.text = bookingList[indexPath.row].extra_message
        }
        cell.name.text = bookingList[indexPath.row].customer_name
        cell.selectionStyle = .none
        let randomIndex = Int(arc4random_uniform(UInt32(backgroundColour.count)))
        cell.nameHolder.backgroundColor = hexStringToUIColor(hex: backgroundColour[randomIndex])
        let nameStringArray = bookingList[indexPath.row].customer_name.components(separatedBy: " ")
        if (nameStringArray.count == 1) {
            let firstindex = nameStringArray[0].index(nameStringArray[0].startIndex, offsetBy: 0)
            cell.shortName.text =  "\(nameStringArray[0][firstindex])"

        }else{
            let firstindex = nameStringArray[0].index(nameStringArray[0].startIndex, offsetBy: 0)
            let secondindex = nameStringArray[1].index(nameStringArray[1].startIndex, offsetBy: 0)
            cell.shortName.text =  "\(nameStringArray[0][firstindex])\(nameStringArray[1][secondindex])"

        }
        if(bookingList[indexPath.row].book_status == 1){
            cell.status.text = "Booked"
            cell.status.backgroundColor = hexStringToUIColor(hex: "#EAB135")
        }else if(bookingList[indexPath.row].book_status == 2){
            cell.status.text = "Checked In"
            cell.status.backgroundColor = hexStringToUIColor(hex: "#4A90E2")
        }else if(bookingList[indexPath.row].book_status == 3){
            cell.status.text = "Checked Out"
            cell.status.backgroundColor = hexStringToUIColor(hex: "#E24A4A")
        }
        
        
        

        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vcbooking = storyboard?.instantiateViewController(withIdentifier: "BookingDetailController") as? BookingDetailController
        vcbooking?.id = bookingList[indexPath.row].id
        self.navigationController?.pushViewController(vcbooking!, animated: true)
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
       
       
       
       let backImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal)
      self.navigationItem.title = "Recent Table Booking"
      let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
      self.navigationController?.navigationBar.titleTextAttributes = textAttributes
      self.navigationController?.navigationBar.backIndicatorImage = backImage
      self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
      navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    
    
    
    
    
    
    
    
  
    


}
