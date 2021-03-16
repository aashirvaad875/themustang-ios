//
//  ViewController.swift
//  themustang
//
//  Created by Ashik Chalise on 8/22/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

import MMDrawerController


class ViewController: UIViewController, UITextFieldDelegate {
    
    var containerView = UIView()
      var loadingView = UIView()
      var activityIndicator = UIActivityIndicatorView()
    
    var user : User!
    var error : Error!
    var userData = LoginApi()
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowView.layer.cornerRadius = 5
        emailText.delegate = self
        passwordText.delegate = self
        
         self.setupHideKeyboardOnTap()
        
        print("login \(UserDefaults.standard.string(forKey: "token"))")

    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    override func viewDidLayoutSubviews() {
        let shadowPath = UIBezierPath()
        shadowPath.move(to: CGPoint(x: 0, y: shadowView.bounds.height))
        shadowPath.addLine(to: CGPoint(x: shadowView.bounds.width, y: shadowView.bounds.height))
        shadowPath.addLine(to: CGPoint(x: shadowView.bounds.width, y: shadowView.bounds.height + 2))
        shadowPath.addLine(to: CGPoint(x: 0, y: shadowView.bounds.height + 2))
        shadowPath.close()
        shadowView.layer.shadowColor = hexStringToUIColor(hex: "#000000").cgColor
        shadowView.layer.shadowOpacity = 0.5
        shadowView.layer.masksToBounds = false
        shadowView.layer.shadowPath = shadowPath.cgPath
        shadowView.layer.shadowRadius = 4

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
    
    @IBAction func loginBtnClicked(_ sender: Any) {
       setUpIndictor()
        
        if( self.emailText.text == "" ){
            self.activityIndicator.stopAnimating()
            self.containerView.removeFromSuperview()
            let alert = UIAlertController(title: "Oopps..", message: "Email field is empty", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    
        }else if(self.passwordText.text == ""){
            self.activityIndicator.stopAnimating()
                       self.containerView.removeFromSuperview()
            let alert = UIAlertController(title: "Oopps..", message: "Password field is empty.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            

            
            let parameters: [String:AnyObject] = ["email":emailText.text! as AnyObject,"password":passwordText.text! as AnyObject ,"device_type":"2" as AnyObject,"device_token": UserDefaults.standard.string(forKey: "device_token") as AnyObject]
                userData.login(parameters: parameters) {(user,err)  in
                       self.activityIndicator.stopAnimating()
                       self.containerView.removeFromSuperview()
                if let user = user{
                    
                    print("First \(user.token)")
                    
                    let defaults = UserDefaults.standard
                    defaults.set(user.token, forKey: "token")
                    defaults.set(user.id, forKey: "id")
                    defaults.set(user.name, forKey: "name")
                    defaults.set(user.email, forKey: "email")
                    defaults.set(true, forKey: "isUserLoggedIn")
                    
                    headers["Authorization"] = "Bearer " +  user.token
                    headers["user_id"] = "\(user.id)"

                    
                    
                    let delegate = UIApplication.shared.delegate as! AppDelegate
                    delegate.initializeDrawer(UIStoryboard.init(name: "Main", bundle: nil))
                    
                }
                if let error = err {
                    let alert = UIAlertController(title: "Oopps..", message: err?.error, preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Try Again", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
        }
    }
    
    
}
extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }
    
    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
    
    

}


