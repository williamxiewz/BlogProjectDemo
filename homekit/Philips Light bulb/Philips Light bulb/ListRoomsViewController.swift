//
//  ListRoomsViewController.swift
//  Philips Light bulb
//
//  Created by Going-jobs on 8/9/16.
//  Copyright © 2016 WilliamXie. All rights reserved.
//

import UIKit
import HomeKit

class ListRoomsViewController: UITableViewController ,HMHomeDelegate{
    
    var home: HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        home.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return home.rooms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let room = home.rooms[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = room.name
        
        return cell
    }
    
    //MARK: --实现数据源协议
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let room = home.rooms[(indexPath as NSIndexPath).row]
            home.removeRoom(room, completionHandler: { (error) -> Void in
                
                if error != nil {
                    print(error)
                } else  {
                    tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            })
        }
    }
    
    //MARK: --实现HMHomeDelegate协议
    func home(_ home: HMHome, didAdd room: HMRoom) {
        print("一个房间被创建")
    }
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        print("一个房间被删除")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject!) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == "addRoom"{
            
            let navController = segue.destination as! UINavigationController
            let addRoomViewController = navController.topViewController as! AddRoomViewController
            addRoomViewController.home = home
            
        } else if segue.identifier == "showDetailRoom" {
            
            let detailRoomViewController = segue.destination as! DetailRoomViewController
            detailRoomViewController.home = home
            
            let indexPath = self.tableView.indexPathForSelectedRow!
            detailRoomViewController.room = home.rooms[indexPath.row]
        }
    }
    
}
