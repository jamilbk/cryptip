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
        defaults().set(percentage, forKey: "default_tip_percentage")
        defaults().set(index, forKey: "default_tip_index")
        defaults().synchronize()
    }
    
    static func loadTipPercentageDefault() -> (percentage: Double, index: Int) {
        var percentage = defaults().double(forKey: "default_tip_percentage")
        var index = defaults().integer(forKey: "default_tip_index")
        
        // 0.0 is returned if key does not exist (nil cast to Double?)
        if percentage == 0.0 {
            percentage = 0.18
            index = 0
        }
        
        return (percentage: percentage, index: index)
    }
    
    static func setBitcoinReceiveAddress(address: String?) {
        defaults().set(address, forKey: "bitcoin_receive_address")
        defaults().synchronize()
    }
    
    static func loadBitcoinReceiveAddress() -> String {
        let address = defaults().string(forKey: "bitcoin_receive_address") ?? ""
        
        return address
    }
    
    static func setDefaultPartySize(partySize: Int) {
        let sanitizedPartySize = partySize <= 0 ? 2 : partySize
        defaults().set(sanitizedPartySize, forKey: "default_party_size")
        defaults().synchronize()
    }
    
    static func setBill(bill: String?) {
        defaults().set(bill, forKey: "bill")
    }
    
    static func loadBill() -> String? {
        return defaults().string(forKey: "bill")
    }

    static func loadDefaultPartySize() -> Int {
        let partySize = defaults().integer(forKey: "default_party_size")
        
        return partySize <= 0 ? 2 : partySize
    }
    
    static func defaults() -> UserDefaults {
        return UserDefaults.standard
    }
    
    static func syncCurrentTime() {
        let current = Date.init()
        print("syncing current time \(current)")
        defaults().set(current, forKey: "synced_time")
    }
    
    static func loadSyncedTime() -> Date? {
        let synced = defaults().object(forKey: "synced_time") as! Date?
        return synced
    }
}
