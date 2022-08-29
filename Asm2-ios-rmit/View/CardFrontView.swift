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

struct CardFrontView: View {
    var number :Int
    var suit:String
    var width:CGFloat
    var isDarked:Bool
    var body: some View {
        Image(String(number)+suit)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:width)
            .cornerRadius(5)
            .opacity(isDarked ? 0.7 : 1)
            .overlay(
                RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1 )
            )
            .background(.black)
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(number: 13, suit: "H",width: 50, isDarked: true)
    }
}
