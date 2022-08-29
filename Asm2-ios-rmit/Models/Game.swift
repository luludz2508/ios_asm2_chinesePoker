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

struct Game : Identifiable, Codable, Hashable{
    enum DIFFICULTY :Codable, Hashable {
        case easy, medium, hard
    }
    var id = UUID()
    var round : Int?
    var betRate : Int?
    var difficulty : DIFFICULTY?
    var player : Player = Player()
    var bots : [Int: Player]?
    
}
