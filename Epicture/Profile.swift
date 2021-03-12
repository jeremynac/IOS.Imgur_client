//
//  Profile.swift
//  Epicture
//
//  Created by Jeremy Naccache on 28/10/2020.
//

import Foundation
import SwiftUI

struct Profile: View{
    @EnvironmentObject var globalvars: GlobalVars
    @State var viewModel: SignInViewModel?
    var userimages: GalleryV?
    var body: some View{
        HStack {
            CircleImage()
                .offset(y: 0)
                .frame(width: 63, height: 63)
                .scaledToFit()
            Text(globalvars.username).bold()
                .font(.title)
        }.scaledToFit()
        VStack {
            if (!globalvars.connected){
                
                Text("You're not logged in !")
                Spacer(minLength: 9)
                Button(action: {viewModel!.signIn()}, label: {
                    Text("Log in").frame(width: 200, height: 80, alignment: .center).foregroundColor(Color.white).background(RoundedRectangle(cornerRadius: 80).foregroundColor(Color.gray))
                }).onAppear{
                    viewModel = SignInViewModel(globalvars: self.globalvars)
                }.aspectRatio(contentMode: .fill)
                .buttonStyle(PlainButtonStyle())
                Spacer()
            }
            else {
                GalleryV(type: "user")
                .padding()
            }
        }
    }
}
