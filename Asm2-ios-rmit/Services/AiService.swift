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
struct RecursiveObject :Codable {
    var hands : [Int:[Card]]?
    var otherCards : [Card]?
    
}
func getRandomHand(cards : [Card]) -> ThreeHandsValue {
    let hands = getPossibleHands(cards: cards)
    let randomHand = hands[Int.random(in: 0...(hands.count - 1))]
    var returnHands : ThreeHandsValue = ThreeHandsValue()
    returnHands.firstHand =  checkHandType(cards: randomHand.hands![0]!)
    returnHands.secondHand =  checkHandType(cards: randomHand.hands![1]!)
    returnHands.thirdHand =  checkHandType(cards: randomHand.hands![2]!)
    return returnHands
}
func getPossibleHands(cards :[Card]) -> [RecursiveObject]{  //find possible hands
    var goodHands : [RecursiveObject] = []
    let possibleHands : [RecursiveObject] = recursiveFillHand(recursiveObject: RecursiveObject(hands: [0:[],1:[],2:[]], otherCards: cards))
    print("possible hands count \(possibleHands.count)")
    for hand in possibleHands {
        if !isHandsBrokenDictionary(cards: hand.hands!){
            goodHands.append(hand)
        }
    }
    print("good hands count \(goodHands.count)")
    
    return goodHands
}

func recursiveFillHand(recursiveObject : RecursiveObject) -> [RecursiveObject] {
    //    print ("modifying : \(recursiveObject.hands)")
    let copiedHand = sortHandByRank(cards: recursiveObject.otherCards!)
    let rankCountDictionary = getRankCountDictionnary(cards: copiedHand)
    let occuranceRankCountDictionary = rankCountDictionary.reduce(into: [:]) { counts, cardRank in
        counts[cardRank.value.count, default: 0] += 1
    }
    let suitCountDictionary = getSuitCountDictionnary(cards: copiedHand)
    print("hands \(printHand(cards: recursiveObject.hands! ))") 
    // init new mix of current hand
    var goodHands :[[Card]] = []
    let currentHand = checkCurrentHandIndex(recursiveObject: recursiveObject)
    
    //Check maubinh
    if checkTuQuy(occuranceRankCountDictionary: occuranceRankCountDictionary){
        var tuQuyList : [Int:[Card]] = [:]
        for cards in rankCountDictionary {
            if cards.value.count == 4{
                tuQuyList[cards.key] = cards.value
            }
        }
        if (!tuQuyList.isEmpty){
            let maxKey = (tuQuyList.keys.contains{$0 == 1} ? 1 : tuQuyList.keys.max())!
            goodHands.append(tuQuyList[maxKey]!)
        }
    }
    
    if checkThungPhaSanh(suitCountDictionary: suitCountDictionary){
        goodHands.append(getThungPhaSanh(suitCountDictionary: suitCountDictionary))
        
    }
    //Check hands from big to small
    if checkCulu(occuranceRankCountDictionary :occuranceRankCountDictionary){
        var cards :[Card] = []
        cards += rankCountDictionary[rankCountDictionary.first(where: {$1.count == 3})!.key]!
        cards += rankCountDictionary[rankCountDictionary.first(where: {$1.count == 2})!.key]!
        goodHands.append(cards)
    }
    if checkThung(suitCountDictionary: suitCountDictionary) {
        goodHands += getThung(suitCountDictionary: suitCountDictionary)
    }
    
    if checkSanh(rankCountDictionary: rankCountDictionary) {
        goodHands.append(getSanh(rankCountDictionary: rankCountDictionary))
    }
    if checkSam(occuranceRankCountDictionary: occuranceRankCountDictionary){
        let cardList : [Int:[Card]] = rankCountDictionary.filter{ $0.value.count == 3}
        let highIndex : Int = cardList.keys.contains{$0 == 1} ? 1 : cardList.keys.max()!
        
        goodHands.append(cardList[highIndex]!)
    }
    
    if checkThu(occuranceRankCountDictionary: occuranceRankCountDictionary ) && currentHand != 2 {
        var cardList : [Int:[Card]] = rankCountDictionary.filter{ $0.value.count == 2}
        let highPairIndex : Int = cardList.keys.contains{$0 == 1} ? 1 : cardList.keys.max()!
        print(highPairIndex)
        let highPair = cardList[highPairIndex]!
        cardList.removeValue(forKey: highPairIndex)
        let lowPair : [Card] = cardList[cardList.first!.key]!
        let appendList = highPair + lowPair
        goodHands.append(appendList)
    }
    if (goodHands.isEmpty){
        if checkDoi(occuranceRankCountDictionary: occuranceRankCountDictionary){
            var cardList : [Int:[Card]] = rankCountDictionary.filter{ $0.value.count == 2}
            let highPairIndex : Int = cardList.keys.contains{$0 == 1} ? 1 : cardList.keys.max()!
            goodHands.append(cardList[highPairIndex]!)
        }
    }
    if (goodHands.isEmpty && !copiedHand.isEmpty){
        goodHands.append([getBiggest(cards: copiedHand)])
    }
    // solve the final results
    var objectList : [RecursiveObject] = []
    print("goodHand \(goodHands.count)-  ")
    for mix in goodHands {
        let leftCards = recursiveObject.otherCards!.difference(from: mix)
        var newRecursiveObject = recursiveObject
        if (currentHand == 0){
            print(0)
            newRecursiveObject.hands![2] = mix
            newRecursiveObject.otherCards = leftCards
            //            return recursiveFillHand(recursiveObject: newRecursiveObject)
            objectList += recursiveFillHand(recursiveObject: newRecursiveObject)
        }
        else if (currentHand == 1){
            print(1)
            newRecursiveObject.hands![1] = mix
            newRecursiveObject.otherCards = leftCards
            //            return recursiveFillHand(recursiveObject: newRecursiveObject)
            objectList += recursiveFillHand(recursiveObject: newRecursiveObject)
        } else if (currentHand == 2){
            print(2)
            newRecursiveObject.hands![0] = mix
            newRecursiveObject.otherCards = leftCards
            //            return recursiveFillHand(recursiveObject: newRecursiveObject)
            objectList += recursiveFillHand(recursiveObject: newRecursiveObject)
        } else {
            newRecursiveObject = addLeftCardToHands(recursiveObject: recursiveObject)
            objectList.append(newRecursiveObject)
        }
    }
    print("goodHands \(goodHands.count) - currentHand \(currentHand) objectList  \(objectList.count)")
    return objectList
}
func checkCurrentHandIndex(recursiveObject : RecursiveObject) -> Int{
    var count = 3
    for hand in recursiveObject.hands!{
        if hand.value.isEmpty {
            count -= 1
        }
    }
    return count
}
func addLeftCardToHands(recursiveObject : RecursiveObject)-> RecursiveObject{
    var newObject = recursiveObject
    var otherCards : [Card] = recursiveObject.otherCards!
    for card in otherCards {
        if (newObject.hands![2]!.count < 5){
            newObject.hands![2]!.append(contentsOf: [card] )
        } else if (newObject.hands![1]!.count < 5){
            newObject.hands![1]!.append(contentsOf: [card] )
        } else if (newObject.hands![0]!.count < 3){
            newObject.hands![0]!.append(contentsOf: [card] )
        }
    }
    newObject.otherCards = []
    return newObject
}
// MARK: Counting function

func getRankCountDictionnary(cards :[Card]) -> [Int:[Card]]{
    var dictionary: [Int: [Card]] = [:]
    for index in (0..<cards.count){
        if (dictionary.keys.contains{
            $0 == cards[index].rank
        }){
            dictionary[cards[index].rank]! += [cards[index]]
        } else {
            dictionary[cards[index].rank] = [cards[index]]
        }
        
    }
    return dictionary
}
func getSuitCountDictionnary(cards :[Card]) -> [String:[Card]]{
    var dictionary: [String: [Card]] = [:]
    for index in (0..<cards.count){
        if (dictionary.keys.contains{
            $0 == cards[index].suit
        }){
            dictionary[cards[index].suit]! += [cards[index]]
        } else {
            dictionary[cards[index].suit] = [cards[index]]
        }
        
    }
    return dictionary
}
//func getIdentifyDictionary (cards : [Card]) -> [Int :[Card]]{
//    var dictionary :[Int:[Card]] = [1:[],2:[],3:[],4:[],5:[],6:[],7:[],8:[],9:[],10:[],11:[],12:[],13:[]]
//    for card in cards {
//        dictionary[card.rank]! += [card]
//    }
//    return dictionary
//}
// MARK: Check mau binh
func checkTuQuy( occuranceRankCountDictionary: [Int:Int]) -> Bool{
    //check tu quy
    if (occuranceRankCountDictionary.keys.contains{$0 == 4}){
        return true
    }
    return false
}
func checkThungPhaSanh( suitCountDictionary: [String:[Card]]) -> Bool{
    //check thung pha sanh
    for suit in suitCountDictionary {
        if (suit.key.count>=5){
            var count = 0
            var prevElement = suit.value[0]
            for index in (1..<suit.value.count) {
                if (suit.value[index].rank == prevElement.rank){
                    count += 1
                } else {
                    if (suit.value[index].rank == 13 && count == 3 && suit.value[0].rank == 1){
                        return true
                    }
                    count = 0
                }
                if count == 4 {
                    return true
                }
                prevElement = suit.value[index]
            }
        }
    }
    return false
}

func getThungPhaSanh( suitCountDictionary: [String:[Card]]) ->  [Card]{
    //check thung pha sanh
    for suit in suitCountDictionary {
        if (suit.key.count>=5){
            var count : [Card] = []
            var prevElement = suit.value[0]
            for index in (1..<suit.value.count) {
                if (suit.value[index].rank == prevElement.rank){
                    count += [prevElement]
                } else {
                    if (suit.value[index].rank == 13 && count.count == 4 && suit.value[0].rank == 1){
                        count += [suit.value[0]]
                        return count
                    }
                    count = []
                }
                if count.count == 5 {
                    return count
                }
                prevElement = suit.value[index]
            }
        }
    }
    return []
}

// MARK: check normal hands
func checkCulu(occuranceRankCountDictionary: [Int :Int]) -> Bool{
    if (occuranceRankCountDictionary.keys.contains{$0 == 2} && occuranceRankCountDictionary.keys.contains{$0 == 3}){
        if (occuranceRankCountDictionary[2]! >= 1 && occuranceRankCountDictionary[3]! >= 1 ){
            return true
        }
    }
    return false}
func checkThung(suitCountDictionary: [String: [Card]]) -> Bool{
    if suitCountDictionary.values.contains(where: {$0.count>=5})
    {
        return true
    }
    return false
}

func getThung(suitCountDictionary: [ String: [Card]]) -> [[Card]]{
    var fiveSuitList : [[Card]] = []
    for suit in suitCountDictionary {
        if suitCountDictionary.values.contains(where: { $0.count >= 5 }){
            if  suit.value.contains(where: {$0.rank == 1}){
                fiveSuitList.append(Array(suit.value.prefix(5)))
            } else {
                fiveSuitList.append(Array(suit.value.suffix(5)))
            }
            
        }
    }
    return fiveSuitList
}
func checkSanh(rankCountDictionary:[Int: [Card]]) -> Bool {
    var count = 0
    for index in (1..<14){
        if rankCountDictionary.keys.contains(where: { $0 == index }){
            count += 1
        } else {
            if( index == 13 && count == 4 && rankCountDictionary.keys.contains{ $0 == 1}){
                return true
            }
            count = 0
        }
        if (count == 5 ){
            return true
        }
    }
    return false
}


func getSanh(rankCountDictionary:[Int: [Card]]) -> [Card] {
    var count :[Card] = []
    var seriesList :[Card] = []
    for index in (1..<14){
        if rankCountDictionary.keys.contains(where: { $0 == index }){
            count += [rankCountDictionary[index]!.first!]
        } else {
            if( index == 13 && count.count == 4 && rankCountDictionary.keys.contains{ $0 == 1}){
                count += [rankCountDictionary[1]!.first!]
                return count
            }
            count = []
        }
        if (count.count >= 5 ){
            seriesList = count
        }
    }
    
    return seriesList.suffix(5)
}

func checkSam(occuranceRankCountDictionary:[Int: Int]) -> Bool {
    if (occuranceRankCountDictionary.keys.contains{$0 == 3} ){
        if (occuranceRankCountDictionary[3]! >= 1){
            return true
        }
    }
    return false
}
func checkThu(occuranceRankCountDictionary:[Int: Int]) -> Bool {
    if (occuranceRankCountDictionary.keys.contains{$0 == 2} ){
        if (occuranceRankCountDictionary[2]! >= 2){
            return true
        }
    }
    return false
}
func checkDoi(occuranceRankCountDictionary:[Int: Int]) -> Bool {
    if (occuranceRankCountDictionary.keys.contains{$0 == 2} ){
        if (occuranceRankCountDictionary[2]! >= 1){
            return true
        }
    }
    return false
}
func getBiggest(cards: [Card]) -> Card{
    if cards.contains{$0.rank == 1}{
        return cards.first!
    }
    var highestCard = cards[0]
    for card in cards {
        if card.rank > highestCard.rank {
            highestCard = card
        }
    }
    return highestCard
}
