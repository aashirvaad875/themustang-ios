//
//  FilterController.swift
//  themustang
//
//  Created by Ashik Chalise on 10/2/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

class FilterController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    

    @IBOutlet weak var dataFilterTable: UITableView!
    var filter = SearchOrderApi()
    var toDate: String?
    var fromDate: String?
    var orderedDate : String?
    var rangeStatus : String?
    var ordersArray = [RecentOrder]()
    var error : Error!
    var order : Order!

    
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        dataFilterTable.tableFooterView = UIView()
        setUpIndictor()
        initOrderData()
        
        
    }
    
    //MARK:- Functions
       fileprivate func initOrderData() {
            if (rangeStatus == "off") {
                let parameters: [String:AnyObject] = ["ordered_date":orderedDate as AnyObject ]
                    filter.searchData(parameters: parameters) { (order, error) in
                              if order != nil{
                                    if let orderData = order{
                                       self.ordersArray.append(contentsOf: orderData)
                                         self.dataFilterTable.reloadData()
                                        self.spinningActivityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        self.container.removeFromSuperview()
                                    }
                                }
                           }
            }else if(rangeStatus == "on"){
               let parameters: [String:AnyObject] = ["to":toDate as AnyObject,"from":fromDate as AnyObject ]
                     filter.searchData(parameters: parameters) { (order, error) in
                    if order != nil{
                               if let orderData = order{
                                  self.ordersArray.append(contentsOf: orderData)
                                 self.dataFilterTable.reloadData()
                                   self.spinningActivityIndicator.stopAnimating()
                                   UIApplication.shared.endIgnoringInteractionEvents()
                                   self.container.removeFromSuperview()
                               }
                           }
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
        
        
        
       let backImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal)
       self.navigationItem.title = "Filter Result"
       let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
       self.navigationController?.navigationBar.titleTextAttributes = textAttributes
       self.navigationController?.navigationBar.backIndicatorImage = backImage
       self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
       navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    //MARK:- TableView Datasource
    
       func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
               return 90
         }
       
    
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return  ordersArray.count
            
        }
       
     
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filterOrderCell", for: indexPath) as! FilterTableViewCell
                
        cell.orderName.text = ordersArray[indexPath.row].customer_name
        cell.orderDate.text = ordersArray[indexPath.row].ordered_at
        cell.orderPrice.text = ordersArray[indexPath.row].total
        cell.orderAddress.text = ordersArray[indexPath.row].customer_address
        cell.orderImage.sd_setImage(with: URL(string: ordersArray[indexPath.row].image))
        cell.selectionStyle = .none
         return cell
       }
    
       
       func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as? OrderDetailController
               vc?.id = ordersArray[indexPath.row].order_id
               self.navigationController?.pushViewController(vc!, animated: true)
       }
    
    
}
