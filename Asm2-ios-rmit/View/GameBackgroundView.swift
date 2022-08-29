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

struct GameBackgroundView: View {
    var gameInfo: Game
    var size: CGSize
    var body: some View {
        ZStack{
            Image("poker-table")
                .resizable().ignoresSafeArea(.all)
            
            ZStack(alignment: .leading){
                PlayerInfoView(player: gameInfo.player)
                    .ignoresSafeArea()
                
            }.frame(width: 300, alignment: .leading).background(.clear)                    .offset(y:size.height*0.33)
            
            
            ZStack(alignment: .center){
                PlayerInfoView(player: gameInfo.bots![1]!)
                    .ignoresSafeArea().scaleEffect()
                
            }.frame(height: 250, alignment: .top).background(.clear)                           .offset(x:-size.width*0.38)
            
            ZStack(alignment: .leading){
                PlayerInfoView(player: gameInfo.bots![2]!)
                    .ignoresSafeArea()
                
            }.frame(width: 300, alignment: .leading).background(.clear)                    .offset(y:-size.height*0.35)
            
            
            
            ZStack(alignment: .topTrailing){
                PlayerInfoView(player: gameInfo.bots![3]!)
                
            }.frame(height: 250, alignment: .topTrailing).background(.clear)                    .offset(x:size.width*0.38)
            
        } .ignoresSafeArea(.all)
    }
}

struct GameBackgroundView_Previews: PreviewProvider {
    static var previews: some View {
        GameBackgroundView(gameInfo: Game( round: 1, difficulty: .easy, player: Player(  money: 1000000, name: "Luludz", trophies: [], wins: 0, loses: 0), bots: [1:Player(money: 1000000, name: "Bot1", wins: 0, loses: 0),
                                                                                                                                                                  2:Player(money: 1000000, name: "Bot2", wins: 0, loses: 0),
                                                                                                                                                                  3:Player(money: 1000000, name: "Bot3", wins: 0, loses: 0)]),size: UIScreen.main.bounds.size)
        .previewInterfaceOrientation(.landscapeLeft)
    }
}
