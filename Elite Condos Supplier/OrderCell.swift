
//
//  Supplier_OrderCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/25/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase



/**
 
 Move to OrderDetail
 - Author: Khoa Nguyen
 
 */

protocol OrderCellDelegate{
    /**
     
     Move to OrderDetail
     - Author: Khoa Nguyen
     
     */
    func moveToDetail(orderId: String)
}
class OrderCell: UITableViewCell {
    
//    @IBOutlet weak var detailButton: FancyBtn!
    
    /**
     Order's id
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var orderIdLbl: UILabel!
    
    /**
     Order's initial time
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var timeLbl: UILabel!
    
    /**
     Customer's avatar
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var customerAvatarImg: CircleImage!
    
    
    /**
     Customer's name
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var customerNameLbl: UILabel!
    
    /**
     Customer's address
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var customerAddressLbl: UILabel!
    
    /**
     Delegation is a design pattern that enables a class or structure to delegate some of its responsibilities to an instance of another type.
     In this case: We need to delegate the `moveToDetail(_:)` to other class.
     - Author: Khoa Nguyen
     
     */
    var delegate: OrderCellDelegate?
    
    /**
     A feature of Swift, when this variable has value, a function will executes immediately
     - Author: Khoa Nguyen
     
     */
    var order: Order?{
        didSet{
            print("sau")
            updateView()
        }
    }
    
    
    /**
     Initialization code
     - Author: Khoa Nguyen
     
     */
    override func awakeFromNib() {
        super.awakeFromNib()
        print("truoc")
        // Initialization code
        
       
    }
    
  
    /**
     Set service's name, order's id, customer's avatar  and customer's name for controls.
     - Author: Khoa Nguyen
     
     */
    
    func updateView(){
        
        customerAddressLbl.text = order?.serviceName
        orderIdLbl.text = "# \((order?.id)!)"
        
        if order?.time != nil {
            timeLbl.text = getTimeStringFrom(str: (order?.time)!)
        }
        
        Api.Order.getCustomerName(id: (order?.customerId)!) { (name) in
            self.customerNameLbl.text  = name
        }
        Api.Order.getUserPhoto(id: (order?.customerId)!, onError: { (error) in
            print(error)
        }) { (img) in
            self.customerAvatarImg.image = img
        }
    }

    /**
     
     Move to OrderDetail
     - Author: Khoa Nguyen
     
     */
    @IBAction func detail_TouchInside(_ sender: Any) {
        delegate?.moveToDetail(orderId: (order?.id)!)
    }
    
    
}
