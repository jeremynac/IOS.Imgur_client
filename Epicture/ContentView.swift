//
//  ContentView.swift
//  Epicture
//
//  Created by Anthony Bellon on 12/10/2020.
//

import SwiftUI

struct ContentView: View {
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var showsafari = false
    @State private var inputImage: UIImage?
    @State var viewModel: SignInViewModel?
    @EnvironmentObject var globalvars: GlobalVars
    @State var selected = 0
    @State var uploading = false
    @State var show = true
    @State var txt = ""
    @State var searchgallery: GalleryV?
    
       var body: some View {
        ZStack(alignment: .bottom){
            
            VStack{
                
                if self.selected == 0{
                    VStack {
                        GalleryV(type: "gallery")
                        image?
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(15)
                    }
                }
                else if self.selected == 1{
                    VStack{
                    Text("favourite")
                    }.padding()
                    GalleryV(type: "favorite")
                    Spacer()
                }
                 else if self.selected == 3{
                    
                    HStack{
                        if self.show{
                            Image("magnifyingglass").padding(.horizontal, 40)
                            TextField("Search", text: self.$txt, onEditingChanged: {
                                _ in
                                print(self.txt)
                            }, onCommit: {
                                print("search", self.txt)
                                print("search")
                            })
                            Button(action: {
                                
                                withAnimation {
                                    self.txt = ""
                                }
                                
                            }) {
                                
                                Image(systemName: "xmark").foregroundColor(.black)
                            }
                            .padding(.horizontal, 40)
                        }
                    }.onAppear(){
                        if (searchgallery == nil){
                            searchgallery = GalleryV(type: "search", search: self.$txt)
                        }
                    }
                    .padding()
                    Spacer()
                    .background(Color.white)
                    .cornerRadius(20)
                    searchgallery
                }
                else if self.selected == 4{
                    Profile()
                }
        }.background(Color("Color").edgesIgnoringSafeArea(.all)).sheet(isPresented: $showingImagePicker, onDismiss: {self.showingImagePicker = false; self.uploading = false}) {
                ImageSelect(image: self.$inputImage)}
            
        FloatingTabbar(selected: self.$selected, uploading: self.$uploading)
                .onChange(of: self.uploading){
                    up in
                    if up == true{
                        self.showingImagePicker = true
                    }
                }
        }
    }
}
    


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
