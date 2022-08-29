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

struct PlayerInfoView: View {
    var player: Player
    var body: some View {
        ZStack(alignment: .center){
            Color("ProfileBlock")
            VStack(alignment:.center){
                Text(player.name).foregroundColor(.white).font(Font.headline.weight(.bold)).lineLimit(2).frame(alignment: .center)
                    .truncationMode(.tail)
                    .padding([.bottom], 5)
                Text(getWinLose()).foregroundColor(.white)
                Text(getMoneyFromInt(money : Int(player.money) )).foregroundColor(.yellow).font(Font.headline.weight(.bold)).padding([.vertical],1 )
            }
        }.frame(width: 110, height: 100, alignment: .center)
    }
    
    func getWinLose()-> String{
        return "W-L: \(player.wins)-\(player.loses)"
    }
}
func getMoneyFromInt(money: Int)->String{
    var suffix :String = ""
    var displayValue :Double = Double(money)
    if abs(money) >= 1000 {
        suffix = "K"
        displayValue = Double(money)/1000
    }
    if abs(money)  >= 1000000{
        suffix = "M"
        displayValue = Double(money)/1000000
    }
    if abs(money)  >= 1000000000{
        suffix = "B"
        displayValue = Double(money)/1000000000
    }
    return String(format: "$%.02f \(suffix)", abs(displayValue) )
    
}
struct PlayerInfoView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerInfoView( player: Player( money: 1603331, name: "Luludz", trophies: ["1","2","3"], wins: 10, loses: 2))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
