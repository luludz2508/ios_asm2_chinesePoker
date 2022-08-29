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
enum RowStatus {
    case ORIGINAL,FLIP, SHOWING, DISPLAYED,AFTERSHOWN
}
struct DisplayHandView: View {
    @State var playerIndex : Int
    @State var cardList: ThreeHandsValue
    @State var scores:  [String:[Int:Int]]
    @State var rowsStatus: [Int:RowStatus]=[0:RowStatus.ORIGINAL,1:RowStatus.ORIGINAL,2:RowStatus.ORIGINAL]
    @State var width : CGFloat
    @State var rowIndex = [0,0,0]
    var body: some View {
        allCardsView()
        //            allCardsView()
    }
    // MARK: all card view
    @ViewBuilder
    func allCardsView () -> some View{
        let moneyPosition :[Int :[String: Double]] = [1:["x":-width*0.6 ,"y": -width*0.5],
                                                      2:["x": width*0.4 ,"y":  -width*0.4],
                                                      3:["x": -width*0.6 ,"y": width*0.6],
                                                      4:["x": -width*0.4 ,"y": -width*0.4],]
        let balance = calculateBalance(scores: scores)
        ZStack{
            
            ForEach(0..<3){ row in
                if rowsStatus[row] == .SHOWING{
                    Text ("\(scores["handValues"]![row+1]! >= 0 ? "+":"-") \(getMoneyFromInt(money: Int(scores["handValues"]![row+1]!)))")
                        .foregroundColor(scores["handValues"]![row+1]!  >= 0 ? Color.yellow : Color.red)
                        .font(.headline.bold())
                        .offset(x:CGFloat(moneyPosition[playerIndex]!["x"]!),y:CGFloat(moneyPosition[playerIndex]!["y"]!))
                }
            }
        }
        
        if rowsStatus[0] == .AFTERSHOWN{
            Text ("\(balance >= 0 ? "+":"-") \(getMoneyFromInt(money: Int(balance)))")
                .foregroundColor(balance >= 0 ? Color.yellow : Color.red)
                .font(.headline.bold())  
                .offset(x:CGFloat(moneyPosition[playerIndex]!["x"]!),y:CGFloat(moneyPosition[playerIndex]!["y"]!))
            
        }
        
        VStack(alignment:.leading, spacing: -width*0.15){
            ForEach(0..<3){ row in
                
                ShowingRow(row:row).zIndex(rowsStatus[row] == .SHOWING ? 100: 0)
            }
        }
        
        
    }
    
    
    // MARK: Display cards row
    @ViewBuilder
    func ShowingRow(row:Int)-> some View{
        ZStack{
            let handValue : HandValue = (row == 0 ? (cardList.firstHand) : (row == 1 ? cardList.secondHand : cardList.thirdHand))!
            
            if rowsStatus[row] == .SHOWING{
                
                Image ("hand\(handValue.handType)")
                    .offset(x:playerIndex == 4 ? -width*0.5: width*0.5, y: -width*0.08)
            }
            HStack (spacing:-20){
                let range = 0..<(handValue.handCards.count + handValue.uselessCards.count)
                ForEach(range){index in 
                    ZStack{
                        switch rowsStatus[row] {
                        case .ORIGINAL:
                            CardBackView(width: width * 0.2)
                            
                        case .FLIP:
                            CardBackView(width: width * 0.2)
                        case .DISPLAYED:
                            if (index < handValue.handCards.count){
                                CardFrontView(number: handValue.handCards[index].rank,suit: handValue.handCards[index].suit,width: width * 0.2, isDarked: true)
                            } else {
                                
                                CardFrontView(number: handValue.uselessCards[index - handValue.handCards.count].rank,suit: handValue.uselessCards[index - handValue.handCards.count].suit,width: width * 0.2, isDarked: true)
                            }
                        case .SHOWING:
                            
                            if (index < handValue.handCards.count){
                                CardFrontView(number: handValue.handCards[index].rank,suit: handValue.handCards[index].suit,width: width * 0.2, isDarked: true)
                            } else {
                                
                                CardFrontView(number: handValue.uselessCards[index - handValue.handCards.count].rank,suit: handValue.uselessCards[index - handValue.handCards.count].suit,width: width * 0.2, isDarked: false)
                            }
                        case .AFTERSHOWN:
                            
                            if (index < handValue.handCards.count){
                                CardFrontView(number: handValue.handCards[index].rank,suit: handValue.handCards[index].suit,width: width * 0.2, isDarked: true)
                            } else {
                                
                                CardFrontView(number: handValue.uselessCards[index - handValue.handCards.count].rank,suit: handValue.uselessCards[index - handValue.handCards.count].suit,width: width * 0.2, isDarked: false)
                            }
                        case .none:
                            CardBackView(width: width*0.2)
                            
                        }
                        
                    }.zIndex(Double( rowsStatus[row] != RowStatus.ORIGINAL   ? 0: -index))
                        .rotation3DEffect(.degrees(  -180), axis: (x: 0, y:  1  , z: 0))
                        .rotation3DEffect(.degrees(rowsStatus[row] == RowStatus.ORIGINAL ? 0 :   -180), axis: (x: 0, y:  1  , z: 0))
                    
                        .onAppear {
                            let flipTime :Double = 1
                            let delayTime :Double = (flipTime + 3)*Double(( 2-row))
                            let openTime = 4*3
                            withAnimation(.linear(duration: Double(flipTime)).delay(Double(delayTime))) {
                                rowsStatus[row] = RowStatus.FLIP
                            }
                            withAnimation(.linear(duration:  0.001).delay(Double(flipTime/2 + delayTime))) { 
                                rowsStatus[row] = RowStatus.SHOWING
                            }
                            withAnimation(.linear(duration:  2).delay(Double(flipTime + delayTime + 2 ))) {
                                rowsStatus[row] = RowStatus.DISPLAYED
                            }
                            withAnimation(.linear(duration:  2).delay(Double(openTime))) {
                                rowsStatus[row] = RowStatus.AFTERSHOWN
                                let balance = calculateBalance(scores: scores)
                                
                                if (balance >= 0){
                                    playSound(sound: "win", type: "wav")
                                } else {
                                    playSound(sound: "lose", type: "wav")
                                    
                                }
                            }
                        }
                        .onDisappear{
                            
                        }
                }
            }
        }
    }
    // MARK: Display Showing Card
    //    @ViewBuilder
    //    func ShowingCard (index : Int)-> some View{
    //        CardFrontView(number: cardList[index].rank,suit: cardList[index].suit,width: width*0.25)
    //    }
    func checkZIndex(row:Int)-> Double{
        return rowsStatus[row] == RowStatus.SHOWING ? 3: rowsStatus[row] == RowStatus.FLIP ? 1:2
    }
}
func calculateBalance(scores:  [String:[Int:Int]]) -> Double{
    var balance :Double = 0
    for hand in scores["handValues"]!{
        balance += Double(hand.value)
    }
    for player in scores["brokenValues"]!{
        balance += Double(player.value)
    }
    print("CALCULATING BALANCING \(balance)")
    return balance
}

//struct DisplayHandView_Previews: PreviewProvider {
//    static var previews: some View {
//        let cardList = initCardDesk()
//        DisplayHandView(cardList: ThreeHandsValue(), scores: <#[String : [Int : Int]]#>, width: 200)
//    }
//}
