//
//  AddRoomViewController.swift
//  Philips Light bulb
//
//  Created by Going-jobs on 8/9/16.
//  Copyright © 2016 WilliamXie. All rights reserved.
//

import UIKit
import HomeKit
class AddRoomViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var home: HMHome!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func save(_ sender: AnyObject) {
        home.addRoom(withName: textField.text!, completionHandler: { (room, error) -> Void in
            if error != nil {
                print(error)
            } else  {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
