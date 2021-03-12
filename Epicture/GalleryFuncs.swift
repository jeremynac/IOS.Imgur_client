//
//  Images.swift
//  Epicture
//
//  Created by Jeremy Naccache on 25/10/2020.
//

import Foundation
import Foundation
import Alamofire
import SwiftyJSON
import AuthenticationServices
import SwiftUI
import KingfisherSwiftUI
import OAuthSwift
import SafariServices
/*
func processJson(json: JSON)->[URL]
{
    /*
    print("         hello")
    //print(json["data"].count)
    var images = [URL]()
    for i in 0...json["data"].count {
        for image in json["data"][i]["images"]{
            if let url = URL(string: (json["data"][i]["images"].t).1["link"].stringValue) {
                if (url.pathExtension == "jpeg" || url.pathExtension == "png" || url.pathExtension == "gif"){
                    images.append(url)
                }
            }
        }
    }
    //print(images.count)
    return images
 */
}
 */

func Search(page: Int, search: String, sort: String, window: String, completion: @escaping (JSON?, Bool)->Void)
{
    AF.request(userVars.url + "/3/gallery/search/" + sort + "/" + window + "/" + String(page) + "?q=" + search, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        print(response)
        if response.error != nil{
            completion(nil, true)
        }
        if let data = response.data {
            if let json = try? JSON(data: data) {
                completion(json, false)        }
        }
    }
}

func Gallery(page: Int, section: String, sort: String, window: String, viral: Bool, mature: Bool, completion: @escaping(JSON?,  Bool)->Void)
{
    let url: String = userVars.url + "/3/gallery/" + section + "/" + sort + "/" + window + "/" + String(page) + "?showViral="  + String(viral) + "&mature=" + String(mature) + "&album_previews=false"
    AF.request(url, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        if response.error != nil{
            completion(nil, true)
        }
        print(url)
        if let json = try? JSON(data: response.data!) {
            //let images = processJson(json: json)
            print("    hello")
            completion(json, false)        }
    }
}

func UserImages(page: Int, completion: @escaping(JSON?, Bool)->Void)
{
    print("go")
    if (connected){
        AF.request(userVars.url + "/3/account/me/images", encoding: JSONEncoding.default, headers: userVars.headerUser).responseJSON {
            response in
            if response.error != nil{
                completion(nil, true)
            }
            if let json = try? JSON(data: response.data!) {
                //let images = processJson(json: json)
                completion(json, false)            }
        }
    }
    else{
        print("not connected")
    }
}

func Favorite(page: Int, sort: String, completion: @escaping(JSON?, Bool)->Void)
{
    if (connected){
        AF.request(userVars.url + "/3/account/me/gallery_favorites/" + String(page) + "/" + sort, encoding: JSONEncoding.default, headers: userVars.headerUser).responseJSON {
            response in
            if response.error != nil{
                completion(nil, true)
            }
            if let json = try? JSON(data: response.data!) {
                //let images = processJson(json: json)
                completion(json, false)
            }
        }
    }
    else{
        print("not connected")
    }
}

func sendFavorite(imageid: String, completion: @escaping (Bool)->Void)
{
    if (connected){
        AF.request(userVars.url + "/3/image/" + imageid + "/favorite", method: .post, headers: userVars.headerUser).response {
            response in
            print(response)
            if response.error != nil{
                completion(true)
            }
            else{
                completion(false)
            }
        }
    }
    else{
        print("not connected")
    }
}

func getJsonValueD(json: JSON, key: String) -> Double{
    if let d = json[key].double{
        return d
    }
    return 0.0
}

func getJsonValueInt(json: JSON, key: String) -> Int{
    if let nb = json[key].int{
        return nb
    }
    return 0
}

func getJsonValueStr(json: JSON, key: String) -> String{
    if let str = json[key].string{
        return str
    }
    return ""
}

func getJsonValueBool(json: JSON, key: String) -> Bool{
    if let  val = json[key].bool{
        return val
    }
    return false
}

func parseUrlAlbum(json: JSON) -> URL? {
    if let url = json["link"].url{
        return url
    }
    return nil
}

func parseUrlGallery(json: (String, JSON)) -> URL? {
    if let url = json.1["link"].url{
        return url
    }
    return nil
}
