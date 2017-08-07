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
    
    static let tipPercentages = [0.15, 0.18, 0.2, 0.25]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load default tip percentage from UserDefaults
        let percentageDefaults = UserDefaultsHelper.loadTipPercentageDefault()
        let defaultPartySize = UserDefaultsHelper.loadDefaultPartySize()
        tipControl.selectedSegmentIndex = percentageDefaults.index
        partySize.text = String(defaultPartySize)
        partySizeStepper.value = Double(defaultPartySize)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Re-calculate tip when arriving from Settings view, but don't reload the tip amount
        // like we did in viewDidLoad() since the user wouldn't expect this to to be reset to the default
        // if she had changed it previously.
        calculateTip(self)
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
        let bill = Double(billField.text!) ?? 0
        let tip = bill * CrypTipViewController.tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        let ppTotal = total / partySizeStepper.value

        let btcAddress = UserDefaultsHelper.loadBitcoinReceiveAddress()
        if btcAddress.characters.count > 0 && ppTotal > 0.00 {
            let btcURI = BitcoinURIGenerator.generateBitcoinURI(
                label: "CrypTip",
                amount: btcFromUSD(amount: ppTotal),
                address: btcAddress
            )
            QRImage.image = QRCodeGenerator.qrCodeFromString(string: btcURI)
        } else {
            QRImage.image = nil
        }
    }
    
    @IBAction func calculateTip(_ sender: Any) {
        let bill = Double(billField.text!) ?? 0
        let tip = bill * CrypTipViewController.tipPercentages[tipControl.selectedSegmentIndex]
        let total = bill + tip
        let ppTotal = total / partySizeStepper.value
        
        tipLabel.text = String(format: "+$%.2f", tip)
        totalLabel.text = String(format: "$%.2f", total)
        perPersonTotal.text = String(format: "$%.2f", ppTotal)
    }

    func btcFromUSD(amount: Double) -> Double {
        return amount / 3300.00
    }
}
