//
//  QRCodeGenerator.swift
//  CrypTip
//
//  Created by jaboukhe on 8/6/17.
//  Copyright © 2017 Jamil Bou Kheir. All rights reserved.
//

import Foundation
import UIKit
import CoreImage

class QRCodeGenerator {
    static func qrCodeFromString(string: String) -> UIImage? {
        let stringData = string.data(using: String.Encoding.utf8)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(stringData, forKey: "inputMessage")
            filter.setValue("H", forKey: "inputCorrectionLevel")
            let transform = CGAffineTransform(scaleX: 100, y: 100)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
}

