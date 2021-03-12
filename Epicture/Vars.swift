//
//  Vars.swift#imageLiteral(resourceName: "spinner.gif")
//  Epicture
//
//  Created by Jeremy Naccache on 25/10/2020.
//

import Foundation
import Alamofire
import SwiftUI

let client_id: String = "327002fcc1bf0ad"
let client_secret: String = "37e6597f5bc6b9b208cf05e0e61a71cb1716f08a"
var connected = false
let loadingim: URL? = URL(string: "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png")
let exts = ["jpeg", "jpg", "png", "mp4"]
let flow = 5
let flow2 = 5
let sorts = ["hot", "new", "top"]
let unixtime: [Double] = [86400, 604800, 2592000, 31536000]

class GlobalVars: ObservableObject {
    @Published var username: String = ""
    @Published var id: String = ""
    @Published var avatar = URL(string: "https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-icon-eps-file-easy-to-edit-default-avatar-photo-placeholder-profile-icon-124557887.jpg")
    @Published var connected: Bool = false
    func connect() {
        connected = true
    }
    func changeName(name: String){
        username = name
    }
    func changeId(id: String){
        self.id = id
    }
    func changeAvatar(url: URL){
        avatar = url
    }

}

struct userVars{
    static let url: String = "https://api.imgur.com"
    static var token: String = ""
    static var refresh_token: String = ""
    static var username: String = ""
    static var id: String = ""
    static var headers: HTTPHeaders{[
        "Authorization": "Client-ID " + client_id
    ]}
    static var headerUser = HTTPHeaders()
    static var avatar = URL(string: "https://thumbs.dreamstime.com/b/default-avatar-photo-placeholder-profile-icon-eps-file-easy-to-edit-default-avatar-photo-placeholder-profile-icon-124557887.jpg")
}
