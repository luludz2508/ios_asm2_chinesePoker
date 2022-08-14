//
//  DisplayHandView.swift
//  Asm2-ios-rmit
//
//  Created by Luu Mai Huong on 14/08/2022.
//

import SwiftUI

struct DisplayHandView: View {
    @State var cardList: [Card]
    @State var width : CGFloat
    var body: some View {
            VStack(alignment:.leading, spacing: -width*0.15){
                // first hand
                HStack (spacing:-20){
                    ForEach(0..<3){index in
                        CardFrontView(number: cardList[index].index,symbol: cardList[index].symbol,width: width*0.2)
                     
                    }
                }
                // second hand
                HStack(spacing:-20){
                    
                    ForEach(3..<8){index in
                        CardFrontView(number: cardList[index].index,symbol: cardList[index].symbol,width: width*0.2)
                    }
                }
                // Last hand
                HStack(spacing:-20){
                    ForEach(8..<13){index in
                        CardFrontView(number: cardList[index].index,symbol: cardList[index].symbol,width: width*0.2)
                    }
                }
            }
    }
}

struct DisplayHandView_Previews: PreviewProvider {
    static var previews: some View {
        let cardList = initCardDesk()
        DisplayHandView(cardList: cardList[1]!, width: 200)
    }
}
