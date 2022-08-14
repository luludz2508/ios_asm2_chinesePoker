//
//  CardFrontView.swift
//  Asm2-ios-rmit
//
//  Created by Luu Mai Huong on 14/08/2022.
//

import SwiftUI

struct CardFrontView: View {
    var number :Int
    var symbol:String
    var width:CGFloat
    var body: some View {
        Image(String(number)+symbol)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width:width)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5).stroke(Color.black, lineWidth: 1 )
            )
    }
}

struct CardFrontView_Previews: PreviewProvider {
    static var previews: some View {
        CardFrontView(number: 13, symbol: "H",width: 50)
    }
}
