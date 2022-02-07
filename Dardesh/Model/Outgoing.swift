//
//  Outgoing.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import UIKit
import FirebaseFirestoreSwift
import Gallery

class Outgoing {
    
    class func sendMessage(chatId:String,text:String?,photo:UIImage?,video:Video?,audio:String?,audioDuration:Float = 0.0,location:String?,memberIds:[String]) {
        
        
        //1-create local message from the data we have
        
        let currentUser = User.currentUser!
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = chatId
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        
        //2-check message type
        
        if text != nil{
            sendText(message:message,text:text!,memberIds:memberIds)
                
            }
            
            if photo != nil{
                sendPhoto(message: message, photo: photo!, memberIds: memberIds)
            }
            
            if video != nil{
                sendVideo(message: message, video: video!, memberIds: memberIds)
            }
            
            if location != nil{
                sendLocation(message: message, memberIds: memberIds)
            }
            
            if audio != nil{
                sendAudio(message: message, audioFileName: audio!, audioDuratian: audioDuration, memberIds: memberIds)
            }
            
            
            //3- save message localy
            //4- save message to firestore
            
            //TODO:- send push notification
        FChatRoomLisntener.shared.updateChatRooms(chatRoomId: chatId, lastMessage: message.message)

    }
    
    
    //MARK: - ChannelMessage
    
    class func sendChannelMessage(channel:Channel,text:String?,photo:UIImage?,video:Video?,audio:String?,audioDuration:Float = 0.0,location:String?) {
        
        
        //1-create local message from the data we have
        
        let currentUser = User.currentUser!
        var channel = channel
        
        let message = LocalMessage()
        message.id = UUID().uuidString
        message.chatRoomId = channel.id
        message.senderId = currentUser.id
        message.senderName = currentUser.username
        message.senderInitials = String(currentUser.username.first!)
        message.date = Date()
        message.status = kSENT
        
        
        //2-check message type
        
        if text != nil{
            sendText(message:message,text:text!,memberIds:channel.memberIds,channel: channel)
                
            }
            
            if photo != nil{
                sendPhoto(message: message, photo: photo!, memberIds: channel.memberIds,channel: channel)
            }
            
            if video != nil{
                sendVideo(message: message, video: video!, memberIds: channel.memberIds,channel: channel)
            }
            
            if location != nil{
                sendLocation(message: message, memberIds: channel.memberIds,channel: channel)
            }
            
            if audio != nil{
                sendAudio(message: message, audioFileName: audio!, audioDuratian: audioDuration, memberIds: channel.memberIds,channel: channel)
            }
            
            
            //3- save message localy
            //4- save message to firestore
            
            //TODO:- send push notification
        
        channel.lastMessageDate = Date()
        FChannelListener.shared.saveChannel(channel)

    }
        
    
       class func saveMessage(message:LocalMessage,memberIds:[String]){
            
            RealmManager.shared.save(message)
            
            for memberId in memberIds {
                FMessageListener.shared.addMessage(message, memberId: memberId)
            }
            
        }
        


class func saveChannelMessage(message:LocalMessage,channel:Channel){
     
     RealmManager.shared.save(message)
     
    FMessageListener.shared.addChannelMessage(message, channel:channel)
 
}


}



func sendText(message:LocalMessage,text:String,memberIds:[String],channel:Channel? = nil){
    message.message = text
    message.type = kTEXT
    if channel != nil{
        Outgoing.saveChannelMessage(message: message, channel: channel!)
    }else{
        Outgoing.saveMessage(message: message, memberIds: memberIds)
    }
}



func sendPhoto(message:LocalMessage,photo:UIImage,memberIds:[String],channel:Channel? = nil){
    
    message.message = "Photo Message"
    message.type = kPHOTO
    
    
    let fileName = Date().stringDate()
    let fileDirectory = "MediaMessage/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    
    FileStorage.saveFileLocally(fileData: photo.jpegData(compressionQuality: 0.6)! as NSData, fileName: fileName)
    FileStorage.uploadImage(photo, directory: fileDirectory) { (imageUrl) in
        
        if imageUrl != nil{
            message.pictureUrl = imageUrl!
            if channel != nil{
                Outgoing.saveChannelMessage(message: message, channel: channel!)
            }else{
                Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
            
        }
    }
    
    
}



func sendVideo(message:LocalMessage,video:Video,memberIds:[String],channel:Channel? = nil){
    
    message.message = "Video Message"
    message.type = kVIDEO
    
    
    let fileName = Date().stringDate()
    
    let thumnnailDirectory = "MediaMessage/Photo/" + "\(message.chatRoomId)" + "_\(fileName)" + ".jpg"
    let VideoDirectory = "MediaMessage/Video/" + "\(message.chatRoomId)" + "_\(fileName)" + ".mov"
    
    let editor = VideoEditor()
    
    editor.process(video: video) { (processedVideo, videoUrl) in
        
        if let tempPath = videoUrl{
            
            let thembnail = videoThumbnail(videoUrl:tempPath)
            
            FileStorage.saveFileLocally(fileData: thembnail.jpegData(compressionQuality:0.7)! as NSData, fileName: fileName)
            FileStorage.uploadImage(thembnail, directory: thumnnailDirectory) { (imageLink) in
                
                if imageLink != nil{
                    let videoData = NSData(contentsOfFile: tempPath.path)
                    
                    FileStorage.saveFileLocally(fileData: videoData!, fileName: fileName + ".mov")
                    
                    FileStorage.uploadVideo(videoData!, directory: VideoDirectory) { (videoLink) in
                        
                        message.videoUrl = videoLink ?? ""
                        message.pictureUrl = imageLink ?? ""
                        if channel != nil{
                            Outgoing.saveChannelMessage(message: message, channel: channel!)
                        }else{
                            Outgoing.saveMessage(message: message, memberIds: memberIds)
                        }
                    }
                }
                
                
            }
            
        }
    }
    
}


func sendLocation(message:LocalMessage,memberIds:[String],channel:Channel? = nil){
    
    let currentLocation = LocationManager.shared.currentLocation
    
    message.message = "Location Message"
    message.type = kLOCATION
    message.latitude = currentLocation?.latitude ?? 0.0
    message.longitude = currentLocation?.longitude ?? 0.0
    
    if channel != nil{
        Outgoing.saveChannelMessage(message: message, channel: channel!)
    }else{
        Outgoing.saveMessage(message: message, memberIds: memberIds)
    }
}



func sendAudio(message:LocalMessage,audioFileName:String,audioDuratian:Float,memberIds:[String],channel:Channel? = nil){
    
    message.message = "Audio Message"
    message.type = kAUDIO
    let fileDirectory = "MediaMessage/Audio/" + "\(message.chatRoomId)" + "_\(audioFileName)" + ".m4a"
    
    FileStorage.uploadAudio(audioFileName, directory: fileDirectory) { (audioLink) in
        
        if audioLink != nil{
            message.audioUrl = audioLink ?? ""
            message.audioDuration = Double(audioDuratian)
            if channel != nil{
                Outgoing.saveChannelMessage(message: message, channel: channel!)
            }else{
                Outgoing.saveMessage(message: message, memberIds: memberIds)
            }
        }
        
    }
    
}
