//
//  Extention.swift
//  Dardesh
//
//  Created by Abdelnasser on 03/10/2021.
//

import Foundation
import  UIKit

extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}



extension Date{
    func longDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyy"
        return dateFormatter.string(from:self)
    }
    
    
    func stringDate()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmmss"
        return dateFormatter.string(from:self)
    }
    
    
    func time()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from:self)
    }
    
    
    func interval (ofComponent camp:Calendar.Component,to date:Date)->Float{
        
        let currentCalunder = Calendar.current
        
        guard let end = currentCalunder.ordinality(of: camp, in: .era, for: date) else{return 0}
        
        guard let start = currentCalunder.ordinality(of: camp, in: .era, for: self) else{return 0}
        
        return Float(end-start)
    }
}
