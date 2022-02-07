//
//  MessagesLayoutDelegate.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import MessageKit

extension MSGViewController:MessagesLayoutDelegate{
    
    //MARK: - Cell top label hight
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section%3 == 0{

            if ((indexPath.section == 0) && (allLocalMessages.count > displaingMessageCount)){
                return 40
            }
        }
            return 10
        
    }
    
    
    //MARK: - Cell bottom label hight
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return isFromCurrentSender(message: message) ? 17 : 0
    }
    
    
    //MARK: - message bottom hight
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return indexPath.section != mkMessages.count-1 ? 10:0
    }
 
    
    //MARK: - Avatar initials
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
    
}


//Channel

extension ChannelMessageViewController:MessagesLayoutDelegate{
    
    //MARK: - Cell top label hight
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        if indexPath.section%3 == 0{

            if ((indexPath.section == 0) && (allLocalMessages.count > displaingMessageCount)){
                return 40
            }
        }
            return 10
        
    }
    
    
    //MARK: - Cell bottom label hight
    
//    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
//        return isFromCurrentSender(message: message) ? 17 : 0
//    }
//
    
    //MARK: - message bottom hight
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 10
    }
 
    
    //MARK: - Avatar initials
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.set(avatar: Avatar(initials: mkMessages[indexPath.section].senderInitials))
    }
    
}

