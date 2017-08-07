//
//  BitcoinURIGenerator.swift
//  CrypTip
//
//  Created by jaboukhe on 8/6/17.
//  Copyright © 2017 Jamil Bou Kheir. All rights reserved.
//

import Foundation

class BitcoinURIGenerator {
    static func generateBitcoinURI(label: String, amount: Double, address: String) -> String {
        return String(format: "bitcoin:\(address)?amount=%.8f&label=\(label)", amount)
    }
}
