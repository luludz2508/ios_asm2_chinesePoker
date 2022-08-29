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

struct LeaderBoardView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var gameData : GameData
    
    var body: some View {
        GeometryReader { screen in
            NavigationView {
                ZStack {
                    Image("landing").resizable().edgesIgnoringSafeArea(.all)
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .background(LinearGradient(gradient: Gradient(colors: [.clear, .black]), startPoint: .bottom, endPoint: .top))
                        .edgesIgnoringSafeArea(.all)
                    
                    ScrollView(.vertical){
                        VStack (alignment: .center, spacing :10) {
                            let dict = gameData.tableGame.sorted(by: {$0.value.player.money > $1.value.player.money})
                            let keys = dict.map{$0.key}
                            let values = dict.map {$0.value}
                            
                            ForEach(keys.indices ) {index in
                                LeaderBoardCard(player: values[index].player)
                            }
                        }
                        .padding(.bottom, screen.size.height/10)
                        .foregroundColor(.white)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .navigationBarBackButtonHidden(false)
        }
    }
}

