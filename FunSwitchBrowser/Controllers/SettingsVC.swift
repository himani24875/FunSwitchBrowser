//
//  SettingsVC.swift
//  FunSwitchBrowser
//
//  Created by Himani on 24/06/20.
//  Copyright © 2020 Himani. All rights reserved.
//

import UIKit

protocol SettingsVCDelegate {
    func blockerMode(is active: Bool)
}

class SettingsVC: UIViewController {
    
    @IBOutlet weak var blockerModeSwitch: UISwitch!
    @IBOutlet weak var timerModeSwitch: UISwitch!
    
    var delegate: SettingsVCDelegate!
    
    var isPreviousModeBlocker = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setState()
    }
    
    //MARK:- Custom Functions
    func setState() {
        self.blockerModeSwitch.isOn = isPreviousModeBlocker
        self.timerModeSwitch.isOn = !isPreviousModeBlocker
    }
    
    //MARK:- Button Actions
    @IBAction func onBlockerModeChanged(_ sender: Any) {
        self.timerModeSwitch.isOn = !self.blockerModeSwitch.isOn
        delegate.blockerMode(is: self.blockerModeSwitch.isOn)
    }
    
    @IBAction func onTimerModeChanged(_ sender: Any) {
        self.blockerModeSwitch.isOn = !self.timerModeSwitch.isOn
        delegate.blockerMode(is: self.blockerModeSwitch.isOn)
    }
    
}
