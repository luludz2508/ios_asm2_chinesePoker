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

struct HandsResultView: View {
    @EnvironmentObject var gameData : GameData
    var size:CGSize
    var mainPlayerHand : ThreeHandsValue
    var otherPlayerHands :[Int:ThreeHandsValue]
    var body: some View {
        let scores = getPlayerScrore(mainPlayer: mainPlayerHand, bots: otherPlayerHands, betRate: gameData.game.betRate!, gameInfo: gameData.game)
        ZStack {
            HandsResultView(scores: scores )
        }.onAppear(){ 
            gameData.game.player.money += calculateBalance(scores: scores[1]!)
            if (calculateBalance(scores: scores[1]!) >= 0){
                gameData.game.player.wins += 1
            } else {
                gameData.game.player.loses += 1
                
            }
            gameData.game.bots![1]!.money += calculateBalance(scores: scores[2]!)
            
            if (calculateBalance(scores: scores[2]!) >= 0){
                gameData.game.bots![1]!.wins += 1
            } else {
                gameData.game.bots![1]!.loses += 1
            }
            gameData.game.bots![2]!.money += calculateBalance(scores: scores[3]!)
            
            if (calculateBalance(scores: scores[3]!) >= 0){
                gameData.game.bots![2]!.wins += 1
            } else {
                gameData.game.bots![2]!.loses += 1
            }
            gameData.game.bots![3]!.money += calculateBalance(scores: scores[4]!)
            
            if (calculateBalance(scores: scores[4]!) >= 0){
                gameData.game.bots![3]!.wins += 1
            } else {
                gameData.game.bots![3]!.loses += 1
            }
            
            if (gameData.game.player.money <= 0) {
                gameData.game.player.money += 1000000
            }
            var count = 0
            for bot in gameData.game.bots! {
                count += 1
                if (bot.value.money <= 0){
                    gameData.game.bots![count]!.money += 1000000
                }
            }
        }
        
    }
    @ViewBuilder
    func HandsResultView(  scores:[Int:[String:[Int:Int]]]) -> some View{
        DisplayHandView(playerIndex:1,cardList: mainPlayerHand, scores: scores[1]!, width: size.width*0.3)
            .padding()
            .frame(width: size.width, height: size.height, alignment: .bottom)
            .offset(x:size.width*0.07)
            .ignoresSafeArea()
        DisplayHandView(playerIndex:3,cardList: otherPlayerHands[2]!, scores: scores[3]!, width: size.width*0.21 )
            .padding()
            .frame(maxWidth:.infinity, maxHeight: .infinity, alignment: .top)
            .offset(x:size.width*0.05)
            .ignoresSafeArea()
        
        DisplayHandView(playerIndex:2,cardList: otherPlayerHands[1]!, scores: scores[2]!,width: size.width*0.22)
            .padding()
            .frame(maxWidth:.infinity, maxHeight: .infinity )
            .offset(x:-size.width*0.36, y: size.height*0.13)
            .ignoresSafeArea()
        
        DisplayHandView(playerIndex:4,cardList: otherPlayerHands[3]!, scores: scores[4]!, width: size.width*0.22)
            .padding()
            .frame(maxWidth:.infinity, maxHeight: .infinity )
            .offset(x:size.width*0.38, y: size.height*0.13)
            .ignoresSafeArea()
    }
}

//struct HandsResultView_Previews: PreviewProvider {
//    static var previews: some View {
//        HandsResultView()
//    }
//}
