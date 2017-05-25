//
//  ServiceSettingVC.swift
//  Elite Condos Supplier
//
//  Created by Nguyen Hien on 3/18/17.
//  Copyright © 2017 Nguyen Hien. All rights reserved.
//

import UIKit
import ProgressHUD

/**
 ServiceSettingVC
 - Author: Nguyen Hien
 
 */
class ServiceSettingVC: UIViewController {
    /**
     UIBarButtonItem
     - Author: Nguyen Hien
     
     */
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    
    /**
     services's database
     - Author: Nguyen Hien
     
     */
    var services = getServiceData()
    /**
     UITableView
     - Author: Nguyen Hien
     
     */
    @IBOutlet weak var tableView: UITableView!
    
    /**
     
     The built-in function of UIViewController. This function executes after a screen was loaded
     
     - Author: Nguyen Hien
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ServiceSettingVC: UITableViewDataSource{
    
    /**
     
     The built-in function of UITableViewDataSource. This function determines
     the number of section in the tableview
     
     - Author: Khoa Nguyen
     
     */
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    /**
     
     The built-in function of UITableViewDataSource. This function determines
     the number of rows in a section in the tableview
     
     - Author: Khoa Nguyen
     
     */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services.count
    }
    
    
    /**
     
     The built-in function of UITableViewDataSource. This function determines
     what UIs will be displayed in a row in the tableview
     
     - Author: Khoa Nguyen
     
     */
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ServiceCell", for: indexPath) as! ServiceCell
        cell.service = services[indexPath.row]
        
        
        Api.Service.checkExist(service: services[indexPath.row], onFound: {
            cell.changeSubscribeLabel(value: true)
            ProgressHUD.showSuccess("Xong")
        }, notFound: {
            cell.changeSubscribeLabel(value: false)
        }) { (error) in
            print(error)
            ProgressHUD.dismiss()
        }
        return cell
        
    }
}
extension ServiceSettingVC: UITableViewDelegate{
    
    /**
     
     The built-in function of UITableViewDelegate. This function executes when user clicks on a specific row.
     
     - Author: Khoa Nguyen
     
     */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! ServiceCell
        Api.Service.checkExist(service: services[indexPath.row], onFound: {
            Api.Service.deleteService(service: self.services[indexPath.row], onDeleted: {
                cell.changeSubscribeLabel(value: false)
                self.tableView.reloadData()
            })
        }, notFound: {
            Api.Service.subscribe(service: self.services[indexPath.row], onSuccess: {
                cell.changeSubscribeLabel(value: true)
                self.tableView.reloadData()
            }, onError: { (error) in
                print(error)
            })
            
        }) { (error) in
            print(error)
        }
    }
    
}
