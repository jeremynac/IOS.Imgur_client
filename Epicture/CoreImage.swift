//
//  CoreImage.swift
//  Epicture
//
//  Created by Anthony Bellon on 21/10/2020.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct CoreImage: View {
    @State private var image: Image?

    var body: some View {
        VStack {
            image?
                .resizable()
                .scaledToFit()
        }
        .onAppear(perform: loadImage)
    }
    func loadImage() {
        guard let inputImage = UIImage(named: "David") else { return }
        let beginImage = CIImage(image: inputImage)
        let context = CIContext()
        let currentFilter = CIFilter.sepiaTone()
        currentFilter.inputImage = beginImage
        currentFilter.intensity = 1
        
        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
        }
        // more code to come
    }
}

struct CoreImage_Previews: PreviewProvider {
    static var previews: some View {
        CoreImage()
    }
}
