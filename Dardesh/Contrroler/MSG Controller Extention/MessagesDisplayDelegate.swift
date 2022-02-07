//
//  MessagesDisplayDelegate.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import  MessageKit

extension MSGViewController :MessagesDisplayDelegate{
    
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .label
    }
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorOutgoing = UIColor(named: "Color OutGoing")
        let bubbleColorIncoming = UIColor(named: "Color inComing")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing!: bubbleColorIncoming!
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
    
}


//Channel


extension ChannelMessageViewController :MessagesDisplayDelegate{
    
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        return .label
    }
    
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        
        let bubbleColorOutgoing = UIColor(named: "Color OutGoing")
        let bubbleColorIncoming = UIColor(named: "Color inComing")
        
        return isFromCurrentSender(message: message) ? bubbleColorOutgoing!: bubbleColorIncoming!
    }
    
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail : MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
    
}
