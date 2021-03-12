//
//  Request.swift
//  Epicture
//
//  Created by Jeremy Naccache on 22/10/2020.
//

import Foundation
import Alamofire
import SwiftyJSON
import AuthenticationServices
import SwiftUI
import KingfisherSwiftUI
import OAuthSwift
import SafariServices
/*
let client_id: String = "327002fcc1bf0ad"
let client_secret: String = "37e6597f5bc6b9b208cf05e0e61a71cb1716f08a"
var connected = false
let loadingim = "https://reactnativecode.com/wp-content/uploads/2018/02/Default_Image_Thumbnail.png"
struct userVars {
    static let url: String = "https://api.imgur.com"
    static var token: String = ""
    static var refresh_token: String = ""
    static var username: String = ""
    static var id: String = ""
    static var headers: HTTPHeaders{[
        "Authorization": "Client-ID " + client_id
    ]}
    static var headerUser = HTTPHeaders()
}
*//*
func getJson()
{
    
}
public class AnilistAPIConfigurations: Codable {
    public let id: Int
    public let secret: String
    public let name: String
    public let redirectURL: URL
    
    static func load() -> AnilistAPIConfigurations {
        let filePath = Bundle.main.url(forResource: "anilist_api", withExtension: "json")!
        let data = try! Data(contentsOf: filePath)
        let object = try! JSONDecoder().decode(AnilistAPIConfigurations.self, from: data)
        return object
    }
}

/*func processQuery(query: [String])
{
    var def = 0
    switch query[0]{
    case "access_token":
        userVars.token = query[1]
        userVars.headerUser.add(name: "Authorization", value: "Bearer " + userVars.token)
        
    case "refresh_token":
        userVars.refresh_token = query[1]
    case "account_id":
        userVars.id = query[1]
    case "account_username":
        userVars.username = query[1]
    default:
        if def == 0 {
            def = 1
        }
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

typealias ASPresentationAnchor = UIWindow
class SignInViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {

    // MARK: - ASWebAuthenticationPresentationContextProviding
    
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    
    func signIn() {
            //let signInPromise = Future<URL, Error> { completion in
                //let apiData = AnilistAPIConfigurations.load()
        if let authUrl = URL(string: userVars.url + "/oauth2/authorize?response_type=token&client_id=" + client_id){
                print(authUrl)
                let authSession = ASWebAuthenticationSession(
                    url: authUrl, callbackURLScheme:
                        "Epicture://imgur.com/") { (url, error) in
                    if let error = error {
                        print("error", error)
                    } else if let url = url {
                        connected = true
                        processUrl(url: url)
                        }
                    else{
                        print("error")
                    }
                }
                authSession.presentationContextProvider = self
                authSession.prefersEphemeralWebBrowserSession = true
                authSession.start()
            }
            /*
            
            signInPromise.sink { (completion) in
                switch completion {
                case .failure(let error): // Handle the error here. An error can even be when the user cancels authentication.
                default: break
                }
            }
         receiveValue: { (url) in
                self.processResponseURL(url: url)
            }
            .store(in: &subscriptions)
        */
        //}
    }
}
*/

/*
func getGallery(page: Int, completion: @escaping ([UIImageView])->Void)
{
    AF.request(userVars.url + "/3/gallery/hot/top/day/" + String(page) + "?showViral=true&mature=false&album_previews=false", encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        //print(response)
        if let json = try? JSON(data: response.data!) {
            var images = [UIImageView]()
            for i in 0...json["data"].count
            {
                if let url2: URL = URL(string: (json["data"][i]["link"].stringValue)){
                    print(url2)
                    let uimage: UIImageView = UIImageView.init()
                    uimage.sd_setImage(with: url2)
                    images.append(uimage)
                }
            }
            completion(images)
        }
    }
}

func Search(page: Int, search: String, completion: @escaping ([UIImageView])->Void)
{
    AF.request(userVars.url + "/3/gallerysearch/time/all/" + String(page) + "/" + search, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        print(response)
        if let json = try? JSON(data: response.data!) {
            var images = [UIImageView]()
            for i in 0...json["data"].count
            {
                if let url2: URL = URL(string: (json["data"][i]["link"].stringValue)){
                    print(url2)
                    let uimage: UIImageView = UIImageView.init()
                    uimage.sd_setImage(with: url2)
                    images.append(uimage)
                }
            }
            completion(images)
        }
    }
}
 */

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

final class CustomSafariViewController: UIViewController {
  var url: URL? {
    didSet {
      configure() // when url changes, reset the safari child view controller
    }
  }
  private var safariViewController: SFSafariViewController?
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  private func configure() {
    // Remove the previous safari child view controller if not nil
    if let safariViewController = safariViewController {
      safariViewController.willMove(toParent: self)
      safariViewController.view.removeFromSuperview()
      safariViewController.removeFromParent()
      self.safariViewController = nil
    }
    guard let url = url else { return }
    // Create a new safari child view controller with the url
    let newSafariViewController = SFSafariViewController(url: url)
    addChild(newSafariViewController)
    newSafariViewController.view.frame = view.frame
    view.addSubview(newSafariViewController.view)
    newSafariViewController.didMove(toParent: self)
    self.safariViewController = newSafariViewController
  }
}

struct SafariView: UIViewControllerRepresentable {
  
  typealias UIViewControllerType = CustomSafariViewController
  
  @Binding var url: URL?
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<SafariView>) -> CustomSafariViewController {
    return CustomSafariViewController()
  }
  
  func updateUIViewController(_ safariViewController: CustomSafariViewController,
                              context: UIViewControllerRepresentableContext<SafariView>) {
    safariViewController.url = url // updates our VC's underlying properties
  }
  
}
/*
class safari: NSObject, SFSafariViewControllerDelegate{
    let url =
    func getToken(vc: SFSafariViewController){
        let oauthswift = OAuth2Swift(
            consumerKey:    client_id,
            consumerSecret: client_secret,
            authorizeUrl:   userVars.url + "/oauth2/authorize",// + "response_type=token",
            responseType:   "token"
        )
        oauthswift.encodeCallbackURL = true
        oauthswift.encodeCallbackURLQuery = false
        let urlString = "https://www.hackingwithswift.com"

        if let url = URL(string: urlString) {
            vc.delegate = self
            oauthswift.authorizeURLHandler = SafariURLHandler(viewController: vc, oauthSwift: oauthswift)
            print("hello")
            let handle = oauthswift.authorize(
                withCallbackURL: "Epicture://oauth-callback/imgur",
                scope: "", state:"") { result in
                switch result {
                case .success(let (credential, response, parameters)):
                  debugPrint(credential.oauthToken)
                  // Do your request
                case .failure(let error):
                  print(error.localizedDescription)
                }
            }
        print("hello2")
        }
    }
}

func token2(){
    let oauthswift = OAuth2Swift(
        consumerKey:    "********",
        consumerSecret: "********",
        authorizeUrl:   "https://api.instagram.com/oauth/authorize",
        responseType:   "token"
    )
    let handle = oauthswift.authorize(
        withCallbackURL: "oauth-swift://oauth-callback/instagram",
        scope: "likes+comments", state:"INSTAGRAM") { result in
        switch result {
        case .success(let (credential, response, parameters)):
          print(credential.oauthToken)
          // Do your request
        case .failure(let error):
          print(error.localizedDescription)
        }
    }
}
/*
class getToken: UIView
{
    
    var session: ASWebAuthenticationSession?
    private func setUp(){
        guard let authURL = URL(string: userVars.url + "oauth2/authorize?client_id=" + client_id + "&response_type=token") else { return }
        let scheme = "https://imgur.com/";

        // Initialize the session.
        session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: scheme)
        { callbackURL, error in
            //print("hello", callbackURL)
        }
        session.presentationContextProvider =
        session.prefersEphemeralWebBrowserSession = true
        session.start()
    }
    /*
    if let url = URL(string: userVars.url + "oauth2/authorize?client_id=" + client_id + "&response_type=token") {
        UIApplication.shared.open(url)
    }
 */
    
    /*
    AF.request(userVars.url + "oauth2/authorize?client_id=" + client_id + "&response_type=token&state=APPLICATION_STATE1", headers: userVars.headers).responseJSON{ response in
            debugPrint(response)
    }
     */
    return ""
}

extension getToken: ASWebAuthenticationPresentationContextProviding {
    public func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return self.view.window!
    }
}
 */


struct ImageGallery: View{
    var images: [URL]
    var image: URL
    init(){
        self.images = [URL]()
        image = URL(string: "https://i.imgur.com/fAJyFcV.jpg")!
        var images2 = [URL]()
        getGallery(page: 0, completion: {
            url in
            images2 = url
        })
        self.images = images2
    }
    func getGallery(page: Int, completion: @escaping([URL])->Void)
    {
        AF.request(userVars.url + "/3/gallery/hot/top/day/" + String(page) + "?showViral=true&mature=false&album_previews=false", encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
            response in
            //print(response)
            if let json = try? JSON(data: response.data!) {
                var images = [URL]()
                for i in 0...json["data"].count
                {
                    if let url2: URL = URL(string: (json["data"][i]["link"].stringValue)){
                        images.append(url2)
                    }
                }
                completion(images)
            }
        }
    }
    func Search(page: Int, search: String, completion: @escaping ([UIImageView])->Void)
    {
        AF.request(userVars.url + "/3/gallerysearch/time/all/" + String(page) + "/" + search, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
            response in
            print(response)
            if let json = try? JSON(data: response.data!) {
                var images = [UIImageView]()
                for i in 0...json["data"].count
                {
                    if let url2: URL = URL(string: (json["data"][i]["link"].stringValue)){
                        print(url2)
                        let uimage: UIImageView = UIImageView.init()
                        images.append(uimage)
                    }
                }
                completion(images)
            }
        }
    }
    
    var body: some View {
        var i: Int = 0
        Button("load more pictures"){
            i += 1
        }
        KFImage(image)
            .resizable()
            .scaledToFit()
        KFImage(image)
            .resizable()
            .scaledToFit()
    }
}
*/

func processJson(json: JSON)->[URL]
{
    var images = [URL]()
    for i in 0...json["data"].count{
        for image in json["data"][i]["images"]{
            if let url = URL(string: image.1["link"].stringValue) {
                if (url.pathExtension == "jpeg" || url.pathExtension == "png" || url.pathExtension == "gif"){
                    images.append(url)
                }
            }
        }
    }
    return images
}
func Search(page: Int, search: String, sort: String, window: String, completion: @escaping ([URL])->Void)
{
    AF.request(userVars.url + "/3/gallery/search/" + sort + "/" + window + "/" + String(page) + "?q=" + search, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        if response.error != nil{
            return
        }
        if let json = try? JSON(data: response.data!) {
            let images = processJson(json: json)
            print(images)
            completion(images)
        }
    }
}

func Gallery(page: Int, section: String, sort: String, window: String, viral: Bool, mature: Bool, completion: @escaping([URL])->Void)
{
    var url: String = userVars.url + "/3/gallery/" + section + "/" + sort + "/" + window + "/" + String(page) + "?showViral="  + String(viral) + "&mature=" + String(mature) + "&album_previews=false"
    AF.request(url, encoding: JSONEncoding.default, headers: userVars.headers).responseJSON {
        response in
        if response.error != nil{
            return
        }
        if let json = try? JSON(data: response.data!) {
            let images = processJson(json: json)
            completion(images)
        }
    }
}

func UserImages(completion: @escaping([URL])->Void)
{
    if (connected){
        AF.request(userVars.url + "/3/account/me/images", encoding: JSONEncoding.default, headers: userVars.headerUser).responseJSON {
            response in
            if response.error != nil{
                return
            }
            if let json = try? JSON(data: response.data!) {
                let images = processJson(json: json)
                completion(images)
            }
        }
    }
    else{
        print("not connected")
    }
}

func Favorite(page: Int, sort: String, completion: @escaping([URL])->Void)
{
    if (connected){
        AF.request(userVars.url + "/3/account/me/gallery_favorites/" + String(page) + "/" + sort, encoding: JSONEncoding.default, headers: userVars.headerUser).responseJSON {
            response in
            if response.error != nil{
                return
            }
            if let json = try? JSON(data: response.data!) {
                let images = processJson(json: json)
                completion(images)
            }
        }
    }
    else{
        print("not connected")
    }
}
/*
struct GalleryH : View
{
    var body: some View {
        ScrollView{
            ForEach(Array(stride(from: 0, to: gallery.count, by: 3)), id: \.self){ i in
                LazyVStack(alignment: .leading)
                {
                    KFImage(gallery[i])
                        .resizable()
                        .scaledToFit()
                    if gallery.count > i + 1 {
                        KFImage(gallery[i + 1])
                            .resizable()
                            .scaledToFit()
                    }
                    if gallery.count > i + 2 {
                        KFImage(gallery[i + 2])
                            .resizable()
                            .scaledToFit()
                    }
                }
            }
            /*
            Button("Load more"){
                page += 1
                loadMore()
            }*/
        }.onAppear{loadMore()}
    }
}
*//*
struct GalleryV : View
{
    @State private var gallery: [URL] = [URL]()//repeating: URL(string: loadingim)!, count: 100)
    @State private var page: Int = 0
    private var type: Int
    private var sort: String
    private var window: String
    private var section: String
    private var sort2: String
    private var viral: Bool
    private var mature: Bool
    private var search: String

    init(type: String = "", sort: String = "viral", window: String = "day", section: String = "hot", sort2: String = "newest", search: String = "things", mature: Bool = false, viral: Bool = true)
    {
        self.sort = sort
        self.window = window
        self.section = section
        self.sort2 = sort2
        self.search = search
        self.mature = mature
        self.viral = viral
        
        switch type{
        case "search":
            self.type = 0
        case "gallery":
            self.type = 1
        case "favorites":
            self.type = 2
        case "user":
            self.type = 3
        default:
            self.type = 1
        }
    }
    func loadMore(){
        switch self.type{
        case 0:
            Search(page: self.page, search: search, sort: sort, window: window,  completion: {
                images in
                gallery.append(contentsOf: images)
            })
        case 1:
            Gallery(page: self.page, section: section, sort: sort, window: window, viral: viral, mature: mature, completion: {
                images in
                gallery.append(contentsOf: images)
            })
        case 3:
            UserImages(completion: {
                images in
                gallery.append(contentsOf: images)
            })
        default:
            Favorite(page: self.page, sort: sort2, completion: {
                images in
                gallery.append(contentsOf: images)
            })
        }
        page += 1
    }
    var body: some View {
        List{
            ForEach(gallery, id: \.self){ i in
                KFImage(i)
                    .cancelOnDisappear(true)
                    .resizable()
                    .scaledToFit()
                    .onAppear(perform: {
                        print(i)
                        if i == gallery[gallery.count - 3]{
                            loadMore()
                            loadMore()
                        }
                    })
            }
            /*
            Button("Load more"){
                page += 1
                loadMore()
            }*//*
        }.onAppear{loadMore();
            loadMore()
        }
    }
}*/*/*/
