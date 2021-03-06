//
//  ReviewApi.swift
//  Elite Condos Supplier
//
//  Created by Hien on 4/16/17.
//  Copyright © 2017 Hien. All rights reserved.
//

import Foundation
import Firebase

/**
 All the network code related to review.
 - Author: Nguyen Hien
 
 */

class ReviewApi {
    
    
    /**
     observe  review
     - Parameter onSuccess: The function executes after observing service
     - Author: Nguyen Hien
     
     */
    func observeReview(onSuccess: @escaping (Review) -> Void){
        let currentId = Api.User.currentUid()
        FirRef.SUPPLIER_REVIEWS.child(currentId).observe(.value, with: {
            snapshot in
            
            for snap in snapshot.children.allObjects as! [FIRDataSnapshot]{
                
                FirRef.REVIEWS.child(snap.key).observe(.value, with: {
                    reviewSnap in
                    if let dict = reviewSnap.value as? [String:Any]{
                        let review = Review(id: snap.key, data: dict)
                        onSuccess(review)
                    }
                    
                } )
                
                
            }
            
            
        })
    }
    
    
}
