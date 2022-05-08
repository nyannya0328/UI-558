//
//  StackItem.swift
//  UI-558
//
//  Created by nyannyan0328 on 2022/05/08.
//

import SwiftUI

struct StackItem: Identifiable {
    var id = UUID().uuidString
    
    var view :  AnyView
    
    var offset : CGSize = .zero
    var lastOffset : CGSize = .zero
    
    var scale : CGFloat = 1
    var lastScale : CGFloat = 1
    
    var rotation : Angle = .zero
    var lastLotaion : Angle = .zero
}
