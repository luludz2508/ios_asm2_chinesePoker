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

struct Player: Identifiable, Codable, Hashable{
    var id = UUID()
    var money:Double = 1000000
    var name:String = ""
    var trophies:[String] = []
    var wins:Int = 0
    var loses:Int = 0
    var isLost: Bool = false
    
}
