//
//  FMessageListener.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class FMessageListener {
    
    static let shared = FMessageListener()
    var newMessageListener : ListenerRegistration!
    var updateMessageListener : ListenerRegistration!
    
    
    private init(){}
    
    func addMessage(_ message:LocalMessage,memberId:String){
        do{
          try  firestoreRefrence(.Message).document(memberId).collection(message.chatRoomId).document(message.id).setData(from: message)
        }catch{
            print("error saving message to firestore",error.localizedDescription)
        }
    }
    
    
    //MARK: - send Channel
    
    func addChannelMessage(_ message:LocalMessage,channel:Channel){
        do{
            try  firestoreRefrence(.Message).document(channel.id).collection(channel.id).document(message.id).setData(from: message)
        }catch{
            print("error saving message to firestore",error.localizedDescription)
        }
    }
    
    
    //MARK: - check for old message
    
    func checkForOldMessage(_ documentId:String,collectionId:String){
        firestoreRefrence(.Message).document(documentId).collection(collectionId).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else{
                return
            }
            var oldMessage = documents.compactMap { (querySnapshot) -> LocalMessage? in
                return try? querySnapshot.data(as: LocalMessage.self)
            }
            
            oldMessage.sort { ($0.date < $1.date)}
            
            for message in oldMessage{
                RealmManager.shared.save(message)
            }
            
        }
        
    }
    
    
    func listenForNewMessages(_ documentId:String,collectionId:String,lastMessage:Date){
        
        newMessageListener = firestoreRefrence(.Message).document(documentId).collection(collectionId).whereField(kDATE, isGreaterThan: lastMessage).addSnapshotListener({ (querySnapshot, error) in
            guard let snapshot = querySnapshot else{return}
            for chang in snapshot.documentChanges{
                if chang.type == .added{
                    let result = Result{
                        try? chang.document.data(as: LocalMessage.self)
                    }
                    
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject{
                            if message.senderId != User.currentId{
                                RealmManager.shared.save(message)
                            }
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        })
        
    }
        //MARK: - Update message status
        
        func updateMessageStatus(_ message:LocalMessage,userId:String){
            
            let values = [kSTATUS:kREAD,kREADDATE:Date()] as [String:Any]
            
            firestoreRefrence(.Message).document(userId).collection(message.chatRoomId).document(message.id).updateData(values)
        }
        
    
    
    //MARK: - Listener for read status update
    
    func listenerForReadStatus(_ documentId:String,collectionId:String,complation:@escaping(_ updateMessage:LocalMessage)->Void){
        
        updateMessageListener = firestoreRefrence(.Message).document(documentId).collection(collectionId).addSnapshotListener({ (querySnapshot, error) in
            
            guard let snapshot = querySnapshot else{return}
            
            for change in snapshot.documentChanges{
                if change.type == .modified{
                    let result = Result{
                        try? change.document.data(as: LocalMessage.self)
                        
                    }
                    switch result {
                    case .success(let messageObject):
                        if let message = messageObject{
                            complation(message)
                        }
                    case .failure(let error):
                        print("Error decoding",error.localizedDescription)
                    }
                }
            }
        })
        
        
    }
    
    
    
    
    func removeNewMessageListeners(){
        self.newMessageListener.remove()
        
        if updateMessageListener != nil{
           self.updateMessageListener.remove()
        }
    }
    
    
    
  
    
}
