//
//  StartVC.swift
//  Elite Condos
//
//  Created by Hoang on 11/14/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

import UIKit

class StartVC: UIViewController {
    /**
     Hàm mặc định của swift, load xong sẽ thực hiện
     - Author: Hoang Phan
     */
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    /**
     Hàm mặc định của swift, sau khi xuất hiện lại màn hình
     - Author: Hoang Phan
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ( Api.User.CURRENT_USER != nil   ){
            self.performSegue(withIdentifier: "StartToHome", sender: nil)
            
        }
    }
    /**
     Hàm chuyển qua màn hình đăng ký
     - Author: Hoang Phan
     */
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "SupplierSignUp", sender: nil)
    }
    /**
     Hàm chuyển qua màn hình đăng nhập
     - Author: Hoang Phan
     */
    @IBAction func signInButton(_ sender: Any) {
        performSegue(withIdentifier: "SupplierSignIn", sender: nil)
    }
   

}
