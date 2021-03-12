//
//  Connect.swift
//  Epicture
//
//  Created by Jeremy Naccache on 25/10/2020.
//

import Foundation
import AuthenticationServices
import SwiftUI
import OAuthSwift
import SafariServices
import Alamofire
import SwiftyJSON

typealias ASPresentationAnchor = UIWindow
class SignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    var globalvars: GlobalVars
    init(globalvars: GlobalVars){
        self.globalvars = globalvars
    }
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func signIn() {
        if let authUrl = URL(string: userVars.url + "/oauth2/authorize?response_type=token&client_id=" + client_id){
                print("hello", authUrl)
                let authSession = ASWebAuthenticationSession(
                    url: authUrl, callbackURLScheme: "Epicture://imgur.com/") { (url, error) in
                    print("hello")
                    if let error = error {
                        print("error", error)
                    } else if let url = url {
                        self.globalvars.connect()
                        connected = true
                        self.processUrl(url: url)
                        self.getAvatar()
                        }
                    else{
                        print("error")
                    }
                }
                authSession.presentationContextProvider = self
                authSession.prefersEphemeralWebBrowserSession = true
                authSession.start()
            }
    }
    func processUrl(url: URL)
    {
        let url2 = url.absoluteString.components(separatedBy: "imgur.com/#")
        let urlcomp = url2[1]
        for i in urlcomp.components(separatedBy: "&"){
            let query = i.components(separatedBy: "=")
            processQuery(query: query)
        }
    }
    func processQuery(query: [String])
    {
        var def = 0
        switch query[0]{
        case "access_token":
            userVars.token = query[1]
            userVars.headerUser.add(name: "Authorization", value: "Bearer " + userVars.token)
            print(userVars.token)
        case "refresh_token":
            userVars.refresh_token = query[1]
        case "account_id":
            userVars.id = query[1]
        case "account_username":
           globalvars.changeName(name: query[1])
        default:
            if def == 0 {
                def = 1
            }
        }
    }
    
    func getAvatar(){
        AF.request(userVars.url + "/3/account/me/avatar", encoding: JSONEncoding.default, headers: userVars.headerUser).responseJSON {
            response in
            print(response)
            if response.error != nil{
                return
            }
            if let json = try? JSON(data: response.data!) {
                print(json["data"]["avatar"].string!.components(separatedBy: "?")[0])
                if let url = URL(string: json["data"]["avatar"].string!.components(separatedBy: "?")[0]){
                    self.globalvars.changeAvatar(url: url)
                }
            }
        }
    }
}
