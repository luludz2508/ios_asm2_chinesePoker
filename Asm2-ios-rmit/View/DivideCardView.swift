/*
 RMIT University Vietnam
 Course: COSC2659 iOS Development
 Semester: 2022B
 Assessment: Assignment 2
 Author: Nguyen Thanh Luan
 ID: s3757937
 Created  date: 14/08/2022
 Last modified: 29/08/2022
 */

import SwiftUI

struct DivideCardView: View {
    var width: CGFloat
    @State private var startAnimation: [Bool] = [false,false,false,false,false,false,false,false,false,false,false,false,false,]
    var body: some View {
        let cardStack = 0..<13
        let cardSize = width * 0.05
        ZStack{
            ForEach (cardStack){ index in
                
                // Left Player
                CardBackView(width: cardSize)
                    .rotationEffect(.degrees(startAnimation[index] ? 630  : 90))
                    .offset(x: startAnimation[index] ? 0 - width/2.2 : 0,
                            y: startAnimation[index] ?   CGFloat(index*10) - width/15 : -CGFloat(index) * width * 0.0025)
                    .onAppear() {
                        withAnimation(.linear(duration: 0.2).delay(Double(index)*0.2)){
                            startAnimation[index] = true
                        }
                    }
                // Right Player
                CardBackView(width: cardSize)
                    .rotationEffect(.degrees(startAnimation[index] ? 630  : 90))
                    .offset(x: startAnimation[index] ? 0 + width/2.2  : 0, y: startAnimation[index] ?    width/15 - CGFloat(index*10 ) :  -CGFloat(index) * width * 0.0025)
                    .onAppear() {
                        withAnimation(.linear(duration: 0.2).delay(Double( index)*0.2)){
                            startAnimation[index] = true
                        }
                    }
                
                // Top Player
                CardBackView(width: cardSize)
                    .rotationEffect(.degrees(startAnimation[index] ? 720  : 90))
                    .offset(x: startAnimation[index] ? width/9 - CGFloat(index*15 ) : 0,
                            y: startAnimation[index] ?  -width/6 :  -CGFloat(index) * width * 0.0025)
                    .onAppear() {
                        withAnimation(.linear(duration: 0.2).delay(Double(index)*0.2)){
                            startAnimation[index] = true
                        }
                    }
                
                // Bottom Player
                CardBackView(width: cardSize)
                    .rotationEffect(.degrees(startAnimation[index] ? 720  : 90))
                    .offset(x: startAnimation[index] ? CGFloat(index*15 ) -  width/9   : 0,
                            y: startAnimation[index] ?   width/6 :  -CGFloat(index) * width * 0.0025)
                    .onAppear() {
                        withAnimation(.linear(duration: 0.2).delay(Double(index)*0.2)){
                            startAnimation[index] = true
                        }
                    }
            }
        }
        
    }
}

struct DivideCardView_Previews: PreviewProvider {
    static var previews: some View {
        
        DivideCardView( width: 1000)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
