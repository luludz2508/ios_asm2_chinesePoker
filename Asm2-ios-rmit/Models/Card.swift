//
//  Card.swift
//  Asm2-ios-rmit
//
//  Created by Luu Mai Huong on 14/08/2022.
//

import Foundation
struct Card: Identifiable,Codable {
    var id = UUID()
    var index:Int
    var symbol:String
    init( index:Int, symbol:String){ 
        self.index=index;
        self.symbol=symbol;
    }
}
