//
//  Tabbar.swift
//  Epicture
//
//  Created by Anthony Bellon on 27/10/2020.
//

import SwiftUI
import UIKit

struct FloatingTabbar : View {
    let font = Font.system(size: 24).bold()

    @Binding var selected : Int
    @Binding var uploading: Bool
    @State var expand = false
    @State var alertconnected = false
    
    var body : some View{
        
        HStack{
            
            Spacer(minLength: 0)
            
            HStack{
                
                if !self.expand{
                    Button(action: {
                        self.expand.toggle()
                    }) {
                        Image(systemName: "arrow.left").foregroundColor(.black).padding()
                    }
                }
                else{
                    Button(action: {
                        self.selected = 0
                    }) {
                        Image("Home").foregroundColor(self.selected == 0 ? .blue : .black).padding(.horizontal)
                    }
                    Spacer(minLength: 11)
                    Button(action: {
                        self.selected = 1
                    }) {
                        Image(systemName: "heart").foregroundColor(self.selected == 1 ? .blue : .black).padding(.horizontal)
                    }
                    Spacer(minLength: 11)
                    Button(action: {
                        if (connected){
                            self.uploading = true
                        }
                        else{
                            self.alertconnected = true
                        }
                    }){
                        Image("plusApp").foregroundColor(self.selected == 2 ? .blue : .black).padding(.horizontal)
                            .font(Font.title.weight(.regular))
                            .imageScale(.large)
                    }.alert(isPresented: $alertconnected){
                        Alert(title: Text("Cannot upload images"), message: Text("You are not connected"), dismissButton: .default(Text("ok")))
                    }
                    Spacer(minLength: 11)
                    Button(action: {
                        self.selected = 3
                    }) {
                        Image("magnifyingglass").foregroundColor(self.selected == 3 ? .blue : .black).padding(.horizontal)
                            .imageScale(.large)
                    }
                    Spacer(minLength: 11)
                    Button(action: {
                        self.selected = 4
                    }) {
                        Image("person").foregroundColor(self.selected == 4 ? .blue : .black).padding(.horizontal)
                            .imageScale(.large)

                    }
                    
                }
            }.padding(.vertical,self.expand ? 20 : 8)
            .padding(.horizontal,self.expand ? 35 : 8)
            .background(Color.white)
            .clipShape(Capsule())
            .padding(22)
            .onLongPressGesture {
                    self.expand.toggle()
            }.shadow(radius: 4)
            .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.6, blendDuration: 0.6))
        }
    }
}
