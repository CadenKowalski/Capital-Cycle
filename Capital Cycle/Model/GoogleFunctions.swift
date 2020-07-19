//
//  GoogleFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 2/15/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation
import AuthenticationServices

class GoogleFunctions: NSObject {
    
    // MARK: Global Variables
    
    // Code global vars
    let unsecureSpreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    let secureSpreadhseetID = "1P6ruvsdZWGYGdUNajnIc3VqYLjuy9yNqQbpUIc-a1HM"
    var webAuthSession: ASWebAuthenticationSession?
    
    // MARK: Google Functions
    
    // Fetches an authorization code if the user allows access
    func getAuthCode(context: ASWebAuthenticationPresentationContextProviding) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "accounts.google.com"
        components.path = "/o/oauth2/v2/auth"
        components.queryItems = [
            URLQueryItem(name: "scope", value: "https://www.googleapis.com/auth/spreadsheets.readonly"),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "redirect_uri", value: "com.googleusercontent.apps.242371580492-iv4vu3010s8cjpfhlrc8a0l2gq97h1mo:redirect_uri_path"),
            URLQueryItem(name: "client_id", value: "242371580492-iv4vu3010s8cjpfhlrc8a0l2gq97h1mo.apps.googleusercontent.com")
        ]
       
        let authURL = components.url
        let callbackUrlScheme = "com.cadenkowalski.Capital-Cycle"
        webAuthSession = ASWebAuthenticationSession.init(url: authURL!, callbackURLScheme: callbackUrlScheme, completionHandler: { (successURL: URL?, error: Error?) in
            if let successURLString = successURL?.absoluteString {
                let componentURL = URLComponents(string: successURLString)
                if error == nil {
                    let authToken = componentURL?.queryItems?.first(where: {$0.name == "code"})?.value
                    self.exchangeAuthCodeForAccessToken(authCode: authToken!)
                } else {
                    let errorMessage = componentURL?.queryItems?.first(where: {$0.name == "error"})?.value
                    print(errorMessage!)
                }
            }
        })
        
        webAuthSession?.presentationContextProvider = context
        webAuthSession?.start()
    }
    
    // Exchanges authorization code for access token which is used in private Google Sheet requests
    func exchangeAuthCodeForAccessToken(authCode: String) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth2.googleapis.com"
        components.path = "/token"
        components.queryItems = [
            URLQueryItem(name: "code", value: authCode),
            URLQueryItem(name: "client_id", value: "242371580492-iv4vu3010s8cjpfhlrc8a0l2gq97h1mo.apps.googleusercontent.com"),
            URLQueryItem(name: "redirect_uri", value: "com.googleusercontent.apps.242371580492-iv4vu3010s8cjpfhlrc8a0l2gq97h1mo:redirect_uri_path"),
            URLQueryItem(name: "grant_type", value: "authorization_code")
        ]
        
        let tokenURL = components.url
        var request = URLRequest(url: tokenURL!)
        request.httpMethod = "POST"
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                let accessToken = jsonData["access_token"] as! String
                let refreshToken = jsonData["refresh_token"] as! String
                self.updateCoreDataValuesOnMainThread(refreshToken, nil, nil, nil)
                self.fetchData(secure: true, accessToken: accessToken) {_ in}
            } catch {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // Uses access token to fetch private Google Sheet data
    func fetchData(secure: Bool, accessToken: String?, completion: @escaping(String?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sheets.googleapis.com"
        if secure {
            components.path = "/v4/spreadsheets/\(secureSpreadhseetID)/values/A2:F5"
            components.queryItems = [
                URLQueryItem(name: "access_token", value: accessToken)
            ]
        } else {
            components.path = "/v4/spreadsheets/\(unsecureSpreadsheetID)/values/A2:M13"
            components.queryItems = [
                URLQueryItem(name: "key", value: "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8")
            ]
        }
        
        let fetchURL = components.url
        let request = URLRequest(url: fetchURL!)
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if let values = jsonData["values"] as? [[Any]] {
                    let sheetData = values as? [[String]]
                    if secure {
                        user.isGoogleVerified = true
                        firebaseFunctions.manageUserData(dataValues: ["isGoogleVerified"], newUser: false) { error in
                            completion(error)
                        }
                        
                        self.updateCoreDataValuesOnMainThread(nil, nil, nil, sheetData!)
                        camperInfoPage?.updateData(nil)
                    } else {
                        self.updateCoreDataValuesOnMainThread(nil, Array(sheetData![0...4]), Array(sheetData![7...11]), nil)
                    }
                    
                    completion(nil)
                }
            } catch let error as NSError {
                completion(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // Refreshes an access token via the refresh token generated in exchangeAuthCodeForAccesstoken(authCode:)
    func refreshAccessToken(completion: @escaping(String?) -> Void) {
        DispatchQueue.main.async {
            coreDataFunctions.fetchData(contextValues: ["refresh_token"])
        }
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth2.googleapis.com"
        components.path = "/token"
        components.queryItems = [
            URLQueryItem(name: "refresh_token", value: refresh_token),
            URLQueryItem(name: "client_id", value: "242371580492-iv4vu3010s8cjpfhlrc8a0l2gq97h1mo.apps.googleusercontent.com"),
            URLQueryItem(name: "grant_type", value: "refresh_token")
        ]
        
        let refreshURL = components.url
        var request = URLRequest(url: refreshURL!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if let token = jsonData["access_token"] as? String {
                    self.fetchData(secure: true, accessToken: token) { error in
                        if error == nil {
                            completion(nil)
                        } else {
                            completion(error)
                        }
                    }
                }
            } catch let error as NSError {
                completion(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // Revokes a token
    func revokeToken(completion: @escaping(String?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "oauth2.googleapis.com"
        components.path = "/revoke"
        components.queryItems = [
            URLQueryItem(name: "token", value: refresh_token),
        ]
        
        let revokeURL = components.url
        var request = URLRequest(url: revokeURL!)
        request.httpMethod = "POST"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if error == nil {
                completion(nil)
                firebaseFunctions.manageUserData(dataValues: ["isGoogleVerified"], newUser: false) { success in
                    coreDataFunctions.updateContext(values: ["refresh_token", "camperInfo"], "", nil, nil, [[""]])
                }
            } else {
                completion(error?.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    // Fetches data from core data if there is no internet or cellular connection
    func fetchDataWithoutConnection() {
        coreDataFunctions.fetchData(contextValues: ["dailyData", "overviewData", "camperInfo"])
    }
    
    // Updates core data values since requests must be performed on the main thread
    func updateCoreDataValuesOnMainThread(_ refreshToken: String?, _ dailyData: [[String]]?, _ overviewData: [[String]]?, _ info: [[String]]?) {
        DispatchQueue.main.async {
            coreDataFunctions.updateContext(values: ["refresh_token", "dailyData", "overviewData", "camperInfo"], refreshToken, dailyData, overviewData, info)
            coreDataFunctions.fetchData(contextValues: ["refresh_token", "dailyData", "overviewData", "camperInfo"])
        }
    }
}
