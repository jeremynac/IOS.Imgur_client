//
//  Display.swift
//  Epicture
//
//  Created by Jeremy Naccache on 28/10/2020.
//

import Foundation
import SwiftUI
import KingfisherSwiftUI
import SDWebImageSwiftUI
import AVFoundation
import VideoPlayer
import AVKit

//struct DisplayLikes: View{
//    var
//    init(ups)
//    var body: some View{
//        VStack(alignement: .leading){
//
//        }
//    }
//}

struct Display: View{
    private var url: URL
    private var type: Int
    @State private var show: Bool = true
    private var image: im
    private var fs: Bool = false
    private var timestr: String? = ""
    @State private var fav: Image?
    @State private var isfav: Bool = false
    init(image: im?, fs: Bool = false){
        if image != nil{
            self.image = image!
            self.url = self.image.url!
            self.fs = fs
            switch url.pathExtension{
            case "png":
                type = 1
            case "jpeg":
                type = 1
            case "jpg":
                type = 1
            case "gif":
                type = 2
            case "mp4":
                type = 3
            default:
                type = -1
            }
        }
        else{
            self.image = im()
            self.url = self.image.url!
            self.fs = fs
            self.type = -1
        }
        let formatter = DateComponentsFormatter()
        let now = Date()
        let then = Date(timeIntervalSince1970: self.image.time)
        formatter.allowedUnits = [.second, .hour, .minute, .day, .weekday, .month, .year]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .brief
        timestr = formatter.string(from: then, to: now)
        self.isfav = self.image.fav
        if (self.image.fav) {
            fav = Image(systemName: "star.fill")
        }
        else{
            fav = Image(systemName: "star")
        }
    }
    func favoriteImage(){
        sendFavorite(imageid: self.image.imageid, completion: {
            error in
            if (error){
                print("error favoriting")
            }
            else{
                self.isfav = true
                fav = Image(systemName: "star.fill")
                print("favorited")
                
            }
        })
    }
    
    var body: some View{
        if (fs){
            Text("published by: " + image.author)
                .font(.subheadline)
                .padding(4)
        }
        if (self.show){
            Group{
                switch self.type{
                case 1:
                    KFImage(url)
                        .cancelOnDisappear(true)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15.0)
                case 2:
                    AnimatedImage(url: url)
                        .placeholder(content: {return KFImage(loadingim)})
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15.0)
                case 3:
                    VideoPlayer(url: url, play: $show)
                        .autoReplay(true)
                        .mute(true)
                        .scaledToFit()
                        .cornerRadius(15.0)
                default:
                    AnimatedImage(name: "spinner.gif")
                        .cornerRadius(15.0)
                }
            }.onTapGesture(count: 2){
                if (!isfav){
                    favoriteImage()
                }
            }.padding(4)
        }
        HStack()
        {
            Text(String(image.ups))
                .multilineTextAlignment(.leading)
            Image(systemName: "arrowtriangle.up.fill")
            Text(String(image.downs))
                .multilineTextAlignment(.leading)
            Image(systemName: "arrowtriangle.down.fill")
            Text(String(image.views))
                .multilineTextAlignment(.trailing)
            Image(systemName: "eye.fill")
            Spacer()
            if (self.image.fav || self.isfav){
                Image(systemName: "heart.fill").foregroundColor(Color.red).padding(.horizontal, 9)
            }
            else{
                Image(systemName: "heart").padding(.horizontal, 9)
                    .onTapGesture {
                        favoriteImage()
                    }
            }
        }.padding(.horizontal, 20)
        if (fs){
            VStack{
                Text(image.title)
                    .font(.title)
                    .padding(.trailing, 9)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                Text(image.description)
                    .font(.title2)
                Text(self.timestr!)
                    .font(.title3)
            }.padding(.vertical, 20)
        }
    }
}

