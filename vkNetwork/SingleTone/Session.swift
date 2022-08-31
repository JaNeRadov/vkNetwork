//
//  Session.swift
//  vkNetwork
//
//  Created by Jane Z. on 31.08.2022.
//

import Foundation

class Session {
    private init() {}
    
    static let instance = Session()
    
    var token: String = ""
    let userID: Int = 0
}
