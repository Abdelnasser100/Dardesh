//
//  FChatRoomLisntener.swift
//  Dardesh
//
//  Created by Abdelnasser on 07/10/2021.
//

import Foundation
import Firebase


class FChatRoomLisntener{
    
    static let shared = FChatRoomLisntener()
    private init(){}
    
    func saveChatRoom(_ chatRoom:ChatRoom){
        do{
            try firestoreRefrence(.Chat).document(chatRoom.id).setData(from: chatRoom)
        }
        catch{
            print("No abel to save document",error.localizedDescription)
            
        }
    }
    
    
    //MARK: - Delate ChatRoom
    
    func deleteChatRoom(_ chatRoom:ChatRoom){
        
        firestoreRefrence(.Chat).document(chatRoom.id).delete()
        
    }
    
    
    //MARK: - Download all chatRoom
    
    func downloadChatRoom(complation:@escaping(_ allFBChatRooms:[ChatRoom])->Void){
        
        firestoreRefrence(.Chat).whereField(kSENDERID, isEqualTo: User.currentId).addSnapshotListener { (snapshot, error) in
            
            var chatRooms:[ChatRoom] = []
            
            guard let documents = snapshot?.documents else{
                print("no documents found")
                return
            }
            let allFBChatRooms = documents.compactMap { (snapshot) -> ChatRoom? in
                return try? snapshot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allFBChatRooms {
                if chatRoom.lastMassege != ""{
                    chatRooms.append(chatRoom)
                }
                
                }
            chatRooms.sort(by: {$0.date! > $1.date!})
            complation(chatRooms)
        }
        
    }
    
    
    //MARK: - reset unread counter
    
    func clearUnreadCounter(chatRoom:ChatRoom){
        
        var newChatRoom = chatRoom
        newChatRoom.unreadCounter = 0
        self.saveChatRoom(newChatRoom)
    }
    
    
    func clearUnreadCounterUsingChatRoomId(chatRoomId :String){
        firestoreRefrence(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).whereField(kSENDERID, isEqualTo: User.currentId).getDocuments { (querySnapshot, error) in
            
            guard let documentes = querySnapshot?.documents else{return}
            
            let allChatRooms = documentes.compactMap { (querySnapShot) -> ChatRoom? in
                return try? querySnapShot.data(as: ChatRoom.self)
            }
            if allChatRooms.count > 0{
                self.clearUnreadCounter(chatRoom: allChatRooms.first!)
            }
        }
        
    }
    
    
    //MARK: - Update chatRoom with new message
    
    private func updateChatRoomWithNewMessage(chatRoom:ChatRoom,lastMessage:String){
        var tempChatRoom = chatRoom
        
        if tempChatRoom.senderId != User.currentId{
            tempChatRoom.unreadCounter += 1
        }
        
        tempChatRoom.lastMassege = lastMessage
        tempChatRoom.date = Date()
        self.saveChatRoom(tempChatRoom)
        
    }
    
    
    func updateChatRooms(chatRoomId:String ,lastMessage:String){
        
        firestoreRefrence(.Chat).whereField(kCHATROOMID, isEqualTo: chatRoomId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else{return}
            
            let allChatRoom = documents.compactMap { (querySnapshot) -> ChatRoom? in
                return try? querySnapshot.data(as: ChatRoom.self)
            }
            
            for chatRoom in allChatRoom{
                self.updateChatRoomWithNewMessage(chatRoom: chatRoom, lastMessage: lastMessage)
            }
        }
    }
    
}
