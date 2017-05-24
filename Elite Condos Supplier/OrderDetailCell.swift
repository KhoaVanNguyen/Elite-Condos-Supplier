//
//  OrderDetailCell.swift
//  Elite Condos Supplier
//
//  Created by Khoa on 5/14/17.
//  Copyright © 2017 Khoa. All rights reserved.
//

import UIKit


/**
 We follow MVC model.
 This class is subclass of UICollectionViewCell
 This class is for Detail Image Cell that is used collection of OrderDetailVC
 - Author: Khoa Nguyen
 
 */
class OrderDetailCell: UICollectionViewCell {
    
    /**
     Description's image
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var orderImage: UIImageView!
    
    
    
    /**
     Description's image url
     - Author: Khoa Nguyen
     
     */
    
    var imageLink: String?{
        didSet{
            updateImage()
        }
    }
    
    /**
     Initialization code
     - Author: Khoa Nguyen
     
     */
    override func awakeFromNib() {
        
    }
    
    /**
     Set order's image
     - Author: Khoa Nguyen
     
     */
    func updateImage(){
        
        let url = URL(string: imageLink!)
        
        self.orderImage.sd_setImage(with: url)
    }
    
    
    
}
