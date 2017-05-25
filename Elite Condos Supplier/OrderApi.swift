//
//  OrderApi.swift
//  Elite Condos Supplier
//
//  Created by Hien on 4/14/17.
//  Copyright © 2017 Hien. All rights reserved.
//

import Foundation
import Firebase
import UIKit
import ProgressHUD

/**
 All the network code related to order.
 - Author: Nguyen Hien
 
 */
class OrderApi{
    
    /**
     list images
     - Author: Nguyen Hien
     
     */
    var images: [UIImage] = [UIImage]()
    
    /**
     main service of the oder
     - Author: Nguyen Hien
     
     */
    var mainService = ""
    
    /**
     subservice of the oder
     - Author: Nguyen Hien
     
     */
    var subService = ""
    
    
    /**
     service's ID of the oder
     - Author: Nguyen Hien
     
     */
    var serviceId = ""
    
    // finish orders
    /**
     finish orders
     
     - Parameter orderId: order's Id
     - Parameter total: total price tag of the order
     - Parameter onSuccess: the function executes after finishing order
     - Author: Nguyen Hien
     
     */
    func finishOrder(orderId: String, total: Double, onSuccess: @escaping () -> Void){
        FirRef.ORDERS.child(orderId).updateChildValues(["total": total, "status": ORDER_STATUS.FINISHED.hashValue])
        onSuccess()
    }
    
    // add price tag
    /**
     add price tag
     
     - Parameter orderId: order's Id
     - Parameter priceTagData: price tag 's database
     - Parameter onSuccess: the function executes after adding price tag
     - Author: Nguyen Hien
     
     */
    func addPriceTag(orderId: String, priceTagData : Dictionary<String,Any>){
        let randomId = randomString(length: 12)
        
        FirRef.ORDERS.child(orderId).child("pricetag").child(randomId).updateChildValues(priceTagData)
    }
    
    
    // delete price tag
    /**
     delete price tag
     
     - Parameter orderId: order's Id
     - Parameter priceTagId: price tag 's ID
     - Author: Nguyen Hien
     
     */
    func deletePriceTag(orderId: String, priceTagId: String){
        
        FirRef.ORDERS.child(orderId).child("pricetag").child(priceTagId)
            .removeValue()
    }
    
    
    // cancel order
    /**
     cancel order
     
     - Parameter id: order's Id
     - Parameter onSuccess: the function executes after canceling order
     - Author: Nguyen Hien
     
     */
    func cancelOrder(at id: String, onSuccess: @escaping () -> Void ){
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.CANCEL.hashValue])
        onSuccess()
    }
    
    // accept order
    /**
     accept order
     
     - Parameter id: order's Id
     - Parameter onSuccess: the function executes after accepting order
     - Author: Nguyen Hien
     
     */
    func acceptOrder(at id: String, onSuccess: @escaping () -> Void ){
        let currentId = Api.User.currentUid()
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.ONGOING.hashValue, "supplierId": currentId])
        onSuccess()
    }
    
    // deny order
    /**
     deny order
     
     - Parameter id: order's Id
     - Parameter onSuccess: the function executes after dening order
     - Author: Nguyen Hien
     
     */
    func denyOrder(at id: String, onSuccess: @escaping () -> Void ){
        //        let currentId = Api.User.currentUid()
        //        FirRef.ORDERS.child(id).removeValue()
        //        FirRef.SUPPLIER_ORDERS.child(currentId).child(id).removeValue()
        FirRef.ORDERS.child(id).updateChildValues(["status": ORDER_STATUS.REJECTED.hashValue])
        onSuccess()
    }
    
    // get user's image
    /**
     get user's image
     
     - Parameter id: user's Id
     - Parameter onError: the function executes when can not  deny order
     - Parameter onSuccess: the function executes after dening order
     - Author: Nguyen Hien
     
     */
    func getUserPhoto(id: String, onError: @escaping (String) -> Void, onSuccess: @escaping (UIImage) -> Void ){
        FirRef.CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let imgUrl = snapData["avatarUrl"] as? String{
                    
                    Api.User
                        .downloadImage(imgUrl: imgUrl, onError: onError, onSuccess: onSuccess)
                }
            }
        })
        
        
        
    }
    
    /**
     get customer's name
     
     - Parameter id: customer's Id
     - Parameter onSuccess: the function executes after dening order
     - Author: Nguyen Hien
     
     */
    func getCustomerName(id: String, onSuccess: @escaping (String) -> Void){
        FirRef.CUSTOMERS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapData = snapshot.value as? Dictionary<String,Any>{
                if let name = snapData["name"] as? String{
                    onSuccess(name)
                }
            }
        })
    }
    
    
    
    // upload order photos -> img links
    /**
     init oder , upload order photos -> img links
     - Parameter orderData: list order's data base
     - Parameter onSuccess :The function executes after initing order
     - Author: Nguyen Hien
     
     */
    func initOrder(orderData: [String:Any], onSuccess: @escaping (String) -> Void){
        uploadPhotos { (imgUrls) in
            var newData = orderData
            var imgStrings = ""
            for (index,value) in imgUrls.enumerated(){
                if (index == imgUrls.count - 1){
                    imgStrings += value
                }else {
                    imgStrings += "\(value),"
                }
            }
            newData["imgUrls"] = imgStrings
            let newChildId = randomString(length: 8)
            
            
            
            FirRef.ORDERS.child(newChildId).updateChildValues(newData)
            onSuccess(newChildId)
        }
    }
    
    // upload multiple photos
    /**
     upload multiple photos
     - Parameter onSuccess :The function executes after uploading Photos
     - Author: Nguyen Hien
     
     */
    func uploadPhotos(onSuccess: @escaping ([String]) -> Void){
        var imgUrls: [String] = []
        guard images.count > 0 else {
            return
        }
        
        let task = DispatchWorkItem {
            for img in self.images{
                
                self.uploadPhoto(photo: img, onSuccess: { (imgUrl) in
                    imgUrls.append(imgUrl)
                }, onError: { (error) in
                    print(error)
                })
                
            }}
        
        
        let start = DispatchTime.now()
        task.perform()
        
        
        let end  = DispatchTime.now()
        
        
        
        let nanoTime = end.uptimeNanoseconds - start.uptimeNanoseconds
        
        let timeInterval = Double(nanoTime) / 1_000_000_000
        
        print("time= \(timeInterval))")
        
        
        
        
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5 ) {
            print("upload ok")
            onSuccess(imgUrls)
        }
        
    }
    
    // upload 1 photo
    /**
     upload 1 photo
     - Parameter photo: the UIImage
     - Parameter onSuccess :The function executes after uploading Photo
     - Parameter onError : The function executes when can not upload Photo
     - Author: Nguyen Hien
     
     */
    func uploadPhoto(photo: UIImage, onSuccess: @escaping (String) -> Void, onError: @escaping (String) -> Void){
        if let imgData = UIImageJPEGRepresentation(photo, 0.2){
            let imgUid = NSUUID().uuidString
            let metadata = FIRStorageMetadata()
            metadata.contentType = "image/jpeg"
            
            
            
            FirRef.ORDER_IMAGES.child(imgUid).put(imgData, metadata: metadata, completion: { (metaData, error) in
                if error != nil{
                    onError("error \(error.debugDescription)")
                }else{
                    let downloadURL = metaData!.downloadURL()!.absoluteString
                    print("download URl \(downloadURL)")
                    onSuccess(downloadURL)
                }
            })
        }
    }
    
    // update order with new supplierid
    
    /**
     update order with new supplierid
     - Parameter orderId: oder's ID
     - Parameter supplierId: supplier's ID
     - Parameter customerId: customer's ID
     - Parameter orderData: order's Data
     - Parameter onSuccess :The function executes after uploading Photo
     - Author: Nguyen Hien
     
     */
    func updateOrder(orderId: String, supplierId : String, customerId : String, orderData : Dictionary<String,Any>, onSuccess: @escaping () -> Void){
        
        
        
        FirRef.ORDERS.child(orderId).updateChildValues(orderData)
        
        //
        
        FirRef.SUPPLIER_ORDERS.child(supplierId).child(orderId).setValue(true)
        FirRef.CUSTOMER_ORDERS.child(customerId).child(orderId).setValue(true)
        
        onSuccess()
    }
    
    
    // observe orders
    /**
     observe cancel orders
     - Parameter completed: The function executes after observing cancel orderss
     - Author: Nguyen Hien
     
     */
    func observeCancelOrders(completed: @escaping (Order) -> Void){
        
        let uid = Api.User.currentUid()
        FirRef.SUPPLIER_ORDERS.child(uid).observe(.value, with: { (snapshot)
            in
            if let snapshots = snapshot.children.allObjects as? [FIRDataSnapshot]{
                for child in snapshots {
                    
                    FirRef.ORDERS.queryOrderedByKey().queryEqual(toValue: child.key).observe(.value, with: { (orderSnapshot) in
                        if let dict = orderSnapshot.value as? [String:Any]{
                            print(dict)
                            if let status = dict["status"] as? Int{
                                if status == 1 {
                                    print("status \(status)")
                                    let order = Order(id: orderSnapshot.key, data: dict)
                                    completed(order)
                                }
                            }
                        }
                    })}}})}
    
    // observe Orders
    /**
     observe price tags on PaymentConfirmation screen
     - Parameter orderId : Oder 's ID
     - Parameter completion : the function executes after observing price tag
     - Author: Nguyen Hien
     
     */
    func observeOrders(orderId: String,completed: @escaping (Order) -> Void){
        
        FirRef.ORDERS.child(orderId).observe(.value, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                
                let order = Order(id: orderId, data: dict)
                completed(order)
                
            }
            
            
            
        })
        
        
    }
    
    
    
    
    
    // observe price tags - each orders have at least 1 price tag
    // price tags are displayed on PaymentConfirmation screen.
    
    /**
     observe price tags on PaymentConfirmation screen
     - Parameter orderId : Oder 's ID
     - Parameter completion : the function executes after observing price tag
     - Author: Nguyen Hien
     
     */
    func observePriceTag(orderId: String, completed: @escaping (PriceTag) -> Void){
        FirRef.ORDERS.child(orderId).child("pricetags").observe(.childAdded, with: { (snapshot) in
            if let dict = snapshot.value as? [String:Any]{
                let priceTag = PriceTag(id: snapshot.key, data: dict)
                completed(priceTag)
            }
        })
    }
    
    // confirm payment when order is finised, use in PaymentConfirmationVC
    /**
     confirm payment when order is finised, use in PaymentConfirmationVC.
     - Parameter orderId : Oder 's ID
     - Parameter totalPrice : total price
     - Parameter completion : he function executes after  confirming payment
     - Author: Nguyen Hien
     
     */
    func confirmPayment(orderId: String, totalPrice: Double, completion: @escaping () -> Void){
        let today = Date().description
        FirRef.ORDERS.child(orderId).updateChildValues(["totalPrice": totalPrice, "ended_at" : today, "status": ORDER_STATUS.FINISHED.hashValue ])
        completion()
    }
    
}
