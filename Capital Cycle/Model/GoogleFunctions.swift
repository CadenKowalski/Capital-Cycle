//
//  GoogleFunctions.swift
//  Capital Cycle
//
//  Created by Caden Kowalski on 2/15/20.
//  Copyright © 2020 Caden Kowalski. All rights reserved.
//

import Foundation
import AuthenticationServices
import GoogleAPIClientForREST

class GoogleFunctions: NSObject {
    
    // MARK: Global Variables
    
    // Code global vars
    let service = GTLRSheetsService()
    let unsecureSpreadsheetID = "1alCW-eSX-lC6CUi0lbmNK7hpfkUhpOqhrbWZCBJgXuk"
    let secureSpreadhseetID = "1P6ruvsdZWGYGdUNajnIc3VqYLjuy9yNqQbpUIc-a1HM"
    var webAuthSession: ASWebAuthenticationSession?
    
    // MARK: Google Functions
    
    func unsecureFetchDataWithConnection() {
        service.apiKey = "AIzaSyBIdPHR_nqgL9G6fScmlcPMReBM5PmtVD8"
        let Query = GTLRSheetsQuery_SpreadsheetsValuesGet.query(withSpreadsheetId: unsecureSpreadsheetID, range: "Schedule Data!A2:M13")
        service.executeQuery(Query, delegate: self, didFinish: #selector(unsecureReturnData(Ticket:finishedWithObject:Error:)))
    }
    
    @objc func unsecureReturnData(Ticket: GTLRServiceTicket, finishedWithObject Result: GTLRSheets_ValueRange, Error: NSError?) {
        if Error == nil {
            guard let results = Result.values! as? [[String]] else {
                return
            }
            
            dailyData = Array(results[0...4])
            overviewData = Array(results[7...11])
            coreDataFunctions.updateContext(values: ["dailyData", "overviewData"], nil, nil)
        } else {
            print(Error!.localizedDescription)
        }
    }
    
    // Fetches an authorization code for the user if they allow access
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
    
    // Exchanges authorization code for access token that can be used to fetch private data
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
                self.secureFetchData(accessToken: accessToken, refreshToken: refreshToken) {_ in}
            } catch {
                print(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func secureFetchData(accessToken: String, refreshToken: String?, completion: @escaping(String?) -> Void) {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "sheets.googleapis.com"
        components.path = "/v4/spreadsheets/1P6ruvsdZWGYGdUNajnIc3VqYLjuy9yNqQbpUIc-a1HM/values/A2:E5"
        components.queryItems = [
            URLQueryItem(name: "access_token", value: accessToken)
        ]
        
        let fetchURL = components.url
        var request = URLRequest(url: fetchURL!)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!) as! [String: Any]
                if let values = jsonData["values"] as? [[Any]] {
                    let info = values as? [[String]]
                    self.updateContextValuesOnMainThread(refreshToken, info!)
                    completion(nil)
                }
            } catch let error as NSError {
                completion(error.localizedDescription)
            }
        })
        
        task.resume()
    }
    
    func refreshAccessToken(completion: @escaping(String?) -> Void) {
        coreDataFunctions.fetchData(contextValues: ["refresh_token"])
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
                    self.secureFetchData(accessToken: token, refreshToken: nil) { error in
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
    
    func fetchDataWithoutConnection() {
        coreDataFunctions.fetchData(contextValues: ["dailyData", "overviewData", "camperInfo"])
    }
    
    func updateContextValuesOnMainThread(_ refreshToken: String?, _ info: [[String]]) {
        DispatchQueue.main.async {
            coreDataFunctions.updateContext(values: ["refresh_token", "camperInfo"], refreshToken, info)
            coreDataFunctions.fetchData(contextValues: ["refresh_token", "camperInfo"])
        }
    }
}
