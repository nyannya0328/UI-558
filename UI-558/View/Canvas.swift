//
//  Canvas.swift
//  UI-558
//
//  Created by nyannyan0328 on 2022/05/08.
//

import SwiftUI

struct Canvas: View {
    var height : CGFloat = 250
    @EnvironmentObject var model : CanvasViewModel
    var body: some View {
        GeometryReader{proxy in
            
            let size = proxy.size
            
            ZStack{
                
                Color.white
                
                ForEach($model.stack){$stackItem in
                    
                    
                    CanvasSubview(stackItem: $stackItem) {
                        
                        stackItem.view
                        
                    } moveFront: {
                        
                        moveViewToFront(stack: stackItem)
                        
                    } onDelete: {
                        
                        model.cirremtlyTappedItem = stackItem
                        model.showDeleteAlert.toggle()
                        
                    }

                }
                
                
            }
            .frame(width: size.width, height: size.height)
            
        }
        .frame(height: height)
        .clipped()
        .alert("Are you Sure to DeleteView", isPresented: $model.showDeleteAlert) {
            
            
            Button(role: .destructive) {
                
                if let item = model.cirremtlyTappedItem{
                    
                    let index = getIndex(stack: item)
                    model.stack.remove(at: index)
                    
                }
                
                
                
            } label: {
                
                Text("Yes")
            }

            
        }
    }
    func getIndex(stack : StackItem) ->Int{
        
        return model.stack.firstIndex { item in
            return item.id == stack.id
        } ?? 0
    }
    
    func moveViewToFront(stack : StackItem){
        
        
        let currentIndex = getIndex(stack: stack)
        let lastIndex = model.stack.count - 1
        
        model.stack
            .insert(model.stack.remove(at: currentIndex), at: lastIndex)
        
        
    }
}

struct Canvas_Previews: PreviewProvider {
    static var previews: some View {
        Canvas()
    }
}

struct CanvasSubview<Content : View> : View{
    
    var content : Content
    @Binding var stackItem : StackItem
    var moveFront : () -> ()
    var onDelete : () -> ()
    
    init(stackItem : Binding<StackItem>,@ViewBuilder content : @escaping()->Content,moveFront : @escaping()->(),onDelete : @escaping()->()) {
        self.content = content()
        self._stackItem = stackItem
        self.moveFront = moveFront
        self.onDelete = onDelete
    }
    @State var hapticScale : CGFloat = 1
    var body: some View{
        
        content
            .scaleEffect(stackItem.scale < 0.4 ? 0.4 : stackItem.scale)
            .offset(stackItem.offset)
            .rotationEffect(stackItem.rotation)
            .scaleEffect(hapticScale)
            .gesture(TapGesture()
            
                .onEnded({ _ in
                    onDelete()
                    
                })
                    .simultaneously(with: LongPressGesture(minimumDuration:0.3)
                        .onEnded({ _ in
                            
                            
                            withAnimation(.easeInOut){
                                
                                hapticScale = 1.5
                                
                            }
                            withAnimation(.easeInOut.delay(0.1)){
                                
                                hapticScale = 1
                                
                            }
                            
                            moveFront()
                            
                        })
                                   
                                   
                                   )
            
            
            )
            .gesture(
            
            DragGesture()
                .onChanged({ value in
                    
                    stackItem.offset = CGSize(width: stackItem.lastOffset.width + value.translation.width, height: stackItem.lastOffset.height + value.translation.height)
                    
                    
                })
                .onEnded({ value in
                    
                    stackItem.lastOffset = stackItem.offset
                    
                    
                })
            
            )
            .gesture(
            MagnificationGesture()
                .onChanged({ value in
                    
                    stackItem.scale = stackItem.lastScale + (value - 1)
                })
                .onEnded({ value in
                    
                    stackItem.lastScale = stackItem.scale
                })
                .simultaneously(with: RotationGesture()
                               
                    .onChanged({ value in
                        
                        stackItem.rotation = stackItem.lastLotaion + value
                        
                    })
                        .onEnded({ value in
                            
                            stackItem.lastLotaion = stackItem.rotation
                            
                        })
                               
                               )
                
            
            )
        
    }
}
