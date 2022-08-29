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
// MARK: - ObservableObject
//Saving local saved favorite images - fetched and write from/to json local file
class GameData: ObservableObject{
    let fileName="table"
    @Published var  game : Game = Game()
    @Published var  tableGame : [String:Game] = [:]
    var userName = ""
    // fetch files from local json files located in Document
    func decodeJsonFromJsonFile( name: String)  {
        do{
            let dir = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
                .appendingPathExtension("json")
            
            print(dir)
            if let data = try? Data(contentsOf: dir) {
                
                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Game].self, from: data)
                let dict = decoded.toDictionary { $0.player.name }
                
                tableGame = dict
                game = tableGame[name] ?? Game()
                userName = name
            }
        } catch _ {
        }
        
    }
    func clearData(){
        userName = ""
        game = Game()
    }
    //  MARK:  Function write updated data to local files
    func updateGameData(){
        do {
            if userName != ""{
                tableGame[userName] = game
            }
            let furl = try FileManager.default
                .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                .appendingPathComponent(fileName)
                .appendingPathExtension("json")
            print("---> writing file to: \(furl)")
            let data = try JSONEncoder().encode(Array(tableGame.values))
            try data.write(to: furl)
        } catch {
            print("---> error saveToFile: \(error)")
        }
    }
    
}
