//
//  HomeController.swift
//  themustang
//
//  Created by Ashik Chalise on 8/27/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit
import SafariServices
import MMDrawerController
import Alamofire
import SwiftyJSON
import SDWebImage

class HomeController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    //MARK:- Properties
    @IBOutlet weak var homeTableView: UITableView!
    var homeData = HomeApi()
    var error : Error!
    var home : Home!
    
    @IBOutlet weak var notificationButton: BadgeBarButtonItem!
    
    
   var refreshControl = UIRefreshControl()
    
    
    let backgroundColour:[String] = ["#12979D","#E24A4A","#EAB135"]
    var recentOrders = [RecentOrder]()
    var recentBookings = [RecentTableBooking]()
    var notificationCont : Int?
    
    var containerView = UIView()
    var loadingView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    



    
    
    
    //MARK:- LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 26))
        let titleImageView = UIImageView(image: UIImage(named: "Bitmap"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: titleView.frame.width, height: titleView.frame.height)
        titleView.addSubview(titleImageView)
        navigationItem.titleView = titleView
        initHomeData()
        homeTableView.tableFooterView = UIView()
        
         print("tokenhome \(UserDefaults.standard.string(forKey: "token"))")
        
        
      

        

   
        
       self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
       homeTableView.addSubview(refreshControl) // not required when using UITableViewController
        
    }
    
    @objc func refresh(sender:AnyObject) {
          initHomeData()
         self.homeTableView.isHidden = false
        self.homeTableView.reloadData()
         self.activityIndicator.stopAnimating()
         self.containerView.removeFromSuperview()
        self.refreshControl.endRefreshing()

    }
    
    
    @IBAction func leftSideBarButtonClicked(_ sender: Any) {
        let appdelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.centerContainer?.toggle(MMDrawerSide.left, animated: true, completion: nil)
    }
    
    
    
    //MARK:- Functions
  
    
    
    fileprivate func initHomeData() {
        homeTableView.isHidden = true
        setUpIndictor()
        
        homeData.home {[unowned self](home,err)  in
            if home != nil{
                self.recentOrders.removeAll()
                self.recentBookings.removeAll()
         
                
                if let homeData = home{
                    self.recentOrders.append(contentsOf: homeData.recentOrder)
                    self.recentBookings.append(contentsOf: homeData.recentTableBooking)
                    self.notificationButton.badgeNumber = homeData.notificationsCount
                    self.homeTableView.reloadData()
                   
                    self.activityIndicator.stopAnimating()
                    self.containerView.removeFromSuperview()
                    self.homeTableView.isHidden = false

                
                }
                
                
            }
        }
        
               let gradientLayer = CAGradientLayer()
               var updatedFrame = self.navigationController!.navigationBar.bounds
               updatedFrame.size.height += UIApplication.shared.statusBarFrame.size.height
               gradientLayer.frame = updatedFrame
               gradientLayer.colors = [hexStringToUIColor(hex: "#D68000").cgColor,hexStringToUIColor(hex: "#FAD961").cgColor, hexStringToUIColor(hex: "#FAD961").cgColor,hexStringToUIColor(hex: "#D68000").cgColor] // start color and end color

               gradientLayer.locations = [0.0 ,0.4, 0.6, 1.0]
               gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0) // Horizontal gradient start
               gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.0) // Horizontal gradient end
               UIGraphicsBeginImageContext(gradientLayer.bounds.size)
               gradientLayer.render(in: UIGraphicsGetCurrentContext()!)
               let images = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               self.navigationController!.navigationBar.setBackgroundImage(images, for: UIBarMetrics.default)
        
        
    }
    
    
    func setUpIndictor() {
      containerView.frame = self.view.frame
      containerView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.3)
      self.view.addSubview(containerView)
      loadingView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
      loadingView.center = self.view.center
      loadingView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
      loadingView.clipsToBounds = true
      loadingView.layer.cornerRadius = 10
      containerView.addSubview(loadingView)
      activityIndicator.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
      activityIndicator.style = UIActivityIndicatorView.Style.white
      activityIndicator.center = CGPoint(x:loadingView.frame.size.width / 2, y:loadingView.frame.size.height / 2);
      activityIndicator.startAnimating()
      loadingView.addSubview(activityIndicator)
    }
    
    
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if(recentOrders.count==0 &&  recentBookings.count==0){
//            return 5
//        }
        if section == 0  {
               return  recentOrders.count
        }else{
             return  recentBookings.count
        }
     
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
         if section == 0  {
           cell.headerTitle.text = "Recent Orders"
            cell.headerBtnLink.tag = 0
            cell.headerBtnLink.addTarget(self, action: #selector(buttonClicked), for: .touchDown)
         }else{
            cell.headerTitle.text = "Recent Table Booking"
            cell.headerBtnLink.tag = 1
            cell.headerBtnLink.addTarget(self, action: #selector(buttonClicked), for: .touchDown)
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//       if(recentOrders.count==0 &&  recentBookings.count==0){
//         let cell    =   UITableViewCell()
//        return cell
//     }
        if indexPath.section == 0{
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "recentOrderCell", for: indexPath) as! RecentOrderTableViewCell
             cell.recentOrderName.text = recentOrders[indexPath.row].customer_name
             cell.recentOrderTime.text = recentOrders[indexPath.row].ordered_at
             cell.recentOrderPrice.text = recentOrders[indexPath.row].total
             cell.recentOrderAddress.text = recentOrders[indexPath.row].customer_address
             cell.recentImage.sd_setImage(with: URL(string: recentOrders[indexPath.row].image))
             cell.selectionStyle = .none
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "tableBookedCell", for: indexPath) as! TableBookingTableViewCell
            cell.bookingDate.text = recentBookings[indexPath.row].for_date
            if(recentBookings[indexPath.row].extra_message == ""){
                cell.bookingDescribtion.text = "no message"

            }else{
                cell.bookingDescribtion.text = recentBookings[indexPath.row].extra_message

            }
            cell.bookingName.text = recentBookings[indexPath.row].customer_name
            
            cell.selectionStyle = .none
            let randomIndex = Int(arc4random_uniform(UInt32(backgroundColour.count)))
            cell.nameHolderView.backgroundColor = hexStringToUIColor(hex: backgroundColour[randomIndex])
            
            let nameStringArray = recentBookings[indexPath.row].customer_name.components(separatedBy: " ")
            if(nameStringArray.count == 1){
                let firstindex = nameStringArray[0].index(nameStringArray[0].startIndex, offsetBy: 0)
                cell.nameHolder.text =  "\(nameStringArray[0][firstindex])"
            }else{
                let firstindex = nameStringArray[0].index(nameStringArray[0].startIndex, offsetBy: 0)
                let secondindex = nameStringArray[1].index(nameStringArray[1].startIndex, offsetBy: 0)
                cell.nameHolder.text =  "\(nameStringArray[0][firstindex])\(nameStringArray[1][secondindex])"
            }
            
          
            
            if(recentBookings[indexPath.row].book_status == 1){
              cell.bookingStatus.text = "Booked"
                cell.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#EAB135")
            }else if(recentBookings[indexPath.row].book_status == 2){
                cell.bookingStatus.text = "Checked In"
                cell.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#4A90E2")
            }else if(recentBookings[indexPath.row].book_status == 3){
                cell.bookingStatus.text = "Checked Out"
                cell.bookingStatus.backgroundColor = hexStringToUIColor(hex: "#E24A4A")
            }
            return cell
        }

   
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
     if indexPath.section == 0{
        let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as? OrderDetailController
        vc?.id = recentOrders[indexPath.row].order_id
        self.navigationController?.pushViewController(vc!, animated: true)
       }else{
            let vcbooking = storyboard?.instantiateViewController(withIdentifier: "BookingDetailController") as? BookingDetailController
             vcbooking?.id = recentBookings[indexPath.row].id
            self.navigationController?.pushViewController(vcbooking!, animated: true)

       }
    }
    
   
    
    @objc func buttonClicked(sender:UIButton){
        if(sender.tag == 0){
            let vc = storyboard?.instantiateViewController(withIdentifier: "AllRecentOrderController") as? AllRecentOrderController
            self.navigationController?.pushViewController(vc!, animated: true)
        }else if(sender.tag == 1){
            let vc = storyboard?.instantiateViewController(withIdentifier: "AllRecentTableBookingController") as? AllRecentTableBookingController
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    

    
 
}






