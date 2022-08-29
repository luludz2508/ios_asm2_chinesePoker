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
let timer = Timer
    .publish(every: 1, on: .main, in: .common)
    .autoconnect()

struct HandView: View {
    @State var onHandCardList:  [Card]
    var width: CGFloat
    @Binding var state: [Bool]
    @Binding var mainPlayerHand : ThreeHandsValue
    @State var counter: Int = 0
    var countTo: Int
    @State var offSet :CGSize = .zero
    var baseOffset : CGSize = .zero
    @State var draggingIndex :UUID = UUID()
    @State var cardHands : [[Card]]=[[],[],[]]
    @State var cardHandValues : [HandValue] =  [HandValue]()
    @State var handsFull : [Bool] = [false,false,false]
    @State var isBroken = false
    @State var isSorted = false
    let rowFull = [3,5,5]
    let rowRange = 0..<3
    var body: some View {
        let cardWidth = width/14
        ZStack (){
            Color.black.opacity(0.6)
                .ignoresSafeArea(.all)
                .scaleEffect(1.5)
            Clocker(counter: counter, countTo: countTo)
                .offset(x: -width*0.4, y: -width*0.15)
            VStack(){
                ZStack (alignment: .leading){
                    Text("Huỷ bài")
                        .padding()
                        .foregroundColor(Color.black) .background(Color.orange)
                        .offset(x:width*0.3,y:-width*0.12)
                        .onTapGesture{
                            for cards in cardHands{
                                onHandCardList += cards
                            }
                            cardHands = [[],[],[]]
                            handsFull = [false,false,false]
                        }
                    Group{
                        if (handsFull[0] && handsFull[1] && handsFull[2]){
                            //Can submit
                            Text("Xong")
                                .padding().foregroundColor(Color.black) .background(Color.orange).cornerRadius(10)
                                .onTapGesture{
                                    finishView()
                                }
                        } else {
                            //shuffle 
                            Text("Xếp bài")
                                .padding()
                                .foregroundColor(Color.black) .background(Color.orange)
                                .cornerRadius(10)
                                .onTapGesture{
                                    if (isSorted){
                                        onHandCardList = sortHandByRank(cards: onHandCardList)
                                    }else {
                                        onHandCardList = sortHandBySuit(cards: onHandCardList)
                                    }
                                    isSorted = !isSorted
                                }
                        }
                        
                    }
                    .offset(x:width*0.46,y: width*0.156)
                    VStack(alignment:.leading ){
                        ForEach(rowRange){
                            row in
                            ZStack {
                                Group{
                                    Color.red
                                    if (handsFull[row]){
                                        let handValue = checkHandType(cards: cardHands[row])
                                        // Display hand cards
                                        ForEach (Array(handValue.handCards.enumerated()), id:\.element){index, card in
                                            CardView(card: card, cardWidth: cardWidth, isDarked: true)
                                                .offset(x: cardWidth * CGFloat(index)*1.2 + width/200 )
                                        }
                                        ForEach (Array(handValue.uselessCards.enumerated()), id:\.element){index, card in
                                            CardView(card: card, cardWidth: cardWidth, isDarked: false)
                                                .offset(x: cardWidth * CGFloat(index + handValue.handCards.count) * 1.2 + width/200)
                                        }
                                        
                                        //Display hand types
                                        Image ("hand\(handValue.handType)")
                                            .offset(x: -width/6, y: 0)
                                            .onAppear{
                                                print(row)
                                            }
                                        if (isBroken){
                                            Image(systemName: "xmark").foregroundColor(Color.red).offset(x: -width/20, y: 0)
                                        }else {
                                            Image(systemName: "checkmark").foregroundColor(Color.green)
                                                .offset(x: -width/20, y: 0)
                                        }
                                    } else {
                                        // Display appending cards
                                        ForEach(Array(cardHands[row].enumerated()), id: \.element) { index,
                                            card in
                                            CardView(card: card, cardWidth: cardWidth, isDarked: false)
                                                .offset(x: cardWidth * CGFloat(index)*1.2 + width/200 )
                                        }
                                        Image(systemName: "xmark").foregroundColor(Color.red).offset(x: -width/20, y: 0)
                                    }
                                }.frame( width: row == 0 ? cardWidth*3.6 : cardWidth*6, height:width/8.5 ,alignment:.leading )
                                    .padding([.horizontal])
                                    .onChange(of: cardHands) { value in
                                        if (cardHands[row].count == rowFull[row] && !handsFull[row]) {
                                            handsFull[row] = true
                                            if (row == 0){
                                                if isHandsBroken(cards:cardHands){
                                                    isBroken = true
                                                    print("Is Broken")
                                                }
                                            }
                                        }
                                        
                                    }
                                
                            }
                        }
                        
                    }
                }.frame(width: width/2,  alignment: .center)
                ZStack{
                    Color.blue.opacity(0.6).ignoresSafeArea()
                    Group{
                        ForEach(Array(onHandCardList.enumerated()), id: \.element) { index,
                            card in
                            CardView(card: card, cardWidth: cardWidth*0.9, isDarked:false)
                                .offset(x: cardWidth * CGFloat(index)*1 + width*0.03  , y:0 )
                                .ignoresSafeArea(.all)
                                .onTapGesture{
                                    addCardToHands(card: card)
                                }
                            
                            
                        }
                    }.frame(width: width, height: width*0.12, alignment:.leading)
                        .ignoresSafeArea(.all)
                }.ignoresSafeArea(.all)
            }
        }.onReceive(timer) { time in
            if (self.counter < self.countTo) {
                self.counter += 1
            }
            if (self.counter == self.countTo){
                finishView()
            }
        }.ignoresSafeArea(.all)
    }
    func finishView(){
        if !onHandCardList.isEmpty{
            for card in onHandCardList{
                addCardToHands(card: card)
            }
        }
        
        self.mainPlayerHand.firstHand =  checkHandType(cards: cardHands[0])
        self.mainPlayerHand.secondHand =  checkHandType(cards: cardHands[1])
        self.mainPlayerHand.thirdHand =  checkHandType(cards: cardHands[2])
        
        self.state = [false,false,false, true]
        
    }
    func addCardToHands(card: Card)->Void{
        
        if (cardHands[2].count < 5){
            cardHands[2].append(contentsOf: [card] )
        } else if (cardHands[1].count < 5){
            cardHands[1].append(contentsOf: [card] )
        } else if (cardHands[0].count < 3){
            cardHands[0].append(contentsOf: [card] )
        }
        
        removeCardFromHandsById(id: card.id)
    }
    func removeCardFromHandsById(id :UUID)-> Void{
        for (i, card) in onHandCardList.enumerated().reversed(){
            
            if card.id == id {
                onHandCardList.remove(at: i)
            }
        }
    }
    @ViewBuilder
    func CardView(card:Card, cardWidth:CGFloat, isDarked : Bool) -> some View{
        CardFrontView(number: card.rank,suit: card.suit,width: cardWidth, isDarked: isDarked)
            .offset(card.id == draggingIndex ? offSet : baseOffset)
            .gesture(
                DragGesture()
                    .onChanged{
                        value in
                        draggingIndex = card.id
                        withAnimation(.linear){
                            offSet = value.translation
                        }
                    }
                    .onEnded{
                        value in
                        withAnimation(.linear){
                            offSet = .zero
                        }
                    }
            )
    }
}

struct HandView_Previews: PreviewProvider {
    
    static var previews: some View {
        let cardList = initCardDesk()
        
        HandView(onHandCardList: cardList[0] ,width:850, state: .constant([true,true,false]), mainPlayerHand: .constant(ThreeHandsValue()), countTo: 10)
            .previewInterfaceOrientation(.landscapeRight)
    }
}

struct Clocker: View {
    var counter: Int
    var countTo: Int
    
    var body: some View {
        ZStack{
            
            Text("\(countTo - counter)")
                .fontWeight(.bold)
                .foregroundColor(warning() ? Color.red : Color.green)
            Circle()
                .fill(Color.clear)
                .frame(width: 50, height: 50)
                .overlay(
                    Circle()
                        .stroke(
                            style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round,
                                lineJoin:.round
                            )
                        )
                        .foregroundColor(
                            (warning() ? Color.red : Color.green)
                        )
                )
            
        }.shadow(color:.black,radius: 25)
    }
    
    func warning() -> Bool {
        return progress() >= 0.9
    }
    
    func progress() -> CGFloat {
        return (CGFloat(counter) / CGFloat(countTo))
    }
}
