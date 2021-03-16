//
//  LeftSideBarController.swift
//  themustang
//
//  Created by Ashik Chalise on 8/28/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit
import MMDrawerController

class LeftSideBarController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    @IBOutlet weak var menuTableView: UITableView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var imageBackground: UIView!
    
    var logoutApi = LogoutApi()
    var error : Error!
    var logoutData : Logout!
    
    
    var menuItems:[String] = ["Home","Logout"]

    override func viewDidLoad() {
        super.viewDidLoad()
         menuTableView.tableFooterView = UIView()
        self.navigationController?.isNavigationBarHidden = true
        userName.text =  UserDefaults.standard.string(forKey: "name")
        imageBackground.layer.cornerRadius = 35;

    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sidebarCell", for: indexPath) as! SidebarTableViewCell
        cell.menuItemLabel.text = menuItems[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         switch(indexPath.row)
         {
          case 0:
            let centerViewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeController") as! HomeController
            let centerNavController = UINavigationController(rootViewController: centerViewController)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.centerContainer!.centerViewController = centerNavController
            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
            break
//         case 1:
//            let notificationViewController = self.storyboard?.instantiateViewController(withIdentifier: "NotificationController") as! NotificationController
//            let notificationNavController = UINavigationController(rootViewController: notificationViewController)
//            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
//            appDelegate.centerContainer!.centerViewController = notificationNavController
//            appDelegate.centerContainer!.toggle(MMDrawerSide.left, animated: true, completion: nil)
//            break
            
         case 1:
            print("logOUT \(UserDefaults.standard.string(forKey: "token"))")
             let parameters: [String:AnyObject] = ["user_id": UserDefaults.standard.string(forKey: "id") as AnyObject]
            logoutApi.logout(parameters: parameters) { (data, error) in
            let domain = Bundle.main.bundleIdentifier!
            UserDefaults.standard.removePersistentDomain(forName: domain)
//            UserDefaults.standard.synchronize()
             let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
             let appDel:AppDelegate = UIApplication.shared.delegate as! AppDelegate
             appDel.window?.rootViewController = loginVC
            }
            
            

               
                

            
          
            
            
            break
         default:
            
            break
        }
        
    }
    
    

}
