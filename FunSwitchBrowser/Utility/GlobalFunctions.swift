//
//  GlobalFunctions.swift
//  FunSwitchBrowser
//
//  Created by Himani on 25/06/20.
//  Copyright © 2020 Himani. All rights reserved.
//

import Foundation

struct GlobalFunctions {
    static let sharedManager = GlobalFunctions()
    
    private init() {
    }
    
    func getTimeInHours(time: Int) -> String {
        let hours = time / 3600
        let minutes = time / 60 % 60
        let seconds = time % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    
    func getURL(_ urlString:String) -> URLRequest {
        
        var urlComponents = URLComponents(string: urlString)
        urlComponents?.scheme = "https"
        
        guard let url = urlComponents?.url else {
            preconditionFailure("Failed to construct URL")
        }
        
        return URLRequest(url: url, cachePolicy: .reloadRevalidatingCacheData, timeoutInterval: 100)
    }
}
