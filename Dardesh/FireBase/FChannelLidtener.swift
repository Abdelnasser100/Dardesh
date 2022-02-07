//
//  FChannelListener.swift
//  Dardesh
//
//  Created by Abdelnasser on 31/10/2021.
//

import Foundation
import Firebase

class FChannelListener{
    
    static let shared = FChannelListener()
    var userChannelListener:ListenerRegistration!
    var subscribedChannelListener:ListenerRegistration!
    
    private init(){}
    
    //MARK: - Add Channel
    
    func saveChannel(_ channel:Channel){
        
        do{
            try firestoreRefrence(.Channel).document(channel.id).setData(from: channel)
        }catch{
            print(error.localizedDescription)
        }
    }
    
    
    //MARK: - Download Channel
    
    func downloadUserChannel(complation:@escaping(_ userChannel:[Channel])->Void){
        
        userChannelListener = firestoreRefrence(.Channel).whereField(kADMINID,isEqualTo: User.currentId).addSnapshotListener({ (quirySnapshot, error) in
            
            guard let documentes = quirySnapshot?.documents else{return}
            
            var userChannels = documentes.compactMap { (queryDocumentSnapShot) -> Channel? in
                return try? queryDocumentSnapShot.data(as: Channel.self)
            }
            
            userChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            complation(userChannels)
        })
    }
    
    
    
    func downloadSubscribdeChannel(complation:@escaping(_ userChannel:[Channel])->Void){
        
        subscribedChannelListener = firestoreRefrence(.Channel).whereField(kMEMBERIDS,arrayContains: User.currentId).addSnapshotListener({ (quirySnapshot, error) in
            
            guard let documentes = quirySnapshot?.documents else{return}
            
            var subscribedChannels = documentes.compactMap { (queryDocumentSnapShot) -> Channel? in
                return try? queryDocumentSnapShot.data(as: Channel.self)
            }
            
            subscribedChannels.sort(by: {$0.memberIds.count > $1.memberIds.count})
            complation(subscribedChannels)
        })
    }
    
    
    func downloadAllChannels(complation:@escaping(_ allChannel:[Channel])->Void){
        
        firestoreRefrence(.Channel).getDocuments { (querySnapshot, error) in
            
            guard let documents = querySnapshot?.documents else{return}
            
            var allChannel = documents.compactMap { (queryDocumentSnapshot) -> Channel? in
                
                return try? queryDocumentSnapshot.data(as: Channel.self)
            }
            
            allChannel = self.removeUserChannel(allChannel)
            allChannel.sort(by: {$0.memberIds.count > $1.memberIds.count})
            complation(allChannel)
        }
        
    }
    
    
    //MARK: - helper func
    
    func removeUserChannel(_ allChannel:[Channel])-> [Channel]{
        
        var newChannels : [Channel] = []
        
        for channel in allChannel{
            if !channel.memberIds.contains(User.currentId){
                newChannels.append(channel)
            }
        }
        return newChannels
    }
    
}
