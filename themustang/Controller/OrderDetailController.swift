//
//  OrderDetailViewController.swift
//  themustang
//
//  Created by Ashik Chalise on 9/4/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit
import WebKit

class OrderDetailController: UIViewController {
    var orderDetails = OrderDetailApi()
    var detail : OrderDetail!
    var error : Error!
    var id: Int?

    @IBOutlet weak var webViewKit: WKWebView!
    var activityIndicator : UIActivityIndicatorView = UIActivityIndicatorView()
    
    let spinningActivityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let window = UIApplication.shared.keyWindow
    let container: UIView = UIView()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpIndictor()

        



        // Do any additional setup after loading the view.
        
       
        orderDetails.orderDetail(id: id!) { (detail, erorr) in
             if let details = detail{
                self.webViewKit.loadHTMLString(details.order, baseURL: nil)
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
       
       
       
      let backImage = #imageLiteral(resourceName: "backButton").withRenderingMode(.alwaysOriginal)
      self.navigationItem.title = "Order Detail"
      let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
      self.navigationController?.navigationBar.titleTextAttributes = textAttributes
      self.navigationController?.navigationBar.backIndicatorImage = backImage
      self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = backImage
      navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
  
    


}
