//
//  Upload.swift
//  Epicture
//
//  Created by Jeremy Naccache on 27/10/2020.
//

import Foundation
import Alamofire

func Upload(picture: Data, filename: String, completion: @escaping ()->Bool)
{
    //let im = UUImageJPEGRepresentation(picture)
    if let url2: URL = URL(string: userVars.url + "/3/upload"){
        AF.upload(multipartFormData: {multiparFormData in multiparFormData.append(picture, withName: "photo", fileName: filename, mimeType: "photo/jpeg")}, to: url2, headers: userVars.headers) .response {
            response in
            print (response)
        }
    }
}
