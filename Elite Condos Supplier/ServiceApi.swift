
//
//  ServiceApi.swift
//  Elite Condos Supplier
//
//  Created by Hien on 3/9/17.
//  Copyright © 2017 Hien. All rights reserved.
//

import Foundation
import Firebase

/**
 All the network code related to service .
 - Author: Nguyen Hien
 
 */

class ServiceApi {
    /**
     observe  service
     - Parameter onSuccess: The function executes after observing service
     - Parameter onError: The function execute when can not observe service
     - Author: Nguyen Hien
     
     */
    func observeService(onSuccess: @escaping (Service) -> Void, onError: @escaping (String) -> Void){
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        
        FirRef.SUPPLIER_SERVICES.child(supplierID).observe(.childAdded, with: { (snapshot) in
            print("supplier service: \(snapshot.key)")
            
            self.getServiceData(serviceId: snapshot.key, onSuccess: { (service) in
                onSuccess(service)
                
            })
        })
        
        
    }
    
    /**
     user can subscribe  service
     - Parameter service:
     - Parameter onSuccess: The function executes after subscribing service
     - Parameter onError: The function execute when can not subscribe service
     - Author: Nguyen Hien
     
     */
    func subscribe(service: ServiceData, onSuccess: @escaping () -> Void, onError: @escaping (String) -> Void ){
        
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        
        FirRef.SERVICES.child(service.id!).updateChildValues([
            "name": service.name
            ])
        FirRef.SERVICES.child(service.id!).child("suppliers").updateChildValues([
            supplierID: true])
        
        FirRef.SUPPLIER_SERVICES.child(supplierID).child(service.id!).setValue(true)
        
        onSuccess()
    }
    
    /**
     Check whether the service exists or not
     - Parameter service:Service's database
     - Parameter onFound: The function executes when  service on found
     - Parameter notFound: The function executes when  service not found
     - Parameter onError: The function execute when can not check
     - Author: Nguyen Hien
     
     */
    func checkExist(service: ServiceData, onFound:  @escaping  () -> Void, notFound:  @escaping  () -> Void, onError: @escaping (String) -> Void ){
        
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            onError("Can't find supplier")
            return
        }
        FirRef.SUPPLIER_SERVICES.child(supplierID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.hasChild(service.id!){
                onFound()
                print("on found")
            }
            else {
                notFound()
                print("not found")
            }
        })
    }
    
    /**
     delete service
     - Parameter service:Service's database
     - Parameter onDeleted: The function executes when  service on found
     - Author: Nguyen Hien
     
     */
    
    func deleteService(service: ServiceData, onDeleted:  @escaping  () -> Void){
        guard let supplierID = Api.User.CURRENT_USER?.uid else {
            //            onError("Can't find supplier")
            return
        }
        FirRef.SUPPLIER_SERVICES.child(supplierID).child(service.id!).removeValue()
        FirRef.SERVICES.child(service.id!).child("suppliers").child(supplierID).removeValue()
        onDeleted()
        
    }
    
    /**
     get service's date
     - Parameter serviceId :Service's ID
     - Parameter onSuccess: The function executes affter getting service's data
     - Author: Nguyen Hien
     
     */
    func getServiceData(serviceId: String, onSuccess: @escaping (Service) -> Void){
        FirRef.SERVICES.child(serviceId).observe(.value, with: { (serviceSnap) in
            print("serviceId: \(serviceId)")
            if let serviceData = serviceSnap.value as? [String:Any]{
                let service = Service(id: serviceId, data: serviceData)
                onSuccess(service)
            }
        })
    }
    
    
    
    
}
