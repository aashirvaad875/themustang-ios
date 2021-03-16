//
//  AllRecentOrderController.swift
//  themustang
//
//  Created by Ashik Chalise on 9/4/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit


class AllRecentOrderController: UIViewController, UITableViewDelegate, UITableViewDataSource, filterDataDelegateProtocol {
    
    
   
    
   
    
    @IBOutlet weak var timeLineOrder: UITableView!
    
    var orderData = OrderApi()
    var error : Error!
    var order : Order!
    var ordersArray = [Order]()
    var filter = SearchOrderApi()
    
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        initOrderData()
        timeLineOrder.tableFooterView = UIView()
        setUpIndictor()
        
        let rightBarButtonItems = UIBarButtonItem.init(image: UIImage(named: "filter_list"), style: .done, target: self, action: #selector(searchClicked))
        self.navigationItem.rightBarButtonItem = rightBarButtonItems
        self.navigationItem.rightBarButtonItem?.tintColor = hexStringToUIColor(hex: "#ffffff") // add your color


        
        
    }
    
    
    //MARK:- Functions
    fileprivate func initOrderData() {
        orderData.orderFun {(order,error)  in
            if order != nil{
                if let orderData = order{
                   self.ordersArray.append(contentsOf: orderData)
                    self.timeLineOrder.reloadData()
                    self.spinningActivityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.container.removeFromSuperview()
                }
            }
        }
    }
    
    
    
    //MARK:- TableView Datasource
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
    
        func numberOfSections(in tableView: UITableView) -> Int {
            return ordersArray.count
        }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTimelineHeaderCell") as! TimeLineOrderHearderCell
        cell.timeLineDate.text =  ordersArray[section].order_date
        return cell
    }


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  ordersArray[section].orders.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "orderTimelineCell", for: indexPath) as! TimeLineOrderCell
        if (ordersArray[indexPath.section].orders[indexPath.row].order_id != 0) {
            cell.orderTimelineName?.text =  ordersArray[indexPath.section].orders[indexPath.row].customer_name
            cell.orderTimeLineDate?.text = ordersArray[indexPath.section].orders[indexPath.row].ordered_at
            cell.orderTimeLineAddress?.text = ordersArray[indexPath.section].orders[indexPath.row].customer_address
            cell.orderTimeLinePrice?.text = ordersArray[indexPath.section].orders[indexPath.row].total
            cell.orderTimelineImage.sd_setImage(with: URL(string: ordersArray[indexPath.section].orders[indexPath.row].image))
         }
         cell.selectionStyle = .none
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

            let vc = storyboard?.instantiateViewController(withIdentifier: "OrderDetailController") as? OrderDetailController
            vc?.id = ordersArray[indexPath.section].orders[indexPath.row].order_id
            self.navigationController?.pushViewController(vc!, animated: true)
            
       
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
       self.navigationItem.title = "Recent Orders"
       let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
       self.navigationController?.navigationBar.titleTextAttributes = textAttributes
       self.navigationController?.navigationBar.backIndicatorImage = backImage
       self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
       navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    
    @IBAction func searchClicked(sender:UIBarButtonItem) {
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopoverController") as! PopoverController
        vc.preferredContentSize = .init(width: 357, height: 260)
        
        vc.modalPresentationStyle = .popover
        vc.filterDelegate =   self
        let popover: UIPopoverPresentationController = vc.popoverPresentationController!
        popover.barButtonItem = sender
        present(vc, animated: true, completion:nil)
    }
    
    func filterDataToRecentOrder(fromDate: String, toDate: String, ordered_date: String, rangeStatus: String) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterController") as? FilterController
         vc?.toDate = toDate
         vc?.fromDate = fromDate
         vc?.orderedDate = ordered_date
         vc?.rangeStatus = rangeStatus
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    

}
