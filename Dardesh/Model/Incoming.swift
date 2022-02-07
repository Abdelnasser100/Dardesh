//
//  Incoming.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import  MessageKit
import CoreLocation

class Incoming{
    var messageViewController:MessagesViewController
    
    init(messageViewController:MessagesViewController){
        self.messageViewController = messageViewController
    }
    
    func createMKMessage(localMessage:LocalMessage)->MKMessage{
        let mkMessage = MKMessage(message: localMessage)
        
        if localMessage.type == kPHOTO{
            
            let photoItem = PhotoMessage(path: localMessage.pictureUrl)
            mkMessage.photoItem = photoItem
            mkMessage.kind = MessageKind.photo(photoItem)
            
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (image) in
                mkMessage.photoItem?.image = image
                self.messageViewController.messagesCollectionView.reloadData()
            }
        }
        
        
        if localMessage.type == kVIDEO{
            
            FileStorage.downloadImage(imageUrl: localMessage.pictureUrl) { (thumbnail) in
                FileStorage.downloadVideo(videoUrl: localMessage.videoUrl) { (readyToPlay, fileName) in
                    
                    let videoLink = URL(fileURLWithPath: fileInDecomentDirectory(fileName: fileName))
                    let videoItem = VideoMessage(url: videoLink)
                    
                    mkMessage.videoItem = videoItem
                    mkMessage.kind = MessageKind.video(videoItem)
                    
                    mkMessage.videoItem?.image = thumbnail
                    self.messageViewController.messagesCollectionView.reloadData()
                    
                }
            }
           
            
        }
        
        
        if localMessage.type == kLOCATION{
            
            let loctionItem = LocationMessage(location: CLLocation(latitude:localMessage.latitude,longitude:localMessage.longitude))
            
            mkMessage.kind = MessageKind.location(loctionItem)
            mkMessage.locationItem = loctionItem
            
        }
        
        
        if localMessage.type == kAUDIO{
            
            let audioMessage = AudioMessage(duration: Float(localMessage.audioDuration))
            
            mkMessage.audioItem = audioMessage
            mkMessage.kind = MessageKind.audio(audioMessage)
            
            FileStorage.downloadAudio(audioUrl: localMessage.audioUrl) { (fileName) in
                
                let audioUrl = URL(fileURLWithPath: fileInDecomentDirectory(fileName: fileName))
                mkMessage.audioItem?.url = audioUrl
                
            }
            self.messageViewController.messagesCollectionView.reloadData()
            
        }
        
        
        return mkMessage
    }
    
}
