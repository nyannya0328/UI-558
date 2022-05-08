//
//  ImagePicker.swift
//  UI-558
//
//  Created by nyannyan0328 on 2022/05/08.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    @Binding var showPicker : Bool
    @Binding var imageData : Data
    var quality : CGFloat = 0.4
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var confing = PHPickerConfiguration()
        confing.selectionLimit = 1
        let picker = PHPickerViewController(configuration: confing)
        picker.delegate = context.coordinator
        
        return picker
        
    }
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
       
        
        
        var parent : ImagePicker
        init(parent : ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if let image = results.first?.itemProvider{
                
                image.loadObject(ofClass: UIImage.self) { image, err in
                    
                    if let data = (image as? UIImage)?.jpegData(compressionQuality: self.parent.quality){
                        
                        DispatchQueue.main.async{
                        self.parent.imageData = data
                        
                        self.parent.showPicker.toggle()
                            
                        }
                    }
                }
                
                
            }
            else{
                self.parent.showPicker.toggle()
            }
            
        }
        
        
    }
}


