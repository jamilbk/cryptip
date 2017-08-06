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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let defaults = UserDefaultsHelper.loadTipPercentageDefault()
        defaultTipControl.selectedSegmentIndex = defaults.index
        bitcoinAddressField.text = UserDefaultsHelper.loadBitcoinReceiveAddress()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func defaultTipChanged(_ sender: Any) {
        let tipPercentages = [0.18, 0.2, 0.25]
        let index = defaultTipControl.selectedSegmentIndex
        let defaultTipPercentage = tipPercentages[index]
        
        UserDefaultsHelper.setTipPercentageDefault(percentage: defaultTipPercentage, index: index)
    }
    
    @IBAction func onTap(_ sender: Any) {
        view.endEditing(true)
    }

    @IBAction func bitcoinAddressChanged(_ sender: Any) {
        let address = bitcoinAddressField.text
        UserDefaultsHelper.setBitcoinReceiveAddress(address: address)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
