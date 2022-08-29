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

func getPlayerScrore(mainPlayer: ThreeHandsValue, bots: [Int :ThreeHandsValue], betRate: Int, gameInfo: Game) -> [Int:[String:[Int:Int]]]{
    var results : [Int:[String:[Int:Int]]] = [1:[:], 2:[:], 3:[:], 4:[:]]
    results[1] = comparePlayerThreeHand(mainPlayer: mainPlayer, otherPlayers: bots, betRate: betRate)
    
    var newOtherPlayer = bots
    var newMain = bots[1]
    newOtherPlayer[1] = mainPlayer
    results[2] = comparePlayerThreeHand(mainPlayer: newMain!, otherPlayers: newOtherPlayer, betRate: betRate)
    
    newOtherPlayer = bots
    newMain = bots[2]
    newOtherPlayer[2] = mainPlayer
    results[3] = comparePlayerThreeHand(mainPlayer: newMain!, otherPlayers: newOtherPlayer, betRate: betRate)
    
    newOtherPlayer = bots
    newMain = bots[3]
    newOtherPlayer[3] = mainPlayer
    results[4] = comparePlayerThreeHand(mainPlayer: newMain!, otherPlayers: newOtherPlayer, betRate: betRate)
    
    return results
    
}
func comparePlayerThreeHand(mainPlayer: ThreeHandsValue, otherPlayers: [Int: ThreeHandsValue], betRate: Int) -> [String:[Int:Int]]{
    
    var mainValue :  [Int: Int]  =   [1:0, 2:0 ,3:0]
    var brokenValue :  [Int: Int]  =   [1:0, 2:0 ,3:0]
    var bot = 0
    for playerHand in otherPlayers{
        bot += 1
        var loses = 0
        var brokenLose = 0
        //1
        if checkSmallerHands(smallHand: mainPlayer.firstHand!, bigHand: playerHand.value.firstHand!){
            mainValue[1]! -= playerHand.value.firstHand!.winHand*betRate
            loses += 1
        } else {
            mainValue[1]! += mainPlayer.firstHand!.winHand*betRate
            loses -= 1
        }
        //2
        if checkSmallerHands(smallHand: mainPlayer.secondHand!, bigHand: playerHand.value.secondHand!){
            mainValue[2]! -= playerHand.value.secondHand!.winHand*betRate
            loses += 1
        } else {
            mainValue[2]! += mainPlayer.secondHand!.winHand*betRate
            loses -= 1
        }
        //3
        if checkSmallerHands(smallHand: mainPlayer.thirdHand!, bigHand: playerHand.value.thirdHand!){
            mainValue[3]! -= playerHand.value.firstHand!.winHand*betRate
            loses += 1
        } else {
            mainValue[3]! += mainPlayer.thirdHand!.winHand*betRate
            loses -= 1
        }
        if loses == 3 {
            brokenValue[bot]! -= (mainPlayer.firstHand!.winHand+mainPlayer.secondHand!.winHand+mainPlayer.thirdHand!.winHand)*betRate
        }
        if loses == -3 {
            brokenValue[bot]! += (playerHand.value.firstHand!.winHand+playerHand.value.secondHand!.winHand+playerHand.value.thirdHand!.winHand)*betRate
        }
    }
    return ["handValues":mainValue, "brokenValues":brokenValue]
}
