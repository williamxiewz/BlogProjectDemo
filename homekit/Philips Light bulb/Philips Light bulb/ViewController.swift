//
//  ViewController.swift
//  Philips Light bulb
//
//  Created by Going-jobs on 8/9/16.
//  Copyright © 2016 WilliamXie. All rights reserved.
//

import UIKit
import HomeKit

class ViewController: UITableViewController {
    //家庭管理者
    var homeManager = HMHomeManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeManager.delegate = self
        self.navigationItem.leftBarButtonItem = editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// MARK: - UITableViewDelegate
extension ViewController{
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //获取home
            let home = homeManager.homes[(indexPath as NSIndexPath).row]
            homeManager.removeHome(home, completionHandler: { (error) -> Void in
                if error != nil {
                    print(error)
                } else  {
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            })
        }
    }
}
// MARK: - UITableViewDataSource
extension ViewController{
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeManager.homes.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let home = homeManager.homes[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = home.name
        
        return cell
    }
}
// MARK: - HMHomeManagerDelegate
extension ViewController : HMHomeManagerDelegate{
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        print("home更新")
        tableView.reloadData()
    }
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        print("home已经被移除")
    }
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "addHome" {
            let navController = segue.destination as! UINavigationController
            let addHomeViewController = navController.topViewController as! AddHomeViewController
            addHomeViewController.homeManager = homeManager
            
        }else if segue.identifier == "showRooms"{
            
            let listRoomsViewController = segue.destination as! ListRoomsViewController
            let home = homeManager.homes[tableView.indexPathForSelectedRow!.row]
            
            
            listRoomsViewController.home = home
        }
    }
}
