//
//  SupplierHomeVC.swift
//  Elite Condos
//
//  Created by Khoa on 11/16/16.
//  Copyright © 2016 Khoa. All rights reserved.
//

import UIKit
import Firebase
import ProgressHUD

/**
 
 List all orders of a user ( customer ) base on status. User can click on different buttons to change the order's status.
 - Author: Khoa Nguyen
 
 */


class HomeVC: UIViewController {
    
    /**
     UITableView
     - Author: Khoa Nguyen
     
     */
    
    
    @IBOutlet weak var tableView: UITableView!
    /**
     Mennu bar button
     - Author: Khoa Nguyen
     
     */
    
    @IBOutlet weak var menuBarButton: UIBarButtonItem!
    /**
     List of orders. We will download orders from Firebase and store to this variable
     - Author: Khoa Nguyen
     
     */
    var orders = [Order]()
    /**
     
     The built-in function of UIViewController. This function executes before a screen was loaded
     
     - Author: Khoa Nguyen
     
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let token = UserDefaults.standard.value(forKey: "token") as? String{
            Api.User.updateTokenToDatabase(token: token, onSuccess: {
                print("Update token in HomeVC with: \(token)")
            })
        }
    }
    
    /**
     
     The built-in function of UIViewController. This function executes after a screen was loaded
     
     - Author: Khoa Nguyen
     
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        if self.revealViewController() != nil{
            menuBarButton.target = self.revealViewController()
            menuBarButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        fetchNewOrders()

    }
    
    /**
     Fetch orders base on their status. Then refresh tableview to show new data.
     - Parameter orderStatus: The status of order
     - Author: Khoa Nguyen
     
     */
    
    func fetchOrders(orderStatus: Int){
         let currenId = Api.User.currentUid()
        ProgressHUD.show("Đang tải dữ liệu...")
        
        
        FirRef.ORDERS.queryOrdered(byChild: "supplierId").queryEqual(toValue: currenId).observe(.value, with: { (snapshots) in
            print(snapshots)
            
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        if let status = dict["status"] as? Int{
                            if status ==  orderStatus{
                                print("alo \(status)")
                                let order = Order(id: orderSnapshot.key, data: dict)
                                self.orders.append(order)
                            }
                        }
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }
            
            
            
        })
    }
    
    /**
     Fetch order that has status: NOTACCEPTED
     - Author: Khoa Nguyen
     
     */
    
    func fetchNewOrders(){
        
        ProgressHUD.show("Đang tải dữ liệu...")
       
        
        
        let ref = FirRef.ORDERS.queryOrdered(byChild: "status").queryEqual(toValue: ORDER_STATUS.NOTACCEPTED.hashValue)
        
        ref.observe(.value, with: { (snapshots) in
            
                        print(snapshots)
            if let snapshots = snapshots.children.allObjects as? [FIRDataSnapshot]{
                self.orders.removeAll()
                for orderSnapshot in snapshots{
                    if let dict = orderSnapshot.value as? [String:Any]{
                        print(dict)
                        let order = Order(id: orderSnapshot.key, data: dict)
                        self.orders.append(order)
                    }
                    
                }
                ProgressHUD.dismiss()
                self.tableView.reloadData()
                
            }
        })

    }
    
    /**
     Reload tableview with new orders with status: ***NOTACCEPTED***
     - Parameter sender: The button when the user presses
     - Author: Khoa Nguyen
     
     */
    @IBAction func newBtn_TouchInside(_ sender: Any) {
        fetchNewOrders()
    }
    
    /**
     Reload tableview with new orders with status: ***ONGOING***
     - Parameter sender: The button when the user presses
     - Author: Khoa Nguyen
     
     */
    @IBAction func ongoingBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.ONGOING.hashValue)
    }
    
    /**
     Reload tableview with new orders with status: ***CANCEL***
     - Parameter sender: The button when the user presses
     - Author: Khoa Nguyen
     
     */
    @IBAction func cancelBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.CANCEL.hashValue)
    }
    /**
     Reload tableview with new orders with status: ***FINISHED***
     - Parameter sender: The button when the user presses
     - Author: Khoa Nguyen
     
     */
    @IBAction func finishBtn(_ sender: Any) {
        fetchOrders(orderStatus: ORDER_STATUS.FINISHED.hashValue)
    }
    /**
     Prepare data and logic code when it's about to move to next screen
     - Parameter segue: From this screen, we just can go to PriceTagVC or OrderDetailVC
     - Parameter sender: sender will be a Dictionary with order's data
     - Author: Khoa Nguyen
     
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "HomeToPriceTag"{
            if let priceTagVC = segue.destination as? PriceTagVC{
                if let id = sender as? String{
                    priceTagVC.orderId = id
                }
            }
        }
        
        if segue.identifier == "HomeToOrderDetail"{
            if let orderDetail = segue.destination as? OrderDetailVC{
                if let id = sender as? String{
                    orderDetail.orderId = id
                }
            }
        }
    }
    
}
extension HomeVC: UITableViewDelegate{
    /**
     
     The built-in function of UITableViewDelegate. This function executes when user clicks on a specific row.
     
     - Author: Khoa Nguyen
     
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let status = orders[indexPath.row].status
        
        // NOT ACCEPTED:
        if status == 0 {
            
            let alert = UIAlertController(title: APP_NAME, message: "Action", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Từ chối đơn hàng", style: .default, handler: { action in
                // cancel api here - reload tableview
                Api.Order.denyOrder(at: self.orders[indexPath.row].id!, onSuccess: {
                    print("OK")
                })
            })
            
            let accept = UIAlertAction(title: "Đồng ý đơn hàng", style: .default, handler: { action in
                
                Api.Order.acceptOrder(at: self.orders[indexPath.row].id!, onSuccess: {
                    
                })
                
            })
            let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(cancel)
            alert.addAction(accept)
            alert.addAction(dismiss)
            present(alert, animated: true, completion: nil)
            
        }else if status == 1 {
            let alert = UIAlertController(title: APP_NAME, message: "Action", preferredStyle: .alert)
            
            let cancel = UIAlertAction(title: "Hủy đơn hàng", style: .default, handler: { action in
                // cancel api here - reload tableview
                Api.Order.cancelOrder(at: self.orders[indexPath.row].id!, onSuccess: { 
                    
                })
            })
            
            let accept = UIAlertAction(title: "Hoàn thành công việc", style: .default, handler: { action in
                // ok api here - reload tableview - move to detail orders
                self.performSegue(withIdentifier: "HomeToPriceTag", sender: self.orders[indexPath.row].id)
            })
            let dismiss = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(cancel)
            alert.addAction(accept)
            alert.addAction(dismiss)
            present(alert, animated: true, completion: nil)
        }
    }
}
extension HomeVC: UITableViewDataSource{
    
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
        return orders.count
    }
    
    /**
     
     The built-in function of UITableViewDataSource. This function determines
     what UIs will be displayed in a row in the tableview
     
     - Author: Khoa Nguyen
     
     */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as!
        OrderCell
        cell.delegate = self
        cell.order = orders[indexPath.row]
        return cell
    }
    

}
extension HomeVC: OrderCellDelegate{
    /**
     
     Load an order detail base on order's id
     - Parameter orderId: Order's Id
     
     - Author: Khoa Nguyen
     
     */
    func moveToDetail(orderId: String) {
        performSegue(withIdentifier: "HomeToOrderDetail", sender: orderId)
    }
    
    /**
     
     Deny (reject ) an order.
     - Parameter orderId: Order's Id
     
     - Author: Khoa Nguyen
     
     */
    
    func denyOrder(orderId: String) {
        Api.Order.denyOrder(at: orderId) { 
            self.fetchOrders(orderStatus: ORDER_STATUS.CANCEL.hashValue)
        }
        print(ORDER_STATUS.CANCEL.hashValue)
    }
    
}

