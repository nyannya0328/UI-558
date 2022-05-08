//
//  CanvasViewModel.swift
//  UI-558
//
//  Created by nyannyan0328 on 2022/05/08.
//

import SwiftUI

class CanvasViewModel:NSObject,ObservableObject {
    @Published var stack : [StackItem] = []
    
    @Published var showPicker : Bool = false
    @Published var imageData : Data = .init(count: 0)
    
    @Published var  showError : Bool = false
    @Published var  errorMSG : String = ""
    
    @Published var showDeleteAlert : Bool = false
    @Published var cirremtlyTappedItem : StackItem?
    
    func addImageToStack(image : UIImage){
        
        let imageView = Image(uiImage: image)
            .resizable().aspectRatio(contentMode: .fit)
            .frame(width: 150, height: 150)

        stack.append(StackItem(view: AnyView(imageView)))
        
        
    }
    func saveCanvasImage<Content : View>(height : CGFloat,@ViewBuilder content : @escaping()->Content){
        
        let uivew = UIHostingController(rootView: content().padding(.top,-getSafeArea().top))
        
        let frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: height))
        
        uivew.view.frame = frame
        
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0.3)
        
        uivew.view.drawHierarchy(in: frame, afterScreenUpdates: true)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
     UIGraphicsEndImageContext()
        
        if let newImage = newImage {
            
            writeToAlbume(image: newImage)
        }
    }
    
    func writeToAlbume(image : UIImage){
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompletion(_:didFinishSavingWithError:contextInfo:)), nil)
        
        
    }
    @objc
    func saveCompletion(_ image : UIImage,didFinishSavingWithError error : Error?,contextInfo : UnsafeRawPointer){
        
        
        if let error = error {
            self.errorMSG = error.localizedDescription
            self.showError.toggle()
        }
        else{
            
            self.errorMSG = "Saved"
            self.showError.toggle()
        }
        
    }
    
}

func getSafeArea()->UIEdgeInsets{
    
    guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
        
        return .zero
    }
    guard let safeArea = screen.windows.first?.safeAreaInsets else{
        
        return .zero
    }
    
    return safeArea
}

