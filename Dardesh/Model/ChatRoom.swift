//
//  ChatRoom.swift
//  Dardesh
//
//  Created by Abdelnasser on 06/10/2021.
//

import Foundation
import FirebaseFirestoreSwift

struct ChatRoom:Codable{
    var id = ""
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverName = ""
    var receiverId = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMassege = ""
    var unreadCounter = 0
    var avatarLink = ""
}
