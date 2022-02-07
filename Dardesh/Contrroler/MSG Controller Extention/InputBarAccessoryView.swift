//
//  InputBarAccessoryView.swift
//  Dardesh
//
//  Created by Abdelnasser on 09/10/2021.
//

import Foundation
import InputBarAccessoryView

extension MSGViewController:InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
       // print("Typing",text)
        updateMicButtonStatus(show: text == "")
        
        if text != ""
        {
            startTypingIndecator()
        }
        
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
}


//Channel

extension ChannelMessageViewController:InputBarAccessoryViewDelegate{
    
    func inputBar(_ inputBar: InputBarAccessoryView, textViewTextDidChangeTo text: String) {
        print("Typing",text)
        updateMicButtonStatus(show: text == "")
        
//        if text != ""
//        {
//            startTypingIndecator()
//        }
        
    }
    
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        
        send(text: text, photo: nil, video: nil, audio: nil, location: nil)
        
        messageInputBar.inputTextView.text = ""
        messageInputBar.invalidatePlugins()
    }
    
}

