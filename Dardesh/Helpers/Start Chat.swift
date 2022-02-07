//
//  Start Chat.swift
//  Dardesh
//
//  Created by Abdelnasser on 06/10/2021.
//

import Foundation
import Firebase



func restartChat(chatRoomId:String,memberIds:[String]){
    //DownLoad users useing memberIds
    
    FUserListner.shared.downloadUsersFromFirestore(withIds: memberIds) { (allUsers) in
        if allUsers.count > 0 {
            creatChatRoom(chatRoomId: chatRoomId, users: allUsers)
        }
    }
    
}


func startChat(sender:User, receiver:User)->String{
    var chatRoomId = ""
    
    let value = sender.id.compare(receiver.id).rawValue
    chatRoomId = value < 0 ? (sender.id + receiver.id) :(receiver.id + sender.id)
    
    
    creatChatRoom (chatRoomId:chatRoomId,users:[sender,receiver])
    return chatRoomId
}



func creatChatRoom(chatRoomId:String,users:[User]){
    
    // if user has already chatRoom we will not create
    
    var usersToCreateChatsFor:[String]
    usersToCreateChatsFor = []
    
    for user in users{
        usersToCreateChatsFor.append(user.id)
    }
    
    firestoreRefrence(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (querySnapshot, error) in
        
        guard let snapshot = querySnapshot else{
            return
        }
        if !snapshot.isEmpty {
            for chatData in snapshot.documents{
                let currentChat = chatData.data() as Dictionary
                
                if let currentUserId = currentChat[kSENDERID]{
                    if usersToCreateChatsFor.contains(currentUserId as! String){
                        usersToCreateChatsFor.remove(at: usersToCreateChatsFor.firstIndex(of: currentUserId as! String)!)
                    }
                }
            }
        }
        
        for userId in usersToCreateChatsFor {
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
               let chatRoomObject = ChatRoom(id: UUID().uuidString, chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverName: receiverUser.username, receiverId: receiverUser.id, date: Date(), memberIds: [senderUser.id,receiverUser.id], lastMassege: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            
                        
            FChatRoomLisntener.shared.saveChatRoom(chatRoomObject)
            
        }
    }
    
    }


func getReceiverFrom(users:[User])->User{
    var allUsers = users
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}
