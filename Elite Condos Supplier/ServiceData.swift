//
//  ServiceData.swift
//  Elite Condos
//
//  Created by Khoa on 3/15/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import Foundation

/**
 The default service list
 - Author: Khoa Nguyen
 
 */

struct ServiceData{
    /**
     Service's id
     - Author: Khoa Nguyen
     
     */
    var id: String?
    /**
     Service's name
     - Author: Khoa Nguyen
     
     */
    var name: String!
    /**
     Service's image url
     - Author: Khoa Nguyen
     
     */
    var imgUrl: String!
    /**
     Service's sub category
     - Author: Khoa Nguyen
     
     */
    var subCategory: [ServiceData]?
    
    
    /**
     Constructor function
     - Author: Khoa Nguyen
     
     */
    
    init(name: String, imgUrl: String, subCategories: [ServiceData]?) {
        self.name = name
        self.imgUrl = imgUrl
        self.subCategory = subCategories
    }
    
    /**
     Constructor function
     - Author: Khoa Nguyen
     
     */
    
    init(id: String, name: String, imgUrl: String, subCategories: [ServiceData]?) {
        self.id = id
        self.name = name
        self.imgUrl = imgUrl
        self.subCategory = subCategories
    }
}

/**
 Helper function to return a array of available services
 - Author: Khoa Nguyen
 
 */
func getServiceData() -> [ServiceData]{
    let electricalService = ServiceData(id: "service01", name: "Electrical", imgUrl: "electrical.jpg", subCategories: nil)
    
    let plumbing = ServiceData(id: "service02", name: "Pluming", imgUrl: "plumbing.png", subCategories: nil)
    
    let appliances = ServiceData(id: "service03", name: "Appliances", imgUrl: "appliances.png", subCategories: nil)
    let services = [appliances,electricalService,plumbing]
    return services
    
}
