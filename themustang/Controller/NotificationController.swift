//
//  NotificationController.swift
//  themustang
//
//  Created by Ashik Chalise on 8/28/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class NotificationController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
  
    
    @IBOutlet weak var NotificationTable: UITableView!
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()


    
    var notificationData = NotificationApi()
    var error : Error!
    var notification : Notification!
    var notificationList = [Notification]()
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotificationData()
        NotificationTable.tableFooterView = UIView()
        setUpIndictor()
        
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        NotificationTable.addSubview(refreshControl) // not required when using UITableViewController
    }
    
    @objc func refresh(sender:AnyObject) {
          initNotificationData()
        self.refreshControl.endRefreshing()

    }
    
    
     fileprivate func initNotificationData() {
        notificationData.notification { (notification, error) in
            if notification != nil{
                self.notificationList.removeAll()
                
                if let notificationData = notification{
                    self.notificationList.append(contentsOf: notificationData)
                    self.NotificationTable.reloadData()
                    self.spinningActivityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.container.removeFromSuperview()

                }
            }
        }
    }
    
    
    
    
    //MARK:- TableView Datasource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return   notificationList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationTableViewCell
         cell.notificationDate.text = notificationList[indexPath.row].created_at
         cell.notificationTitle.text = notificationList[indexPath.row].reference
         cell.notificationMessage.text = notificationList[indexPath.row].message
            if(notificationList[indexPath.row].type == 1){
                cell.notificationImage.image = UIImage(named: "orderimage")
            }else{
                 cell.notificationImage.image = UIImage(named: "bookedImage")
            }
        
        if (notificationList[indexPath.row].status == 1) {
             cell.backgroundColor = hexStringToUIColor(hex: "#E9EAED")
        }else{
            cell.backgroundColor = UIColor.white
        }
        
        cell.selectionStyle = .none

        
        

         return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if notificationList[indexPath.row].type == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as? OrderDetailController
            vc?.id = notificationList[indexPath.row].object_id
            self.navigationController?.pushViewController(vc!, animated: true)
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "BookingDetailController") as? BookingDetailController
            vc?.id = notificationList[indexPath.row].object_id
            self.navigationController?.pushViewController(vc!, animated: true)
            
            
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
       
       
       
       let backImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal)
       self.navigationItem.title = "Notification"
       let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
       self.navigationController?.navigationBar.titleTextAttributes = textAttributes
       self.navigationController?.navigationBar.backIndicatorImage = backImage
       self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
       navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    

}
