//
//  ServiceListCell.swift
//  Elite Condos
//
//  Created by Khoa on 11/18/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit


/**
 We follow MVC model.
 This class is subclass of UITableViewCell

 - Author: Khoa Nguyen
 
 */

class ServiceListCell: UITableViewCell {

    /**
     Name label
     - Author: Khoa Nguyen
     
     */
    @IBOutlet weak var nameLbl: UILabel!
    
    /**
     Initialization code
     - Author: Khoa Nguyen
     
     */
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    /**
     Set price for cell
     - Author: Khoa Nguyen
     
     */
    func configureCell(service : Service){
        nameLbl.text  = service.name
    }

}
