//
//  Supplier.swift
//  Elite Condos
//
//  Created by Khoa on 11/15/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import Foundation
import Firebase

/**
 We follow MVC model.
 This class is for data model: Supplier
 - Author: Khoa Nguyen
 
 */
class Supplier {
    
    private var _id : String!
    private var _name : String!
    private var _address : String!
    private var _description : String!
    private var _logo : String!
    private var _serviceRef : FIRDatabaseReference!
    
    
    /**
     Supplier's name
     - Author: Khoa Nguyen
     
     */
    var name : String{
        if _name == nil{
            return "NO NAME"
        }
        return _name
    }
    /**
     Supplier's address
     - Author: Khoa Nguyen
     
     */
    var address : String{
        return _address
    }
    
    /**
     Supplier's description
     - Author: Khoa Nguyen
     
     */
    var description : String{
        return _description
    }
    
    /**
     Supplier's logo
     - Author: Khoa Nguyen
     
     */
    var logo : String{
        if _logo == nil{
            return ""
        }
        return _logo
    }
    /**
     Supplier's id
     - Author: Khoa Nguyen
     
     */
    var id : String{
        return _id
    }
    /**
     Supplier's serviceRef
     - Author: Khoa Nguyen
     
     */
    var serviceRef : FIRDatabaseReference{
        return _serviceRef
    }
    
    /**
     The constructor.
     - Parameter id: The id of supplier
     - Parameter data: A ***Dictionary*** with supplier's data. We need to unwrap it.
     - Author: Khoa Nguyen
     
     */
    init(id : String, data : Dictionary<String, Any>) {
        self._id = id
        if let name = data["name"] as? String{
            self._name = name
        }
        if let address = data["address"] as? String{
            self._address = address
        }
        if let description = data["description"] as? String{
            self._description = description
        }

        if let logo = data["logoUrl"] as? String{
           self._logo = logo
        }
        
       
        
    }
    
    
}
