//
//  CollectionRefrence.swift
//  Dardesh
//
//  Created by Abdelnasser on 29/09/2021.
//

import Foundation
import Firebase

enum FCollectionRefrence:String {
    case User
    case Chat
    case Message
    case Typing
    case Channel
}


func firestoreRefrence(_ collectionRefrence:FCollectionRefrence)->CollectionReference{
    
    return Firestore.firestore().collection(collectionRefrence.rawValue)
}
