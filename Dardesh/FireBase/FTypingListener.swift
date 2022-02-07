//
//  FTypingListener.swift
//  Dardesh
//
//  Created by Abdelnasser on 11/10/2021.
//

import Foundation
import Firebase



class FTypingListener{
    
    static let shared = FTypingListener()
    var typingListener : ListenerRegistration!
    
    private init(){}
    
    
    func createTypingObserver(chatRoomId:String,complation:@escaping(_ isTyping:Bool)->Void){
        
        typingListener = firestoreRefrence(.Typing).document(chatRoomId).addSnapshotListener({ (documentSnapshot, error) in
            guard let snapshot = documentSnapshot else{return}
            
            if snapshot.exists {
                
                for data in snapshot.data()!{
                    if data.key != User.currentId{
                        complation(data.value as! Bool)
                    }
                    
                }
            }else{
                complation(false)
                firestoreRefrence(.Typing).document(chatRoomId).setData([User.currentId:false])
            }
        })
    }
        
      class  func saveTypingCounter(typing:Bool,chatRoomId:String){
            firestoreRefrence(.Typing).document(chatRoomId).updateData([User.currentId:typing])
        }
        
        func removeTypingListener(){
            self.typingListener.remove()
        }
        
        }

