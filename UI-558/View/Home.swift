//
//  Home.swift
//  UI-558
//
//  Created by nyannyan0328 on 2022/05/08.
//

import SwiftUI

struct Home: View {
    @StateObject var model : CanvasViewModel = .init()
    var body: some View {
        ZStack{
            
            Color.black
                .ignoresSafeArea()
            
            Canvas()
                .environmentObject(model)
            
            HStack{
                
                Button {
                    
                } label: {
                    
                    Image(systemName: "xmark")
                        .font(.title)
                }
                Spacer()
                
                Button {
                    
                    model.showPicker.toggle()
                } label: {
                    
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
               
            }
            .foregroundColor(.white)
            .padding()
            .maxTop()
            
            
            Button {
                
                model.saveCanvasImage(height: 250) {
                    
                    Canvas()
                        .environmentObject(model)
                    
                }
               
                
            } label: {
                
                Image(systemName: "arrow.right.circle.fill")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding()
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            
            
        }
        .preferredColorScheme(.dark)
        .alert(model.errorMSG, isPresented: $model.showError){}
        .sheet(isPresented: $model.showPicker) {
            
            if let image = UIImage(data: model.imageData){
                
                model.addImageToStack(image: image)
            }
            
        } content: {
            ImagePicker(showPicker: $model.showPicker, imageData: $model.imageData)
        }

    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
