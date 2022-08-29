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
import UIKit
struct GameView: View {
    @EnvironmentObject var gameData : GameData
    @Binding var menuChosen : Int
    @State var playerDesks : [[Card]] = initCardDesk()
    @State var mainPlayerHand : ThreeHandsValue = ThreeHandsValue()
    
    @State var stateActivated : [Bool] = [false, true, false, false]
    @State var otherPlayerHands : [Int:ThreeHandsValue]  = [:]
    var playTimeInt = 60
    var body: some View {
        GeometryReader {
            proxy in
            let size = proxy.size
            let divideTime = DispatchTimeInterval.seconds(3)
            let showResultTime = DispatchTimeInterval.seconds(15)
            let playTime = DispatchTimeInterval.seconds(playTimeInt)
            ZStack (alignment: .center){
                GameBackgroundView(gameInfo: gameData.game, size: size).ignoresSafeArea(.all)
                Color.black.opacity(stateActivated[0] ?0 : 0.5).ignoresSafeArea(.all)
                
                if (stateActivated[0]  ){
                    
                    Text("Back")
                        .padding().foregroundColor(.white).cornerRadius(20).background(Color.orange).offset(x: -size.width*0.4, y: -size.height*0.37 )
                    
                        .onTapGesture {
                            print("backkkkk")
                            menuChosen = 0
                        }
                    
                    Text ("START").padding().foregroundColor(.white).cornerRadius(20).background(Color.orange)
                        .onTapGesture{
                            stateActivated = [false,true, false, false]
                            stopBackgroundMusic()
                            playBackgroundMusic(sound: "gameMusic", type: "mp3")
                            
                        }
                    
                }
                // Dividing cards state
                if (stateActivated[1]  ){
                    // Cards divition view
                    DivideCardView(  width: size.width)
                        .frame(width: size.width, height: size.height, alignment: .center)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + divideTime){
                                stateActivated[2] = true
                            }
                        }
                        .zIndex(1)
                }
                
                // PLaying cards state
                if (stateActivated[2]) {
                    // Cards playing view
                    HandView(onHandCardList:  sortHandByRank(cards: playerDesks[0]) ,width: size.width,state: $stateActivated,mainPlayerHand:$mainPlayerHand , countTo: playTimeInt)
                        .frame(width: size.width, height: size.height )
                        .onAppear{
                            otherPlayerHands = getBotsHandReady()
                            
                        }
                        .onDisappear(){
                            
                        }
                        .zIndex(2)
                } 
                
                // Displaying and comparing cards state
                if (stateActivated[3]) {
                    
                    // Cards result View
                    HandsResultView(size: size,mainPlayerHand: mainPlayerHand, otherPlayerHands: otherPlayerHands )
                        .ignoresSafeArea(.all)
                        .onAppear{
                            DispatchQueue.main.asyncAfter(deadline: .now() + showResultTime){
                                self.resetGameStatus()
                            }
                        }
                        .onAppear(){
                            gameData.game.round! += 1
                            gameData.updateGameData()
                        }
                    
                }
            }
            .onAppear(){
                playBackgroundMusic(sound: "gameMusic", type: "mp3")
                
            }
            .ignoresSafeArea(.all)
        }
        
        
    }
    func getBotsHandReady() -> [Int:ThreeHandsValue]{
        var otherPlayerHands : [Int:ThreeHandsValue] = [1:ThreeHandsValue(),2:ThreeHandsValue(),3:ThreeHandsValue()]
        for index in (1..<4){
            otherPlayerHands[index] = getRandomHand(cards: playerDesks[index])
        }
        return otherPlayerHands
    }
    func resetGameStatus (){
        print("RESETT_------------------------")
        stateActivated[0] = true
        playerDesks =  initCardDesk() 
    }
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        // tell the app to change the orientation
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        print("Changing to", orientation.isPortrait ? "Portrait" : "Landscape")
    }
    
    //    struct GameView_Previews: PreviewProvider {
    //
    //        static var previews: some View {
    //            GameView(gameInfo: .constant( Game( round: 1, difficulty: .easy, player: Player(  money: 1000000, name: "Luludz", trophies: [], wins: 0, loses: 0), bots: [1:Player(money: 1000000, name: "Bot1", wins: 0, loses: 0),
    //                                                                                                                                                                       2:Player(money: 1000000, name: "Bot2", wins: 0, loses: 0),
    //                                                                                                                                                                       3:Player(money: 1000000, name: "Bot3", wins: 0, loses: 0),])) , menuChosen:  .constant(1))
    //                .previewInterfaceOrientation(.landscapeLeft)
    //        }
    //    }
}

func initCardDesk()-> [[Card]]{
    var cardList : [Card] = []
    for i in 1...13 {
        cardList += [Card(  rank: i, suit: "H"),Card(  rank: i, suit: "D"),Card(  rank: i, suit: "C"),Card(  rank: i, suit: "S")]
    }
    cardList.shuffle()
    
    print(cardList.count)
    var playerDesks : [[Card]] = [[],[],[],[]]
    playerDesks[0] = Array(cardList[0..<13])
    playerDesks[1] = Array(cardList[13..<26])
    playerDesks[2] = Array(cardList[26..<39])
    playerDesks[3] = Array(cardList[39..<52])
    
    return playerDesks
}
