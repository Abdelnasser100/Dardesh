//
//  PhotoMessage.swift
//  Dardesh
//
//  Created by Abdelnasser on 11/10/2021.
//

import Foundation
import MessageKit

class PhotoMessage: NSObject,MediaItem {
    var url: URL?
    
    var image: UIImage?
    
    var placeholderImage: UIImage
    
    var size: CGSize
    
    init(path:String) {
        self.url = URL(fileURLWithPath: path)
        self.placeholderImage = UIImage(named: "icon")!
        self.size = CGSize(width: 240, height: 240)
    }
    
    
}
