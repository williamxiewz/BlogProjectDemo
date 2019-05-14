//
//  AddHomeViewController.swift
//  Philips Light bulb
//
//  Created by Going-jobs on 8/9/16.
//  Copyright © 2016 WilliamXie. All rights reserved.
//

import UIKit
import HomeKit
class AddHomeViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    var homeManager : HMHomeManager!
    var home: HMHome!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        textField.becomeFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save(_ sender: AnyObject) {
        //添加home
        homeManager.addHome(withName: textField.text!, completionHandler: {(home, error) -> Void in
            
            if error != nil{
                print(error)
            }else {
                self.dismiss(animated: true, completion: nil)
            }
            
    
        })
    }
    
    @IBAction func cancel(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
        
    }

}



