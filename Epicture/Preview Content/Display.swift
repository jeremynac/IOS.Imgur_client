//
//  Display.swift
//  Epicture
//
//  Created by Jeremy Naccache on 27/10/2020.
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
    init(image: im?, fs: Bool = false){
        if (fs){
            print("display")
        }
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
    }
    var body: some View{
        if (fs){
            Text("published by: " + image.author)
                .font(.subheadline)
        }
        if (self.show){
            switch self.type{
            case 1:
                KFImage(url)
                    .cancelOnDisappear(true)
                    .resizable()
                    .scaledToFit()
            case 2:
                AnimatedImage(url: url)
                    .placeholder(content: {return KFImage(loadingim)})
                    .resizable()
                    .scaledToFit()
            case 3:
                VideoPlayer(url: url, play: $show)
                    .autoReplay(true)
                    .mute(true)
                    .scaledToFit()
            default:
                AnimatedImage(name: "spinner.gif")
            }
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
        }
        if (fs){
            Text(image.title)
                .font(.title)
            Text(image.description)
                .font(.title2)
        }
    }
}
