//
//  Order.swift
//  Elite Condos
//
//  Created by Khoa on 11/26/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation


/**
 We follow MVC model.
 This class is for data model: Order
 - Author: Khoa Nguyen
 
 */
class Order  {
    
    /**
     Order's id
     - Author: Khoa Nguyen
     
     */
    var id : String?
    /**
     Customer's Id
     - Author: Khoa Nguyen
     
     */
    var customerId : String?
    /**
     Service's name
     - Author: Khoa Nguyen
     
     */
    var serviceName : String?
    /**
     Supplier's id
     - Author: Khoa Nguyen
     
     */
    var supplierId : String?
    /**
     Employee's id
     - Author: Khoa Nguyen
     
     */
    var employeeId : String?
    /**
     The status of order
     - Author: Khoa Nguyen
     
     */
    var status : Int?
    /**
     Order's initial time.
     - Author: Khoa Nguyen
     
     */
    var time: String?
    var imgUrls: [String]?
    var description: String?
    
    
    //    var description: String{
    //        return _description
    //    }
    //
    //    var time: String{
    //        return _time
    //    }
    //
    //    var id : String{
    //        return _id
    //    }
    //    var customerId :String{
    //        return _customerId
    //    }
    //    var serviceName : String{
    //        return _serviceName
    //    }
    //    var employeeId : String{
    //        return _employeeId
    //    }
    //    var supplierId : String{
    //        return _supplierId
    //    }
    //
    //    var status : Int{
    //        return _status
    //    }
    
    
    /**
     The constructor.
     - Parameter id: The id of order
     - Parameter data: A ***Dictionary*** with order's data. We need to unwrap it.
     - Author: Khoa Nguyen
     
     */
    init(id : String, data : Dictionary<String,Any>) {
        self.id = id
        if let customerId = data["customerId"] as? String{
            self.customerId = customerId
        }
        if let name = data["name"] as? String{
            self.serviceName = name
        }
        if let supplierId = data["supplierId"] as? String{
            self.supplierId = supplierId
        }
        if let status = data["status"] as? Int{
            self.status = status
        }
        if let employeeId = data["employeeId"] as? String{
            self.employeeId = employeeId
        }
        if let serviceName = data["serviceName"] as? String{
            self.serviceName = serviceName
        }
        if let time = data["created_at"] as? String{
            self.time = time
        }
        if let imageUrls = data["imgUrls"] as? String{
            
            self.imgUrls = imageUrls.components(separatedBy: ",")
        }
        if let description = data["description"] as? String{
            self.description = description
        }
    }
    
    
    
    //    init(id : String, data : Dictionary<String,Any>) {
    //        self._id = id
    //        self.imgUrls = [String]()
    //        if let customerId = data["customerId"] as? String{
    //            self._customerId = customerId
    //        }
    //        if let name = data["name"] as? String{
    //            self._serviceName = name
    //        }
    //        if let supplierId = data["supplierId"] as? String{
    //            self._supplierId = supplierId
    //        }
    //        if let status = data["status"] as? Int{
    //            self._status = status
    //        }
    //        if let employeeId = data["employeeId"] as? String{
    //            self._employeeId = employeeId
    //        }
    //        if let serviceName = data["serviceName"] as? String{
    //            self._serviceName = serviceName
    //        }
    //        if let time = data["created_at"] as? String{
    //            self._time = time
    //        }
    //        if let description = data["description"] as? String{
    //            self._description = description
    //        }
    //        
    //        if let imageUrls = data["imgUrls"] as? String{
    //            
    //            self.imgUrls = imageUrls.components(separatedBy: ",")
    //        }
    //        
    //    }
    //    
}
