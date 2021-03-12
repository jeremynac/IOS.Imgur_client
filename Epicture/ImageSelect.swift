//
//  ImageSelect.swift
//  Epicture
//
//  Created by Anthony Bellon on 21/10/2020.
//

import SwiftUI
import Alamofire

struct ImageSelect: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentationMode
    @Binding var image: UIImage?
    @State var im: UIImage?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        var parent: ImageSelect

        init(_ parent: ImageSelect) {
            self.parent = parent
        }
    
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
                parent.Upload(completion: {
                    uploaded in
                    if (uploaded){
                        print("uploaded")
                    }
                    else{
                        print("error")
                    }
                })
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func Upload(completion: @escaping (Bool)->Void)
    {
        //let im = UUImageJPEGRepresentation(picture)
        //let url = Bundle.main.url(forResource: im, withExtension: "png")
        if (!connected){
            completion(false)
            return
        }
        if (image != nil){
            if let url2: URL = URL(string: userVars.url + "/3/upload"){
                AF.upload(multipartFormData: {multiparFormData in multiparFormData.append(image!.pngData()!, withName: "image", fileName: "image1", mimeType: "image/png")}, to: url2, headers: userVars.headerUser) .response {
                    response in
                    if response.error != nil{
                        print("error")
                        completion(false)
                        return
                    }
                    print (response)
                    completion(true)
                }
            }
        }
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImageSelect>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImageSelect>) {

    }
}
