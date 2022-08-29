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

struct MenuView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var playerName :String
    @EnvironmentObject var gameData : GameData
    @State var gameInfo = Game()
    @State var menuChosen = 0
    var body: some View {
        ZStack {
            if menuChosen == 0 {
                Image("landing").resizable().edgesIgnoringSafeArea(.all)
                
                Rectangle()
                    .foregroundColor(.clear)
                    .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .bottom, endPoint: .top))
                    .edgesIgnoringSafeArea(.all)
                
                VStack (alignment: .center, spacing :10) {
                    Text("BINH XAP XAM").font(.title).fontWeight(.heavy)
                    if (gameData.game.player.name != ""){
                        Button(action: {
                            menuChosen = 1
                            stopBackgroundMusic()}) {
                                Text("Continue Game").padding()
                            }
                            .font(.system(.headline, design: .rounded))
                            .frame(width:300, height: 50).background(Color.orange)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                        
                    }
                    Button(action: {
                        newGame()
                        menuChosen = 1
                        stopBackgroundMusic()}) {
                            Text("Play Game").padding()
                        }
                        .font(.system(.headline, design: .rounded))
                        .frame(width:300, height: 50).background(Color.orange)
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    Button(action: {}) {
                        NavigationLink(destination: LeaderBoardView()){
                            Text("Leaderboard").padding()
                        }
                    }
                    .font(.system(.headline, design: .rounded))
                    .frame(width:300, height: 50).background(Color.orange)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    Button(action: {}) {
                        NavigationLink(destination: HowToPlayView()){
                            Text("How To Play").padding()
                        }
                    }
                    .font(.system(.headline, design: .rounded))
                    .frame(width:300, height: 50).background(Color.orange)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                    Button(action: {
                        gameData.updateGameData()
                        presentationMode.wrappedValue.dismiss()
                        gameData.clearData()
                    }) {
                        Text("Change Account").padding()
                    }
                    .font(.system(.headline, design: .rounded))
                    .frame(width:300, height: 50).background(Color.orange)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
                    
                }
                .padding(.bottom, 20)
                .foregroundColor(.white)
            }
            
            if menuChosen == 1 {
                GameView(menuChosen : $menuChosen).ignoresSafeArea(.all).onAppear(){
                    
                }
            } 
        }.onAppear(){
            playBackgroundMusic(sound: "menuMusic", type: "mp3")
            gameData.decodeJsonFromJsonFile(name: playerName)
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarBackButtonHidden(true)
    }
    
    func newGame(){
        print(gameData.game.player)
        var player = Player()
        if (gameData.game.player.name != "") {
            print("WRONG NAME")
            player = gameData.game.player
        }else{
            player = Player( money: 1000000, name: playerName, wins: 0, loses: 0)
        }
        let bots   = [1:Player(money: 1000000, name: "Bot1", wins: 0, loses: 0),
                      2:Player(money: 1000000, name: "Bot2", wins: 0, loses: 0),
                      3:Player(money: 1000000, name: "Bot3", wins: 0, loses: 0),]
        gameData.game = Game( round: 1, betRate: 10000, difficulty: .easy, player: player, bots: bots)
    }
}

