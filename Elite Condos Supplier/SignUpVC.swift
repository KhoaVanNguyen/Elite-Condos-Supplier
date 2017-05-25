//
//  SupplierSignUp.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD
class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    /**
     Hiển thị label dòng chữ "Click để chọn logo"
     - Author: Hoang Phan
     */
    @IBOutlet weak var pickLogoLbl: UILabel!
    /**
     TextField lưu mật khẩu đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var passwordLbl: FancyField!
    /**
     TextField lưu số điện thoại đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var phoneLbl: FancyField!
    /**
     TextField lưu địa chỉ đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var addressLbl: FancyField!
    /**
     TextField lưu email đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var emailLbl: FancyField!
    /**
     TextField lưu tên công ty đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var nameLbl: FancyField!
    /**
     ImageView lưu logo công ty đăng ký
     - Author: Hoang Phan
     */
    @IBOutlet weak var logoImage: UIImageView!
    /**
     Biến lưu logo picker công ty đăng ký
     - Author: Hoang Phan
     */
    var imagePicker : UIImagePickerController!
    /**
     Biến kiểm tra User đã được tạo chưa?
     - Author: Hoang Phan
     */
    var _userCreated = false
    /**
     Biến lưu logo picker công ty đã được chọn chưa
     - Author: Hoang Phan
     */
    var isPickedImage = false
    
    /**
     Hàm mặc định, load xong sẽ thực hiện
     - Author: Hoang Phan
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    /**
     Hàm chọn hình hiển thị
     - Author: Hoang Phan
     - Parameter picker: chọn hình
     - Parameter didFinishPickingMediaWithInfo: thông tin của hình đã được chọn
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let img = info[UIImagePickerControllerEditedImage] as? UIImage{
            logoImage.image = img
            isPickedImage = true
            pickLogoLbl.isHidden = true
            logoImage.isHidden = false
        }else{
            print("Can't show image picker")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    /**
     Hàm click để chọn Logo
     - Author: Hoang Phan
     */
    @IBAction func pickLogoBtn(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)
    }
    /**
     Button chuyển qua màn hình đăng ký tài khoản
     - Author: Hoang Phan
     */
    @IBAction func signUpButton(_ sender: Any) {
        
        guard let name = nameLbl.text, name != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_NAME)
            return
        }
        guard let email = emailLbl.text, let password = passwordLbl.text, email != "" , password != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_EMAIL_PASSWORD)
            return
        }
        guard let address = addressLbl.text, address != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_ADDRESS)
            return
        }
        guard let phone = phoneLbl.text, phone != "" else {
            showAlert(title: SIGN_UP_ERROR, message: SIGN_UP_ERROR_PHONE)
            return
        }
        guard isPickedImage == true else {
            showAlert(title: "Lỗi", message: "Vui lòng chọn logo")
            return
        }
        
        ProgressHUD.show("Đang đăng ký")
        Api.User.signUp(name: name, email: email, password: password, phone: phone, address: address,  avatarImg: logoImage.image!, onSuccess: {
            ProgressHUD.dismiss()
            let alert = UIAlertController(title: APP_NAME, message: "Đăng ký thành công!", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Đăng Nhập", style: .default, handler: {
                action in
                self.performSegue(withIdentifier: "SignUpToHomeVC", sender: nil)
            })
            
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }) { (error) in
            ProgressHUD.dismiss()
            self.showAlert(title: "Lỗi đăng ký", message: error)
        }
        
    }
    
    // MARK: Functions
    /**
     Hàm quay trở lại màn hình trước
     - Author: Hoang Phan
     */
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    /**
     Hàm mặc định của swift, hiển thị thông báo ra ngoài màn hình
     - Author: Hoang Phan
     */
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    /**
     Hàm mặc định của swift, kiểm tra đã click ra khỏi bàn phím chưa, thực hiện tắt bàn phím
     - Author: Hoang Phan
     */
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
