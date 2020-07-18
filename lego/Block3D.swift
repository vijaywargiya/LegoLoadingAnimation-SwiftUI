//
//  Cuve.swift
//  lego
//
//  Created by Shivam Vijaywargiya on 17/07/20.
//

import SwiftUI

struct Cube: View {
    var color: Color
    var body: some View {
        if color == Color(.clear){
            emptyView
        } else {
            cube
        }
    }
    
    var emptyView: some View {
        EmptyView()
    }
    
    var cube: some View {
        Rectangle().fill(color)
            .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            .mask(Image("cube"))
            .overlay(Image("cube").opacity(color == Color(.clear) ? 0 : 0.5))
    }
}

struct Block3D: View {
    @State var rectangles: [Color] = [
        Color(.systemBlue),
        Color(.systemRed),
        Color(.systemGray),
        Color(.clear),
        Color(.systemGreen),
        Color(.systemOrange)
    ]
    
    @Namespace private var cubeNamespace
    
    var body: some View {
        ZStack {
            ForEach(0..<rectangles.count) { index in
                cube(index: index)
            }
        }
        .onAppear {
            withAnimation {
                rotate()
            }
        }
    }
    
    func getOffset(for index: Int) -> (CGFloat, CGFloat) {
        switch index {
        case 0 :
            return (-80,40)
        case 1:
            return (-40,20)
        case 2:
            return (0,0)
        case 3:
            return (40,20)
        case 4:
            return (0,40)
        case 5:
            return (-40,60)
        default:
            return (0,0)
        }
    }
    
    func cube(index: Int) -> some View {
        let offset = getOffset(for: index)
        return Cube(color: rectangles[index])
            .matchedGeometryEffect(id: rectangles[index].description, in: cubeNamespace)
            .offset(x: offset.0, y: offset.1)
            .zIndex(index < 3 ? -Double(index) : Double(index))
    }
    
    func rotate() {
        for (index, item) in rectangles.enumerated() {
            var nextIndex = index - 1
            if nextIndex < 0 {
                nextIndex = 5
            }
            
            if item == Color(.clear) {
                rectangles[index] = rectangles[nextIndex]
                rectangles[nextIndex] = Color(.clear)
             }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                rotate()
            }
        }
    }
}

struct Cube_Previews: PreviewProvider {
    static var previews: some View {
        Block3D()
    }
}
