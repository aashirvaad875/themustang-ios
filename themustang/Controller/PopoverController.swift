//
//  PopoverController.swift
//  themustang
//
//  Created by Ashik Chalise on 10/1/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

protocol  filterDataDelegateProtocol {
    func filterDataToRecentOrder(fromDate : String, toDate : String, ordered_date : String, rangeStatus : String)
}


class PopoverController: UIViewController {
    @IBOutlet weak var clearFilterBtn: UIButton!
    @IBOutlet weak var dateTo: UITextField!
    @IBOutlet weak var dateFrom: UITextField!
    @IBOutlet weak var applyBtn: UIButton!
    
    let datePicker = UIDatePicker()
    
     var filter = SearchOrderApi()
     var error : Error!
     var order : RecentOrder!
     var orderList = [RecentOrder]()
     var rangeSwitch : String!
    
    var filterDelegate: filterDataDelegateProtocol? = nil

    
    
//    override var preferredContentSize: CGSize {
//        get {
//            let height = CGFloat(200)
//            return CGSize(width: super.preferredContentSize.width, height: height)
//        }
//        set { super.preferredContentSize = newValue }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        applyBtn.layer.cornerRadius = 5
        applyBtn.clipsToBounds = true
        showFromDatePicker()
        showToDatePicker()
        
        if (dateTo.text == "" && dateFrom.text == "") {
            applyBtn.isEnabled = false
            applyBtn.backgroundColor = .gray
        }
        
    
    }
    
    func showFromDatePicker(){
       //Formate Date
       datePicker.datePickerMode = .date

      //ToolBar
      let toolbar = UIToolbar();
      toolbar.sizeToFit()
      let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneFromdatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelFromDatePicker));

       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)

       dateFrom.inputAccessoryView = toolbar
       dateFrom.inputView = datePicker
    
    }

     @objc func doneFromdatePicker(){
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      dateFrom.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
      applyBtn.isEnabled = true
      applyBtn.backgroundColor = .black
    }

    @objc func cancelFromDatePicker(){
       self.view.endEditing(true)
     }
    
    
    func showToDatePicker(){
       //Formate Date
       datePicker.datePickerMode = .date

      //ToolBar
      let toolbar = UIToolbar();
      toolbar.sizeToFit()
      let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTodatePicker));
      let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
      let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelToDatePicker));

       toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
    
        dateTo.inputAccessoryView = toolbar
        dateTo.inputView = datePicker
    }

     @objc func doneTodatePicker(){
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd"
      dateTo.text = formatter.string(from: datePicker.date)
      self.view.endEditing(true)
     applyBtn.isEnabled = true
     applyBtn.backgroundColor = .black
        
    }

    @objc func cancelToDatePicker(){
       self.view.endEditing(true)
     }
    
 
    
    @IBAction func rangeChanged(_ sender: UISwitch) {
        if (sender.isOn) {
          self.dateTo.isHidden = false;
            dateFrom.attributedPlaceholder =
                NSAttributedString(string: "From", attributes: [NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#B9B9B9")])
            rangeSwitch = "on"
            dateFrom.text! = ""
            dateTo.text! = ""
            applyBtn.isEnabled = false
            applyBtn.backgroundColor = .gray
        }else{
          self.dateTo.isHidden = true;
            dateFrom.attributedPlaceholder = NSAttributedString(string: "Date", attributes: [NSAttributedString.Key.foregroundColor : hexStringToUIColor(hex: "#B9B9B9")])
            rangeSwitch = "off"
            dateFrom.text! = ""
            dateTo.text! = ""
            applyBtn.isEnabled = false
            applyBtn.backgroundColor = .gray
        }
        
    }
    
    
    
    @IBAction func clickApplyBtn(_ sender: Any) {
       
        let fromDate =  dateFrom.text != "" ? dateFrom.text! : ""
        let toDate =     dateTo.text != "" ? dateTo.text! : ""
        let ordered_date =  dateFrom.text != "" ? dateFrom.text! : ""
        let rangeStatus  =  rangeSwitch != nil ? rangeSwitch : "on"
    
        self.filterDelegate?.filterDataToRecentOrder(fromDate:fromDate, toDate:toDate, ordered_date: ordered_date, rangeStatus:rangeStatus!)
         self.dismiss(animated: true, completion: nil )

    }
    
    
    
    
    
    @IBAction func clearFilter(_ sender: Any) {
        dateFrom.text! = ""
        dateTo.text! = ""
         applyBtn.isEnabled = false
        applyBtn.backgroundColor = .gray
        
    }
    
    
    
  
    
   
  
    

}
