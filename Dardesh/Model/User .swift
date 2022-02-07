//
//  User .swift
//  Dardesh
//
//  Created by Abdelnasser on 29/09/2021.
//

import Foundation
import FirebaseFirestoreSwift
import  Firebase

struct User:Codable,Equatable {
    var id = ""
    var username:String
    var email:String
    var pushId = ""
    var avatarLink = ""
    var status:String
    
    
    static var currentId:String{
        return Auth.auth().currentUser!.uid
    }
    
    static var currentUser:User?{
        if Auth.auth().currentUser != nil{
            if let data = userDefult.data(forKey : kCURRENTUSER){
                let decoder = JSONDecoder()
                do{
                    let userObject = try decoder.decode(User.self, from: data)
                    return userObject
                }catch{
                    print(error.localizedDescription)
                }
            }
        }
        return nil
    }
    
    
    static func == (lhs:User,rhs:User)->Bool{
        lhs.id == rhs.id
    }
    
}


func saveUserLocally(_ user:User){
    let encoder = JSONEncoder()
    
    do{
        let data = try encoder.encode(user)
        userDefult.set(data,forKey: kCURRENTUSER)
        
        
    }catch{
        print(error.localizedDescription)
    }
    
}



func  createDummyUsers(){
    
    //print("mmmmmmmmmmmmmmmmmmm")
    let name = ["Iron Man","Alaa Najmi","Keanu Reeves","Ali"]
     var imageIndex = 1
     var userIndex = 1
    
    for i in 0..<4{
        let id = UUID().uuidString
        
        let fileDirectory = "Avatars/" + "_\(id)" + ".jpg"
        
        FileStorage.uploadImage(UIImage(named: "user\(imageIndex)")! , directory: fileDirectory) { (avatarLink) in
            
            let user = User(id: id, username: name[i], email: "user\(userIndex)@mail.com", pushId: "", avatarLink: avatarLink ?? "", status: "no status")
            
            userIndex += 1
            FUserListner.shared.saveUserToFireStore(user)
        }
        imageIndex += 1
        if imageIndex == 4{
            imageIndex = 1
        }
    }


}


