//
//  SupplierMenuTVC.swift
//  Elite Condos
//
//  Created by Hoang on 11/16/16.
//  Copyright © 2016 Hoang. All rights reserved.
//

import UIKit
import Firebase
class SideMenuTVC: UITableViewController {
    
    /**
     UITableViewCell lưu thông tin của Side Menu (Đơn hàng, Nhận xét, Cài đặt dịch vụ, Đăng xuất)
     - Author: Hoang Phan
     */
    @IBOutlet weak var statisticsCell: UITableViewCell!
    
    /**
     Label lưu tên của công ty
     - Author: Hoang Phan
     */
    @IBOutlet weak var serviceNameLbl: UILabel!
    /**
     Logo, hình đại diện công ty
     - Author: Hoang Phan
     */
    @IBOutlet weak var logoImage: CircleImage!
    /**
     Hàm mặc định của swift, load xong thì thực hiện
     - Author: Hoang Phan
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 48/255, green: 49/255, blue: 77/255, alpha: 1.0)
        
        
        
        
        //        configureActionForCell()
        let currentId = Api.User.currentUid()
        FirRef.SUPPLIERS.child(currentId).observeSingleEvent(of: .value, with: {
            snapshot in
            if let snapshot = snapshot.value as? Dictionary<String,Any>{
                if let name = snapshot["name"] as? String{
                    self.serviceNameLbl.text = name
                }
                
                if let avatarUrl = snapshot["logoUrl"] as? String{
                    print(avatarUrl)
                    let ref = FIRStorage.storage().reference(forURL: avatarUrl)
                    
                    ref.data(withMaxSize: 2 * 1024 * 1024, completion:
                        { data, error in
                            if error != nil{
                                print("can't download image from Firebase")
                            }else{
                                
                                if let data = data {
                                    print(" from Firebase")
                                    print(data)
                                    if let imageData = UIImage(data: data){
                                        self.logoImage.image = imageData
                                    }
                                }
                            }
                            
                    })
                }
            }
        })
        
    }
    //    func configureActionForCell(){
    ////        let employeeTapped = UITapGestureRecognizer(target: self, action: #selector(self.showBetaMessage))
    ////        employeeCell.addGestureRecognizer(employeeTapped)
    ////        employeeCell.isUserInteractionEnabled = true
    ////
    //        let statisticsTapped = UITapGestureRecognizer(target: self, action: #selector(self.showBetaMessage))
    //        statisticsCell.addGestureRecognizer(statisticsTapped)
    //        statisticsCell.isUserInteractionEnabled = true
    //
    //    }
    
    /**
     Thông báo tính năng đang được xây dựng.
     - Author: Hoang Phan
     */
    func showBetaMessage(){
        showAlert(title: APP_NAME, message: "Oops, Tính năng đang được xây dựng!")
    }
    
    /**
     Hiển thị thông báo
     - Author: Hoang Phan
     */
    func showAlert(title: String, message : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    /**
     Hàm di chuyển qua menu User setting
     - Author: Hoang Phan
     */
    @IBAction func goToUserSettings(_ sender: Any) {
        
        performSegue(withIdentifier: "MenuToUserSettings", sender: nil)
    
        
        
    }
    
    
    /**
     Hàm đăng xuất
     - Author: Hoang Phan
     */
    @IBAction func logoutBtn(_ sender: Any) {
        
        AuthService.logout(onSuccess: {
            
            let storyboard = UIStoryboard.init(name: "Start", bundle: nil)
            let startVC = storyboard.instantiateViewController(withIdentifier: "StartVC")
            
            present(startVC, animated: true, completion: nil)
            
        }) { (error) in
            print("error")
        }
        
    }
}
