//
//  VideoMessage.swift
//  Dardesh
//
//  Created by Abdelnasser on 12/10/2021.
//

import Foundation
import MessageKit

class VideoMessage: NSObject,MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(url:URL?) {
        self.url = url
        self.placeholderImage = UIImage(named: "icon")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
