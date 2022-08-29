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

import Foundation
import SwiftUI

struct ThreeHandsValue : Codable{
    var firstHand : HandValue?
    var secondHand : HandValue?
    var thirdHand : HandValue?
}
struct HandValue : Codable{
    var handType : Int
    var highestRank : Int
    var handCards : [Card]
    var uselessCards : [Card]
    var winHand: Int
    init(handType : Int, highestRank : Int, handCards : [Card], uselessCards : [Card], winHand:Int){
        self.handType = handType
        self.highestRank = highestRank
        self.handCards = handCards
        self.uselessCards = uselessCards
        self.winHand = winHand
    }
}
enum NormalHand {
    case mau_thau, doi, thu, sam, sanh, thung, cu_lu, tu_quy, thung_sanh
}
var HAND_RANK = [ NormalHand.mau_thau:1, NormalHand.doi:2, NormalHand.thu:3, NormalHand.sam:4, NormalHand.sanh:5, NormalHand.thung:6, NormalHand.cu_lu:7, NormalHand.tu_quy:8,  NormalHand.thung_sanh:9]

let sanhCheckingArray = [1,2,3,4,5,6,7,8,9,10,11,12,13,1]
func sortHandByRank(cards:[Card]) -> [Card]{
    var sortedHands = cards.sorted{ $0.rank < $1.rank }
    if (sortedHands.contains{$0.rank == 1} && !sortedHands.contains{$0.rank == 2}){
        let ACount = sortedHands.filter{$0.rank == 1}.count
        let AArray = sortedHands[0..<ACount]
        sortedHands.removeSubrange(0..<ACount)
        sortedHands.append(contentsOf: AArray)
    }
    return sortedHands
}
func sortHandByRankForCompare(cards:[Card]) -> [Card]{
    var sortedHands = cards.sorted{ $0.rank < $1.rank }
    if (sortedHands.contains{$0.rank == 1} ){
        let ACount = sortedHands.filter{$0.rank == 1}.count
        let AArray = sortedHands[0..<ACount]
        sortedHands.removeSubrange(0..<ACount)
        sortedHands.append(contentsOf: AArray)
    }
    return sortedHands
}
func sortHandBySuit(cards:[Card]) -> [Card]{
    return cards.sorted(by: { $0.suit > $1.suit })
}
func checkSmallerHands(smallHand: HandValue , bigHand: HandValue) -> Bool{
    if ( smallHand.handType > bigHand.handType){
        return false
    }
    if (smallHand.handType == bigHand.handType){
        if (smallHand.highestRank > bigHand.highestRank){
            if (bigHand.handCards.contains{$0.rank == 1} ){
                return true
            }
            return false
        }
        if (smallHand.highestRank < bigHand.highestRank){
            if (smallHand.handCards.contains{$0.rank == 1} ){
                return false
            }
            return true
        }
        if ( smallHand.highestRank == bigHand.highestRank ){
            let smallHandSorted : [Card] = sortHandByRankForCompare(cards: smallHand.uselessCards).reversed()
            let bigHandSorted :[Card] = sortHandByRankForCompare(cards: bigHand.uselessCards).reversed()
            for i in (0..<smallHandSorted.count){
                print("index \(i)")
                if (smallHandSorted[i].rank > bigHandSorted[i].rank){
                    if (bigHandSorted[i].rank == 1){
                        return true
                    }
                    return false
                }
            }
        }
    }
    return true
}
func isHandsBroken(cards:[[Card]]) -> Bool{
    let firstHand = checkHandType(cards: cards[0])
    let secondHand = checkHandType(cards: cards[1])
    let thirdHand = checkHandType(cards: cards[2])
    if (!checkSmallerHands(smallHand: firstHand, bigHand: secondHand)){
        return true
    }
    if (!checkSmallerHands(smallHand: secondHand, bigHand: thirdHand)){
        return true
    }
    return false
}
func printHand (cards: [Int: [Card]]) -> [[Int]]{
    var returningCardList : [[Int]]  = []
    for row in cards {
        var rowValue :[Int] = []
        for card in row.value{
            rowValue.append(card.rank)
        }
        returningCardList.append(rowValue)
    }
    return returningCardList
    
}
func printCards (cards:  [Card] ) -> [String]{
    var returningCardList : [String]  = []
    for card in cards {
        returningCardList.append("\(card.rank)-\(card.suit)")
    }
    return returningCardList
    
}
func isHandsBrokenDictionary(cards:[Int:[Card]]) -> Bool{
    let firstHand = checkHandType(cards: cards[0]!)
    let secondHand = checkHandType(cards: cards[1]!)
    let thirdHand = checkHandType(cards: cards[2]!)
    //    if firstHand.handCards.count != 3{
    //        return true
    //    }
    if (!checkSmallerHands(smallHand: firstHand, bigHand: secondHand)){
        return true
    }
    if (!checkSmallerHands(smallHand: secondHand, bigHand: thirdHand)){
        return true
    }
    return false
}
func checkHandType(cards: [Card]) -> HandValue{
    let quantity = cards.count
    let sortedCards = sortHandByRank(cards: cards)
    //Thung pha sanh
    if (quantity == 5 && checkThung(cards: sortedCards) && checkSanh(cards: sortedCards)){
        return getThungPhaSanh(cards: cards)
    } else
    //Tu quy
    if (quantity == 5 && checkTuQuy(cards: sortedCards)){
        return getTuQuy(cards: sortedCards)
    } else
    //Cu lu
    if (quantity == 5 && checkCulu(cards: sortedCards)){
        return getCulu(cards: sortedCards)
    } else
    //thung
    if (quantity == 5 && checkThung(cards: sortedCards)){
        return getThung(cards: sortedCards)
    } else
    //Sanh
    if (quantity == 5 && checkSanh(cards: sortedCards)){
        return getSanh(cards: sortedCards)
    } else
    //sam
    if (checkSam(cards: sortedCards)){
        return getSam(cards: sortedCards)
    } else
    //Thu
    if (quantity == 5 && checkThu(cards: sortedCards)){
        return getThu(cards: sortedCards)
    } else
    //Doi
    if (checkDoi(cards: sortedCards)){
        return getDoi(cards: sortedCards)
    } else
    //Mau Thau
    {
        return getMauThau(cards: sortedCards)
    }
}
func getHighestCard(cards:[Card]) -> Card{
    var highestIndex : Card = cards[0]
    if cards.contains(where: { $0.rank == 1})  {
        for card in cards{
            if card.rank == 1{
                highestIndex = card
                break
            }
        }
    } else {
        var highestCard : Card = cards[0]
        for card in cards {
            if card.rank > highestCard.rank {
                highestCard = card
            }
        }
        highestIndex = highestCard
    }
    return highestIndex
}

// MARK: -HAND Check functions
//Thùng phá sảnh checking
func getThungPhaSanh(cards: [Card])-> HandValue{
    
    return HandValue(handType: HAND_RANK[NormalHand.thung_sanh]!, highestRank: getHighestCard(cards: cards).rank, handCards: cards, uselessCards: [], winHand: 5)
}
//Tứ quý checking
func checkTuQuy(cards: [Card]) -> Bool{
    let quantity = cards.count
    var prevElement = cards[0]
    var count = 0
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            count += 1
        } else {
            count = 0
        }
        
        if (count == 3){
            return true
        }
        prevElement = value
    }
    return false
}
func getTuQuy(cards: [Card]) -> HandValue{     let quantity = cards.count
    var prevElement = cards[0]
    var count = 0
    var tuquyCards : [Card] = []
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            tuquyCards.append(prevElement)
            count += 1
            
        } else {
            count = 0
        }
        
        if (count == 3){
            tuquyCards.append(value)
            break
        }
        prevElement = value
    }
    let useless = sortHandByRank(cards: cards.difference(from: tuquyCards))
    
    return HandValue(handType: HAND_RANK[NormalHand.tu_quy]!, highestRank: tuquyCards[0].rank, handCards: tuquyCards, uselessCards: useless, winHand: 4)
}

//Cù lũ checking
func checkCulu(cards: [Card]) -> Bool{
    var sam:[Card] = []
    var doi:[Card] = []
    if ( cards[0].rank == cards[1].rank && cards[1].rank == cards[2].rank ){
        sam = Array(cards[0..<3])
        if (cards[3].rank == cards[4].rank){
            doi = Array(cards[3..<5])
        }
    } else if ( cards[2].rank == cards[3].rank && cards[3].rank == cards[4].rank){
        
        sam = Array(cards[2..<5])
        if (cards[0].rank == cards[1].rank){
            doi = Array(cards[0..<2])
        }
    }
    if (sam.isEmpty || doi.isEmpty){
        return false
    }
    return true
}
func getCulu(cards: [Card]) -> HandValue{
    var sam:[Card] = []
    if ( cards[0].rank == cards[1].rank && cards[1].rank == cards[2].rank ){
        sam = Array(cards[0..<3])
    } else if ( cards[2].rank == cards[3].rank && cards[3].rank == cards[4].rank){
        
        sam = Array(cards[2..<5])
    }
    return HandValue(handType: HAND_RANK[NormalHand.cu_lu]!, highestRank: sam[0].rank, handCards: cards, uselessCards: [], winHand: 1)
}

// Thung
func checkThung(cards: [Card]) -> Bool{
    if (cards[0].suit == cards[1].suit && cards[1].suit == cards[2].suit && cards[2].suit == cards[3].suit && cards[3].suit == cards[4].suit   ){
        return true
    }
    return false
}
func getThung (cards: [Card]) -> HandValue{
    let thung = cards
    return HandValue(handType: HAND_RANK[NormalHand.thung]!, highestRank: cards[4].rank, handCards: thung, uselessCards: [], winHand: 1)
}

// Sanh
func checkSanh(cards: [Card]) -> Bool{
    var count = 0
    for index in sanhCheckingArray{
        if (cards[count].rank == index){
            count += 1
        } else {
            if (count>0) {
                return false
            }
            count = 0
        }
        if (count == 5){
            return true
        }
    }
    
    return false
}
func getSanh (cards: [Card]) -> HandValue{
    let sanh = cards
    return HandValue(handType: HAND_RANK[NormalHand.sanh]!, highestRank: cards[4].rank, handCards: sanh, uselessCards: [], winHand: 1)
}
// sam
func checkSam(cards :[Card])-> Bool{
    let quantity = cards.count
    var prevElement = cards[0]
    var count = 0
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            count += 1
        } else {
            count = 0
        }
        
        if (count == 2){
            return true
        }
        prevElement = value
    }
    return false
}
func getSam(cards :[Card])-> HandValue{
    let quantity = cards.count
    var prevElement = cards[0]
    var count = 0
    var samCards : [Card] = []
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            samCards.append(prevElement)
            count += 1
            
        } else {
            count = 0
        }
        
        if (count == 2){
            samCards.append(value)
            break
        }
        prevElement = value
    }
    let useless = sortHandByRank(cards: cards.difference(from: samCards))
    
    return HandValue(handType: HAND_RANK[NormalHand.sam]!, highestRank: samCards[0].rank, handCards: samCards, uselessCards: useless, winHand: 1)
}

//thu

func checkThu(cards :[Card])-> Bool{
    var prevElement = cards[0]
    var count = 0
    var pairCount=0
    for value in cards[1..<5]{
        if (value.rank == prevElement.rank){
            count += 1
        } else {
            count = 0
        }
        
        if (count == 1){
            pairCount += 1
        }
        
        if (pairCount == 2){
            return true
        }
        prevElement = value
    }
    return false
}

func getThu(cards :[Card])-> HandValue{
    var prevElement = cards[0]
    var count = 0
    var pairCount=0
    var thuCards : [Card] = []
    for value in cards[1..<5]{
        if (value.rank == prevElement.rank){
            thuCards.append(prevElement)
            
            count += 1
        } else {
            count = 0
        }
        
        if (count == 1){
            thuCards.append(value)
            pairCount += 1
        }
        
        if (pairCount == 2){
            break
        }
        prevElement = value
    }
    let useless = sortHandByRank(cards: cards.difference(from: thuCards))
    return HandValue(handType: HAND_RANK[NormalHand.thu]!, highestRank: thuCards[3].rank, handCards: thuCards, uselessCards: useless, winHand: 1)
}


//Doi

func checkDoi(cards :[Card])-> Bool{
    let quantity = cards.count
    
    var prevElement = cards[0]
    var count = 0
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            count += 1
        } else {
            count = 0
        }
        
        if (count == 1){
            return true
        }
        prevElement = value
    }
    return false
}
func getDoi(cards :[Card])-> HandValue{
    let quantity = cards.count
    var prevElement = cards[0]
    var count = 0
    var doiCards : [Card] = []
    for value in cards[1..<quantity]{
        if (value.rank == prevElement.rank){
            doiCards.append(prevElement)
            count += 1
            
        } else {
            count = 0
        }
        
        if (count == 1){
            doiCards.append(value)
            break
        }
        prevElement = value
    }
    let useless = sortHandByRank(cards: cards.difference(from: doiCards))
    
    return HandValue(handType: HAND_RANK[NormalHand.doi]!, highestRank: doiCards[0].rank, handCards: doiCards, uselessCards: useless, winHand: 1)
}

//GET mau thau

func getMauThau(cards: [Card]) -> HandValue{
    let quantity = cards.count
    let highestCard = getHighestCard(cards: cards)
    let useless = sortHandByRank(cards: cards.difference(from: [highestCard]))
    
    return HandValue(handType: HAND_RANK[NormalHand.mau_thau]!, highestRank:  highestCard.rank, handCards: [highestCard], uselessCards: useless, winHand: 1)
}
