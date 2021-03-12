//
//  Gallery.swift
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

struct im: Hashable{
    var url: URL? = loadingim
    var ups: Int = 0
    var downs: Int = 0
    var views: Int = 0
    var author: String = "Unknown"
    var title: String = "Picture"
    var description: String = ""
    var votes: Int = 0
    var time: Double = 0
    var imageid: String = ""
    var fav: Bool = false
}

struct GalleryV : View
{
    @State private var gallery: [im] = [im]()//repeating: URL(string: loadingim)!, count: 100)
    @State private var displayed: [im] = [im]()
    @State private var page: Int = 0
    @State private var load: Int = 0
    @State private var error: Bool = false
    private var type: Int = 0
    @State private var jsonfinished: Bool = true
    @State private var jsonloader: Int = 0
    @State private var jsonbuffer: JSON?
    @State private var sort: String = "top"
    @State private var window: String = "month"
    @State private var section: String = "top"
    @State private var sort2: String = "newest"
    @State private var viral: Bool = true
    @State private var mature: Bool = false
    @Binding private var search: String
    @State private var loading: Bool = false
    @State private var loaded: Bool = true
    @State private var showFullScreen: Bool = false
    @State private var fullscreenimage: im?
    @State private var maxloads: Int = 0
    @EnvironmentObject var globalvars: GlobalVars
    @State private var finished: Bool = false
    @State private var endpage: Bool = false
    @State private var sorttype: Int = 2
    private var dates: [Double]?
    @State private var date: Int = 2
    init(type: String = "", sort: String = "viral", window: String = "day", section: String = "hot", sort2: String = "newest", search: Binding<String> = .constant(""), mature: Bool = false, viral: Bool = true)
    {
        let time = NSDate().timeIntervalSince1970
        self.dates = [time - 86400, time - 604800, time - 2592000, time - 31536000]
        switch type{
        case "search":
            self.type = 0
        case "gallery":
            self.type = 1
        case "favorite":
            self.type = 2
        case "user":
            self.type = 3
        default:
            self.type = 1
        }
        self._search = search
    }
    
    func filter(sort: String? = nil, window: String? = nil, section: String? = nil, sort2: String? = nil, search: String? = nil, mature: Bool? = nil, viral: Bool? = nil){
        self.sort = sort ?? self.sort
        self.window = window ?? self.window
        self.section = section ?? self.section
        self.sort2 = sort2 ?? self.sort2
        self.search = search ?? self.search
        self.mature = mature ?? self.mature
        self.viral = viral ?? self.viral
    }
    
    func searchQuery(search: String)
    {
        self.search = search
        self.reset()
    }
    
    func loadJsonAlbum(max1: Int) -> [im] {
        var gallery2 = [im]()
        for i in jsonloader..<min(jsonloader + flow, max1) {
            //print("   ", jsonbuffer!["data"] == nil)
            if jsonbuffer!["data"][i].exists() {
                let  data: JSON  = jsonbuffer!["data"][i]
                if jsonbuffer != nil {
                    let ups: Int = getJsonValueInt(json: data, key: "ups")
                    let downs: Int = getJsonValueInt(json: data, key: "downs")
                    let views: Int = getJsonValueInt(json: data, key: "views")
                    let author: String  = getJsonValueStr(json: data, key: "account_url")
                    let title: String = getJsonValueStr(json: data, key: "title")
                    let description: String = getJsonValueStr(json: data, key: "description")
                    let time: Double = getJsonValueD(json: data, key: "datetime")
                    let imageid: String = getJsonValueStr(json: data, key: "id")
                    let fav: Bool = getJsonValueBool(json: data, key: "favorite")
                    let votes: Int = ups - downs
                    var url: URL?
                    print("user", self.type)
                    if self.type == 3 {
                        url = parseUrlAlbum(json: data)
                    }
                    if url != nil{
                        let ext = url!.pathExtension
                        if (exts.contains(ext)){
                            let entry = im(url: url, ups: ups, downs: downs, views: views, author: author, title: title, description: description, votes: votes, time: time, imageid: imageid, fav: fav)
                            gallery2.append(entry)
                        }
                    }
                }
            }
        }
        return gallery2
    }
    
    func loadJsonGallery(max1: Int) -> [im] {
        var gallery2 = [im]()
        let jsontemp = jsonbuffer
        for i in jsonloader..<min(jsonloader + flow, max1) {
            //print("   ", jsonbuffer!["data"] == nil)
            if jsontemp != nil{
                if !(jsontemp!["data"].exists()){
                    continue
                }
                if jsontemp!["data"][i].exists() {
                    let  data: JSON  = jsontemp!["data"][i]
                    if data["images"].exists(){
                        let ims: JSON = data["images"]
                        for image in ims{
                            if jsontemp != nil {
                                let ups: Int = getJsonValueInt(json: data, key: "ups")
                                let downs: Int = getJsonValueInt(json: data, key: "downs")
                                let views: Int = getJsonValueInt(json: data, key: "views")
                                let author: String  = getJsonValueStr(json: data, key: "account_url")
                                let title: String = getJsonValueStr(json: data, key: "title")
                                let description: String = getJsonValueStr(json: data, key: "description")
                                let time: Double = getJsonValueD(json: data, key: "datetime")
                                let imageid: String = getJsonValueStr(json: image.1, key: "id")
                                let fav: Bool = getJsonValueBool(json: data, key: "favorite")
                                let votes: Int = ups - downs
                                var url: URL?
                                print("user", self.type)
                                if self.type == 3 {
                                    url = parseUrlAlbum(json: data)
                                    if url != nil{
                                        print("image", url)
                                    }
                                    else{
                                        print("no image")
                                    }
                                }
                                else{
                                    url = parseUrlGallery(json: image)
                                }
                                if url != nil{
                                    let ext = url!.pathExtension
                                    if (exts.contains(ext)){
                                        let entry = im(url: url, ups: ups, downs: downs, views: views, author: author, title: title, description: description, votes: votes, time: time, imageid: imageid, fav: fav)
                                        gallery2.append(entry)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return gallery2
    }
    
    func loadJson(completion: ()->Void){
        if (jsonbuffer != nil){
            //print("gogo")
            if let _: JSON? = jsonbuffer!["data"] {
                
                if let max1: Int? = jsonbuffer!["data"].count {
                    //print("gogogo", max1)
                    if max1! == 0{
                        jsonfinished = true
                        completion()
                        return
                    }
                    //print(" ", jsonbuffer!["data"] == nil)
                    var gallery2: [im]?
                    if self.type == 3{
                        gallery2 = loadJsonAlbum(max1: max1!)
                    }
                    else{
                        gallery2 = loadJsonGallery(max1: max1!)
                    }
                    jsonloader += min(flow, max1! - jsonloader)
                    if jsonloader >= max1!{
                        jsonfinished = true
                    }
                    if gallery2 != nil{
                        gallery2!.sort(by: {
                            im1, im2 in
                            sorting(first: im1, second: im2)
                        })
                        gallery.append(contentsOf: gallery2!)
                        print("loaded  json", gallery2!.count)
                        completion()
                    }
                }
            }
        }
    }
    
    func loadDisplay(){
        if gallery.count - self.load >= flow2 {
            for i in gallery[self.load..<self.load + flow2]{
                displayed.append(i)
            }
            //displayed.append(contentsOf: gallery[self.load..<self.load + 10])
            self.load += flow2
        }
        else if gallery.count - self.load >= 0 {
            for i in gallery[self.load...]{
                displayed.append(i)
            }
            //displayed.append(contentsOf: gallery[self.load...])
            self.load = gallery.count
        }
        print("loaded", flow2, displayed.count)
    }
    
    func loadImages(completion: @escaping (Bool)->Void){
        if (jsonfinished){
            //DispatchQueue.global().async {
            loadMore(completion: {
                json, error in
                if error{
                    completion(false)
                    return
                }
                jsonbuffer = json!
                jsonloader = 0
                jsonfinished = false
                loadJson(completion: {
                    loadDisplay()
                    loaded = true
                    completion(true)
                })
            })
            //}
        }
        else {
            //DispatchQueue.global().async{
                loadJson(completion: {
                    loadDisplay()
                    loaded = true
                    completion(false)
                })
            //}
        }
    }
    
    func loadMore(completion: @escaping (JSON?, Bool)->Void){
        switch self.type{
        case 0:
//            print("hello", self.search)
            if (!self.search.isEmpty){
                Search(page: self.page, search: self.search, sort: sort, window: window,  completion: {
                    json, error in
                    //print(images)
                    /*if (error){
                        self.error = true
                        return
                    }*/
                    completion(json, error)
                })
            }
        case 1:
            Gallery(page: self.page, section: section, sort: sort, window: window, viral: viral, mature: mature, completion: {
                json, error in
                /*if (error){
                    self.error = true
                    return
                }*/
                completion(json, error)
            })
        case 2:
            if !globalvars.connected{
                self.endpage = false
                completion(nil, true)
                loading = false
                return
            }
            Favorite(page: self.page, sort: sort2, completion: {
                json, error in
                /*if (error){
                    self.error = true
                    return
                }*/
                completion(json, error)
            })
        case 3:
            if !globalvars.connected{
                self.endpage = false
                completion(nil, true)
                loading = false
                return
            }
            UserImages(page: self.page, completion: {
                json, error in
                /*if (error){
                    self.error = true
                    return
                }*/
                completion(json, error)
            })
        default:
            print("error type")
        }
        page += 1
    }
    
    func sorting(first: im, second: im) -> Bool{
        switch sorttype{
        case 0:
            return first.votes > second.votes
        case 1:
            return first.time > second.time
        case 2:
            return first.views > second.views
        case 3:
            return first.votes > second.votes && first.time > second.time
        default:
            return true
        }
    }
        
    func Loop(){
            loaded = false
//            print("load loop", maxloads, loading)
            loadImages(completion: {
                loads in
                if (loads){
                    maxloads += 1
                }
                loaded = true
//                print("loaded")
            })
    }
    
    func loadingLoop(){
//        print("go", loading)
        if (self.search.isEmpty && type == 0){
//            print("set to false")
            loading = false
            return
        }
        DispatchQueue.global().async{
//            print("gogo", loading, maxloads)
            while(self.loading && self.maxloads < 2){
                print("gogogogo")
                while(!loaded){
                }
                DispatchQueue.global().async{Loop()}
//                    if !(loading && maxloads < 2){
//                        return
//                    }
                sleep(1)
            }
            endpage = true
        }
    }
        
    func reset()
    {
        self.loaded = true
        self.maxloads = 0
        self.load = 0
        self.page = 0
        self.jsonloader = 0
        gallery.removeAll()
        displayed.removeAll()
        self.jsonbuffer = nil
        self.jsonfinished = true
        self.loading = true
        print(loading)
        self.loadingLoop()
    }
            /*
            DispatchQueue.concurrentPerform(iterations: 4, execute: { _ in
                loadMore(completion:{
                    json, error
                    loadJson {
                        
                    }
                })
            })*/
    var body: some View {
            HStack{
                Picker(sorts[sorttype], selection: $sort) {
                    Text("hot").tag("viral")
                    Text("top").tag("top")
                    Text("new").tag("time")
                }.onChange(of: sort){
                    sort in
                    switch sort{
                    case "top":
                        self.sorttype = 0
                    case "time":
                        self.sorttype = 1
                    case "viral":
                        self.sorttype = 2
                    default:
                        self.sorttype = 2
                    }
                    if loading == false{
                        maxloads = 0
                        loading = true
                        endpage = false
                        loadingLoop()
                    }
                    self.displayed.sort{
                        im1, im2 in
                        sorting(first: im1, second: im2)
                    }
                }.pickerStyle(SegmentedPickerStyle())
                .scaledToFit()
                .padding(.horizontal, 20)
                Spacer()
                Picker(window, selection: $window) {
                    Text("day").tag("day")
                    Text("week").tag("week")
                    Text("month").tag("month")
                    Text("year").tag("year")
                }.onChange(of: window){
                    sort in
                    switch sort{
                    case "day":
                        self.date = 0
                    case "week":
                        self.date = 1
                    case "month":
                        self.date = 2
                    case "year":
                        self.date = 3
                    default:
                        self.date = 0
                    }
                    if loading == false{
                        maxloads = 0
                        loading = true
                        endpage = false
                        loadingLoop()
                    }
                }.pickerStyle(MenuPickerStyle())
                .scaledToFit()
                .padding(.horizontal, 20)
            }.padding(.horizontal, 20)
        List{
            ForEach(displayed.filter{
               ii in
                    return (ii.time > self.dates![self.date])
                },
                    id: \.self){ i in
                Display(image: i, fs: false)
                    .onTapGesture {
                    //print("tap")
                    self.showFullScreen = true
                    fullscreenimage = i
                }.sheet(isPresented: $showFullScreen, onDismiss: {
                    print("untap")
                    showFullScreen = false
                }){
                    Display(image: fullscreenimage, fs: true)
                }
            }
            if (endpage){
                GeometryReader{ geometry in
                    Button(action: {
                        if (endpage){
                            maxloads = 0
                            loading = true
                            endpage = false
                            loadingLoop()
                        }
                    }, label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .padding(.horizontal, geometry.size.width / 2)
                            .frame(minWidth: 100, minHeight: 100)
                            .background(Circle().foregroundColor(Color.white))
                    })
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }.onChange(of: globalvars.connected){
            value in
            loading = true
            loadingLoop()
        }.onChange(of: self.search){
            text in
            searchQuery(search: text)
        }.onAppear{
            print(self.type, "appeared")
            loading = true
            loadingLoop()
        }.onDisappear{
            print(self.type, "disappeared")
            loading = false
        }
    }
    
}

struct Gallery_Previews: PreviewProvider {
    static var previews: some View {
        GalleryV(type: "gallery")
    }
}
