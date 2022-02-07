//
//  Channel.swift
//  Dardesh
//
//  Created by Abdelnasser on 30/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift


struct Channel:Codable {
    var id = ""
    var name = ""
    var adminId = ""
    var memberIds = [""]
    var avatarLink = ""
    var aboutChannel = ""
    @ServerTimestamp var createDate = Date()
    @ServerTimestamp var lastMessageDate = Date()
    
    enum CodingKeys : String,CodingKey {
        case id
        case name
        case adminId
        case memberIds
        case avatarLink
        case aboutChannel
        case createDate
        case lastMessageDate = "date"
        
        
    }
}
