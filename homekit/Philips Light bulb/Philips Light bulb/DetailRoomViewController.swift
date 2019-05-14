//
//  DetailRoomViewController.swift
//  Philips Light bulb
//
//  Created by Going-jobs on 8/9/16.
//  Copyright © 2016 WilliamXie. All rights reserved.
//

import UIKit
import HomeKit
let accessoryName = "Light"

class DetailRoomViewController: UIViewController, HMAccessoryBrowserDelegate {
    
    var home: HMHome!
    var room: HMRoom!
    var lightAccessory: HMAccessory!
    var accessoryBrowser = HMAccessoryBrowser()
    
    var brightnessCharacteristic: HMCharacteristic!
    var powerStateCharacteristic: HMCharacteristic!
    
    @IBOutlet weak var powerSwitch: UISwitch!
    @IBOutlet weak var brightnessSilder: UISlider!
    @IBOutlet weak var brightnessValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.accessoryBrowser.delegate = self
        self.findAccessory()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.accessoryBrowser.stopSearchingForNewAccessories()
    }
    
    func findAccessory(){
        
            for accessory in room.accessories {
                if accessory.name == accessoryName {
                    self.lightAccessory = accessory
                }
            }
        
        // 开始查找配件
        if self.lightAccessory == nil {
            self.accessoryBrowser.startSearchingForNewAccessories()
        } else {
            self.findServicesForAccessory(self.lightAccessory)
        }
        
    }
    //MARK: --实现HMAccessoryBrowserDelegate协议
    func accessoryBrowser(_ browser: HMAccessoryBrowser, didFindNewAccessory accessory: HMAccessory) {
        NSLog("发现配件...")
        
        if accessory.name == accessoryName {
            self.home.addAccessory(accessory, completionHandler: { [weak self] (error) -> Void in
                
                if error != nil {
                    NSLog("安装配件失败。")
                } else {
                    self!.home.assignAccessory(accessory, to: self!.room, completionHandler: { (error) -> Void in
                        self!.findServicesForAccessory(accessory)
                    })
                }
                
                })
        }
    }
    
    
    func findServicesForAccessory(_ accessory: HMAccessory){
        NSLog("查找配件的服务...")
        for service in accessory.services {
            NSLog(" 服务名 = \(service.name)")
            NSLog(" 服务类型 = \(service.serviceType)")
            
            NSLog(" 查找服务中的特征...")
            findCharacteristicsOfService(service)
        }
    }
    
    func findCharacteristicsOfService(_ service: HMService){
        for characteristic in service.characteristics {
            NSLog("   特征类型 = \(characteristic.characteristicType)")
            
            if characteristic.characteristicType == HMCharacteristicTypeBrightness{
                brightnessCharacteristic = characteristic
                brightnessCharacteristic.readValue(completionHandler: { [weak self] (error) -> Void in
                    if error != nil {
                        print(error)
                    } else  {
                        let oldValue = self!.brightnessCharacteristic.value as! Float
                        NSLog("oldValue : \(oldValue)")
                        self!.brightnessSilder.value = oldValue
                        self!.brightnessValue.text = String(format: "%0.0f", oldValue)
                    }
                    })
                
            } else if characteristic.characteristicType == HMCharacteristicTypePowerState {
                powerStateCharacteristic = characteristic
                powerStateCharacteristic.readValue(completionHandler: { [weak self] (error) -> Void in
                    if error != nil {
                        print(error)
                    } else  {
                        let oldValue = self!.powerStateCharacteristic.value as! Bool
                        NSLog("oldValue : \(oldValue)")
                        self!.powerSwitch.setOn(oldValue, animated: true)
                    }
                    })
            }
        }
    }
    
    
    @IBAction func switchValueChanged(_ sender: AnyObject) {
        let newValue = self.powerSwitch.isOn
        self.powerStateCharacteristic.writeValue(newValue, completionHandler: {(error) -> Void in
            if error != nil {
                print("Power状态写入失败: \(error)")
            }
        })
    }
    
    @IBAction func silderValueChanged(_ sender: AnyObject) {
        let newValue = self.brightnessSilder.value
        self.brightnessCharacteristic.writeValue(newValue, completionHandler: {(error) -> Void in
            if error != nil {
                print("亮度写入失败:\(error)")
            }
        })
        self.brightnessValue.text = String(format: "%0.0f", newValue)
    }
    
}
