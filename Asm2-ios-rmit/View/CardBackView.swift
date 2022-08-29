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

struct CardBackView: View {
    var width:CGFloat
    var body: some View {
        
        Image("Back")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:width)
            .opacity(0.7)
            .cornerRadius(width*0.01 )
            .overlay(
                RoundedRectangle(cornerRadius: width*0.01)
                    .stroke(Color.black, lineWidth: width*0.08 )            .opacity(0.7)
                
                    .overlay(
                        RoundedRectangle(cornerRadius: width*0.01 )
                            .stroke(Color.white, lineWidth: width*0.06 )
                    )
            )
            .background(LinearGradient(gradient: Gradient(colors: [.black, .white]), startPoint: .topLeading, endPoint: .bottomTrailing))
    }
}

struct CardBackView_Previews: PreviewProvider {
    static var previews: some View {
        CardBackView(width: 200)
    }
}
