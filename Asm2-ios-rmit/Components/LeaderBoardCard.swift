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

struct LeaderBoardCard: View {
    var player: Player
    var body: some View {
        HStack {
            Text("\(player.name)".uppercased())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(alignment: .leading)
                .padding()
            Spacer()
            Text("\(getMoneyFromInt(money: Int(player.money)))".uppercased())
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .frame(alignment: .trailing)
                .padding()
        }
        .font(.system(.headline, design: .rounded))
        .frame(width:300, height: 50).background(Color.orange)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}
