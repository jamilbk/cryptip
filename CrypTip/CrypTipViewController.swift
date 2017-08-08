//
//  CrypTipViewController.swift
//  CrypTip
//
//  Created by jaboukhe on 8/6/17.
//  Copyright © 2017 Jamil Bou Kheir. All rights reserved.
//

import UIKit

class CrypTipViewController: UIViewController {

    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    @IBOutlet weak var partySize: UILabel!
    @IBOutlet weak var partySizeStepper: UIStepper!
    @IBOutlet weak var perPersonTotal: UILabel!
    @IBOutlet weak var QRImage: UIImageView!
    @IBOutlet weak var billSymbol: UILabel!
    
    static let tipPercentages = [0.15, 0.18, 0.2, 0.25]
    static let billDuration = 10.0 * 60 // 10 minutes
    
    func viewDidBecomeActive(_ sender: Any) {
        if recentlySwitched() {
            billField.text = UserDefaultsHelper.loadBill()
        } else {
            billField.text = nil
        }
        renderTip(self)
        renderQRCode(self)
    }
    
    func viewWillEnterBackground(_ sender: Any) {
        UserDefaultsHelper.setBill(bill: billField.text)
        UserDefaultsHelper.syncCurrentTime()
    }
    
    @IBAction func resetBill(_ sender: Any) {
        billField.text = nil
        loadDefaults()
        renderTip(self)
        renderQRCode(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Subscribe to the app became active notification
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewDidBecomeActive),
            name: NSNotification.Name.UIApplicationDidBecomeActive,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(viewWillEnterBackground),
            name: NSNotification.Name.UIApplicationWillResignActive,
            object: nil
        )
        
        if recentlySwitched() {
            billField.text = UserDefaultsHelper.loadBill()
            renderTip(self)
            renderQRCode(self)
        } else {
            loadDefaults()
        }
        
        billSymbol.text = NSLocale.autoupdatingCurrent.currencySymbol
        billField.becomeFirstResponder()
    }
    
    func loadDefaults() {
        // Load default tip percentage from UserDefaults
        let percentageDefaults = UserDefaultsHelper.loadTipPercentageDefault()
        let defaultPartySize = UserDefaultsHelper.loadDefaultPartySize()
        tipControl.selectedSegmentIndex = percentageDefaults.index
        partySize.text = String(defaultPartySize)
        partySizeStepper.value = Double(defaultPartySize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Re-render tip when arriving from Settings view, but don't reload the tip amount
        // like we did in viewDidLoad() since the user wouldn't expect this to to be reset to the default
        // if she had changed it previously.
        renderTip(self)
        renderQRCode(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Hide keyboard for things like going to the Settings view
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func partySizeChanged(_ sender: Any) {
        partySize.text = String(format: "%d", Int(partySizeStepper.value))
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }
    
    @IBAction func renderQRCode(_ sender: Any) {
        let btcAddress = UserDefaultsHelper.loadBitcoinReceiveAddress()
        if btcAddress.characters.count > 0 && ppTotal() > 0.00 {
            let btcURI = BitcoinURIGenerator.generateBitcoinURI(
                label: "CrypTip",
                amount: btcFromUSD(amount: ppTotal()),
                address: btcAddress
            )
            QRImage.image = QRCodeGenerator.qrCodeFromString(string: btcURI)
        } else {
            QRImage.image = nil
        }
    }
    
    @IBAction func renderTip(_ sender: Any) {
        tipLabel.text = "+\(formatter().string(from: tip() as NSNumber)!)"
        totalLabel.text = formatter().string(from: total() as NSNumber)
        perPersonTotal.text = formatter().string(from: ppTotal() as NSNumber)
    }

    func btcFromUSD(amount: Double) -> Double {
        return amount / 3300.00
    }
    
    func bill() -> Double {
        if let theBill = billField.text {
            return Double(theBill.floatValue)
        } else {
            return 0.0
        }
    }
    
    func tip() -> Double {
        return bill() * CrypTipViewController.tipPercentages[tipControl.selectedSegmentIndex]
    }
    
    func total() -> Double {
        return bill() + tip()
    }
    
    func ppTotal() -> Double {
        return total() / partySizeStepper.value
    }
    
    func recentlySwitched() -> Bool {
        if let synced = UserDefaultsHelper.loadSyncedTime() {
            let current = Date.init()
            let interval = current.timeIntervalSince(synced)
            return interval < CrypTipViewController.billDuration
        } else {
            return false
        }
    }
    
    func formatter() -> NumberFormatter {
        let f = NumberFormatter()
        f.numberStyle = .currency
        return f
    }
}

// There's seemingly a bug with decimalSeparator -- even if the phone's region is set to use a comma-supported
// decimalSeparator, number(from: String) still chokes the separator is set to "."
extension String {
    var floatValue: Float {
        let nf = NumberFormatter()
        nf.decimalSeparator = "."
        if let result = nf.number(from: self) {
            return result.floatValue
        } else {
            nf.decimalSeparator = ","
            if let result = nf.number(from: self) {
                return result.floatValue
            }
        }
        return 0
    }
}
