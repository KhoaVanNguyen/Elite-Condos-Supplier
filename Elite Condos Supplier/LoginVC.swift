//
//  LoginVC.swift
//  Elite Condos
//
//  Created by Hoang on 11/14/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class LoginVC: UIViewController , UITextFieldDelegate {

    /**
     TextField lưu mật khẩu đăng nhập
     - Author: Hoang Phan
     */
    @IBOutlet weak var passwordTF: FancyField!
    /**
     TextField lưu email đăng nhập
     - Author: Hoang Phan
     */
    @IBOutlet weak var emailTF: FancyField!
    /**
     Button trở về màn hình trước
     - Author: Hoang Phan
     */
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /**
     Hàm mặc định, load xong rồi thực hiện
     - Author: Hoang Phan
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    /**
     Button đăng nhập
     - Author: Hoang Phan
     */
    @IBAction func loginButton(_ sender: Any) {
        
        
        guard let email = emailTF.text, email != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_EMAIL)
            return
        }
        guard let password = passwordTF.text, password != "" else {
            showAlert(title: SIGN_IN_ERROR, message: SIGN_IN_ERROR_PASSWORD)
            return
        }
        
        ProgressHUD.show("Logging...")
        AuthService.login(email: email, password: password, onSuccess: {
            ProgressHUD.showSuccess("✓")
            self.performSegue(withIdentifier: "LoginToSupplierHome", sender: nil)
            
        }) { (errorDetail) in
            ProgressHUD.dismiss()
            self.showAlert(title: APP_NAME, message: errorDetail)
        }
    }
    /**
     Đã ấn enter (return) tại TextField password chưa?
     - Returns: Bool
     - Author: Hoang Phan
     */
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        passwordTF.resignFirstResponder()
        return true
    }
    /**
     Đã bắt đầu chạm ra ngoài thì tắt bàn phím xuống
     - Author: Hoang Phan
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /**
     Hiển thị thông báo ra màn hình
     - Author: Hoang Phan
     */
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)


        present(alert, animated: true, completion: nil)
        
    }

    /**
     Click vào thì chuyển sang màn hình đăng ký tài khoản
     - Author: Hoang Phan
     */
    @IBAction func goToSignInBtn(_ sender: Any) {
        
        performSegue(withIdentifier: "GoToSignIn", sender: nil)
        
    }
    
}
