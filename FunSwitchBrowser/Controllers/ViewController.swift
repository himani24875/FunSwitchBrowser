//
//  ViewController.swift
//  FunSwitchBrowser
//
//  Created by Himani on 24/06/20.
//  Copyright © 2020 Himani. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    
    var isBlockerModeActive = true
    
    @IBOutlet weak var searchTxtField: UITextField!
    @IBOutlet weak var searchBtn: UIButton!
    @IBOutlet weak var settingsButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.searchTxtField.delegate = self
        self.searchBtn.isEnabled = false
    }
    
    //MARK:- Custom Functions

    func loadBlockerVC() {
        let blockerVC = (self.storyboard?.instantiateViewController(identifier: ConstantManager.VC_IDENTIFIER.BLOCKER_VC) ?? UIViewController())
        blockerVC.providesPresentationContextTransitionStyle = true
        blockerVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(blockerVC, animated: true)
    }
    
    func loadBrowserVC(urlString: String) {
        let browserVC = (self.storyboard?.instantiateViewController(identifier: ConstantManager.VC_IDENTIFIER.BROWSER_VC) ?? UIViewController()) as BrowserVC
        browserVC.providesPresentationContextTransitionStyle = true
        browserVC.modalPresentationStyle = .overCurrentContext
        browserVC.urlString = urlString
        browserVC.isBlockerModeActive = self.isBlockerModeActive
        self.navigationController?.pushViewController(browserVC, animated: true)
    }
    
    func loadSettingsVC() {
        let settingsVC = (self.storyboard?.instantiateViewController(identifier: ConstantManager.VC_IDENTIFIER.SETTING_VC) ?? UIViewController()) as SettingsVC
        settingsVC.delegate = self
        settingsVC.providesPresentationContextTransitionStyle = true
        settingsVC.modalPresentationStyle = .fullScreen
        settingsVC.isPreviousModeBlocker = isBlockerModeActive
        self.navigationController?.pushViewController(settingsVC, animated: true)
    }
    
    //MARK:- Button Actions
    @IBAction func nSearchBtnClicked(_ sender: UIButton) {
        if let searchText = self.searchTxtField.text {
            if searchText.lowercased().contains(ConstantManager.BLOCKER_URL), isBlockerModeActive {
                self.loadBlockerVC()
            } else {
                self.loadBrowserVC(urlString: searchText)
            }
        }
    }
    
    @IBAction func onSettingsButtonClicked(_ sender: Any) {
        self.loadSettingsVC()
    }
}


//MARK:- UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if let count = textField.text?.count, count == 0 {
            self.searchBtn.isEnabled = false
        } else {
            self.searchBtn.isEnabled = true
        }
    }
}

//MARK:- SettingsVCDelegate
extension ViewController: SettingsVCDelegate {
    func blockerMode(is active: Bool) {
        self.isBlockerModeActive = active
    }
}
