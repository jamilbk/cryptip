//
//  UserDefaultsHelper.swift
//  CrypTip
//
//  Created by jamil on 8/6/17.
//  Copyright © 2017 Jamil Bou Kheir. All rights reserved.
//

import Foundation

class UserDefaultsHelper {
    static func setTipPercentageDefault(percentage: Double, index: Int) {
        let defaults = UserDefaults.standard // Swift 3 syntax, previously NSUserDefaults.standardUserDefaults()
        defaults.set(percentage, forKey: "default_tip_percentage")
        defaults.set(index, forKey: "default_tip_index")
        defaults.synchronize()
    }
    
    static func loadTipPercentageDefault() -> (percentage: Double, index: Int) {
        let defaults = UserDefaults.standard
        var percentage = defaults.double(forKey: "default_tip_percentage")
        var index = defaults.integer(forKey: "default_tip_index")
        
        // 0.0 is returned if key does not exist (nil cast to Double?)
        if percentage == 0.0 {
            percentage = 0.18
            index = 0
        }
        
        return (percentage: percentage, index: index)
    }
    
    static func setBitcoinReceiveAddress(address: String?) {
        let defaults = UserDefaults.standard
        defaults.set(address, forKey: "bitcoin_receive_address")
        defaults.synchronize()
    }
    
    static func loadBitcoinReceiveAddress() -> String {
        let defaults = UserDefaults.standard
        let address = defaults.string(forKey: "bitcoin_receive_address") ?? ""
        print(address)
        return address
    }
}
