//
//  CircleImage.swift
//  Epicture
//
//  Created by Anthony Bellon on 21/10/2020.
//

import SwiftUI
import KingfisherSwiftUI

struct CircleImage: View {
    @EnvironmentObject var globalvars: GlobalVars
    var body: some View {
        KFImage(globalvars.avatar)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 200)
            .clipShape(Circle())
            .overlay( Circle().stroke(Color.gray, lineWidth: 4))
            .shadow(radius: 10)
        
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        CircleImage()
    }
}
