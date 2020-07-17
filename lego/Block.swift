//
//  Block.swift
//  lego
//
//  Created by Shivam Vijaywargiya on 17/07/20.
//

import SwiftUI

struct Block: View {
    
    @State var rectangles: [Color] = [
        Color(.systemBlue),
        Color(.systemRed),
        Color(.systemGray),
        Color(.clear),
        Color(.systemGreen),
        Color(.systemOrange)
    ]
    
    @Namespace private var cube
    
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9921568627, green: 0.7843137255, blue: 0, alpha: 1))
                .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            loading
        }
    }
    
    
    var loading: some View {
        
        var items: [[Color]] = []
        _ = rectangles.publisher
            .collect(3)
            .collect()
            .sink(receiveValue: { items = $0 })
        
        
        return
            VStack(spacing:0) {
                ForEach(0..<items.count, id: \.self) { index in
                    HStack(spacing:0){
                        if index == 0 {
                            ForEach(items[index].reversed(), id: \.self) { color in
                                Cube(color: color)
                                    .matchedGeometryEffect(id: color.description, in: cube)

                            }
                        } else {
                            ForEach(items[index], id: \.self) { color in
                                Cube(color: color)
                                    .matchedGeometryEffect(id: color.description , in: cube)

                            }
                        }
                    }.animation(.default)
                }
            }
            .onAppear {
                withAnimation {
                    rotate()
                }
            }
        
    }
    
    
    func rotate() {
        for (index, item) in rectangles.enumerated() {
            var nextIndex = index + 1
            if nextIndex > rectangles.count - 1 {
                nextIndex = 0
            }
            
            if item == Color(.clear) {
                rectangles[index] = rectangles[nextIndex]
                rectangles[nextIndex] = Color(.clear)
                
                if index == 3{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            rectangles[nextIndex] = rectangles[5]
                            rectangles[5] = Color(.clear)
                        }
                        
                    }
                } else if index == 0 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation {
                            rectangles[nextIndex] = rectangles[2]
                            rectangles[2] = Color(.clear)
                        }
                        
                    }

                }
             }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation {
                rotate()
            }
        }
    }
    
    
}

struct Cube: View {
    var color: Color
    
    var body: some View {
        Rectangle().fill(color)
            .frame(width: 40, height: 40)
    }
    
    var degrees: Double {
        return 0
    }
}

struct Block_Previews: PreviewProvider {
    static var previews: some View {
        Block()
    }
}
