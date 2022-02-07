//
//  AudioMessage.swift
//  Dardesh
//
//  Created by Abdelnasser on 14/10/2021.
//

import Foundation
import MessageKit


class AudioMessage: NSObject,AudioItem{
   
    var url: URL
    var duration: Float
    var size: CGSize
    
    init(duration:Float){
        
        self.url = URL(fileURLWithPath: "")
        self.size = CGSize(width: 180, height: 30)
        self.duration = duration
        
    }
    
}
