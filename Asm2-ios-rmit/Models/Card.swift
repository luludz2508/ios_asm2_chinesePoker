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
struct Card: Identifiable,Codable, Comparable , Hashable{
    var id = UUID()
    var rank:Int
    var suit:String 
    static func <(lhs: Card, rhs: Card) -> Bool {
        lhs.rank < rhs.rank
    }
    
}
