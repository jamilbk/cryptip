//
//  SettingsViewController.swift
//  CrypTip
//
//  Created by jaboukhe on 8/6/17.
//  Copyright © 2017 Jamil Bou Kheir. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var defaultTipControl: UISegmentedControl!
    @IBOutlet weak var bitcoinAddressField: UITextField!
    @IBOutlet weak var defaultPartySizeField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaultsHelper.loadTipPercentageDefault()
        defaultTipControl.selectedSegmentIndex = defaults.index
        bitcoinAddressField.text = UserDefaultsHelper.loadBitcoinReceiveAddress()
        defaultPartySizeField.text = String(UserDefaultsHelper.loadDefaultPartySize())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Ensure settings are saved if user hits Back without dismissing Keyboard
        syncSettings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultTipChanged(_ sender: Any) {
        let tipPercentages = [0.15, 0.18, 0.2, 0.25]
        let index = defaultTipControl.selectedSegmentIndex
        let defaultTipPercentage = tipPercentages[index]
        
        UserDefaultsHelper.setTipPercentageDefault(percentage: defaultTipPercentage, index: index)
    }
    
    @IBAction func defaultPartySizeChanged(_ sender: Any) {
        let partySize = Int(defaultPartySizeField.text!) ?? 2
        UserDefaultsHelper.setDefaultPartySize(partySize: partySize)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func bitcoinAddressChanged(_ sender: Any) {
        let address = bitcoinAddressField.text
        UserDefaultsHelper.setBitcoinReceiveAddress(address: address)
    }
    
    func syncSettings() {
        defaultTipChanged(self)
        defaultPartySizeChanged(self)
        bitcoinAddressChanged(self)
    }
}
