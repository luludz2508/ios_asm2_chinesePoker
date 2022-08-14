//
//  GameView.swift
//  Asm2-ios-rmit
//
//  Created by Luu Mai Huong on 13/08/2022.
//

import SwiftUI
import UIKit
struct GameView: View {
    @State var playerDesks : [Int:[Card]] = initCardDesk()
    var body: some View {
        GeometryReader {
            proxy in
            let size = proxy.size
            
            ZStack{
                handsResultView(size: size).frame(width: size.width, height: size.height)
                
            }.onAppear(){
                changeOrientation(to: .landscapeLeft)
                
            }
        }
        
        
    }
    // MARK: Hand display View
    @ViewBuilder
    func handsResultView(size:CGSize) -> some View{
        
        DisplayHandView(cardList: playerDesks[4]!, width: 250)
        
            .padding().frame(width: size.width, height: size.height, alignment: .bottom)
        
        DisplayHandView(cardList: playerDesks[1]!, width: 220)
            .padding()
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .top)
        DisplayHandView(cardList: playerDesks[2]!, width: 235)
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .leading).padding()
        DisplayHandView(cardList: playerDesks[3]!, width: 235)
        
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .trailing).padding()
        
        
    }
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        // tell the app to change the orientation
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        print("Changing to", orientation.isPortrait ? "Portrait" : "Landscape")
    }
    
    struct GameView_Previews: PreviewProvider {
        static var previews: some View {
            GameView()
                .previewInterfaceOrientation(.landscapeLeft)
        }
    }
}

func initCardDesk()-> [Int:[Card]]{
    var cardList : [Card] = []
    for i in 1...13 {
        cardList += [Card(  index: i, symbol: "H"),Card(  index: i, symbol: "D"),Card(  index: i, symbol: "C"),Card(  index: i, symbol: "S")]
    }
    cardList.shuffle()
    var playerDesks :[Int:[Card]] = [:]
    playerDesks[1] = Array(cardList[0..<13])
    playerDesks[2] = Array(cardList[13..<26])
    playerDesks[3] = Array(cardList[26..<39])
    playerDesks[4] = Array(cardList[39..<52])
    
    return playerDesks
}
