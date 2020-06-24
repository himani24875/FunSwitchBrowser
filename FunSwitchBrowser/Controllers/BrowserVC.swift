//
//  BrowserVC.swift
//  FunSwitchBrowser
//
//  Created by Himani on 24/06/20.
//  Copyright © 2020 Himani. All rights reserved.
//

import UIKit
import WebKit

class BrowserVC: UIViewController {
    var webView: WKWebView!
    let blockerUrl = "youtube.com"
    var urlString: String!
    var isBlockerModeActive = true
    
    var indicator = UIActivityIndicatorView(style: .medium)
    var timer: Timer?
    var timeElapsed = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeWebView()
        self.showLoader()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        if timer != nil { self.timer?.invalidate() }
    }
    
    //MARK:- Custom Functions
    func initializeWebView() {
        self.webView = WKWebView(frame: self.view.frame)
        self.webView.navigationDelegate = self
        self.view.addSubview(webView)
        self.webView.allowsBackForwardNavigationGestures = true
        self.loadUrl()
    }
    
    func loadUrl() {
        if let searchText = self.urlString {
            let request = getURL(searchText)
            self.webView.load(request)
        }
    }
    
    func getURL(_ urlString:String) -> URLRequest {
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.scheme = "https"
        
        guard let url = urlComponents?.url else {
            preconditionFailure("Failed to construct URL")
        }
        
        return URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 100)
    }
    
    func loadBlockerVC() {
        let blockerVC = (self.storyboard?.instantiateViewController(identifier: "BlockerVC") ?? UIViewController())
        blockerVC.providesPresentationContextTransitionStyle = true
        blockerVC.modalPresentationStyle = .overCurrentContext
        self.navigationController?.pushViewController(blockerVC, animated: true)
    }

}

//MARK:- WKNavigationDelegate
extension BrowserVC: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        
        let alert = UIAlertController(title: "", message: error.localizedDescription, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default) {
            (action) in
            self.navigationController?.popViewController(animated: true)
        }
        
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.showLoader()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.hideLoader()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let host = navigationAction.request.mainDocumentURL?.host {
            if host.contains(blockerUrl) {
                if isBlockerModeActive {
                    decisionHandler(.cancel)
                    self.loadBlockerVC()
                    if timer != nil { self.timer?.invalidate() }
                } else {
                    if timer == nil {
                        self.launchTimer()
                    }
                    decisionHandler(.allow)
                }
            } else {
                decisionHandler(.allow)
                if timer != nil { self.timer?.invalidate() }
            }
            
        } else {
            decisionHandler(.allow)
            if timer != nil { self.timer?.invalidate() }
        }
    }
    
}

//MARK:- Loader Functions
extension BrowserVC {
    func showLoader() {
        self.indicator.frame = self.webView.frame
        self.indicator.center = self.webView.center
        self.webView.addSubview(self.indicator)
        self.indicator.startAnimating()
    }
    
    func hideLoader() {
        self.indicator.stopAnimating()
        self.indicator.removeFromSuperview()
    }
}

//MARK:- Notification Functions
extension BrowserVC {
    func sendNotification(timeElapsed: Int) {
        let notifId = "notification.id.01"
        
        let center = UNUserNotificationCenter.current()
        center.removeDeliveredNotifications(withIdentifiers: [notifId])
        center.removePendingNotificationRequests(withIdentifiers: [notifId])
        
        let content = UNMutableNotificationContent()
        content.title = "Currently in Timer Mode"
        content.body = "Browsing youtube for \(timeElapsed) seconds"
        content.userInfo = ["custom-payload-id":"notification.id.01"]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.001, repeats: false)
        let request = UNNotificationRequest(identifier: notifId, content: content, trigger: trigger)
        
        center.add(request)
        //        {
        //            (error) in
        //            guard error == nil else { return }
        //            print("Notification scheduled! --- ID = \(request.content.body)")
        //            self.updateNotification()
        //        }
    }
    
}

//MARK:- Timer Functions
extension BrowserVC {
    
    @objc func fireTimer() {
        timeElapsed += 1
        print("timeElapsed", timeElapsed)
        sendNotification(timeElapsed: timeElapsed)
    }
    
    func launchTimer() {
        if timer != nil { self.timer?.invalidate() }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        
    }
}
