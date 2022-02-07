//
//  GlobalFunction.swift
//  Dardesh
//
//  Created by Abdelnasser on 03/10/2021.
//

import Foundation
import  UIKit
import AVFoundation

func fileNameFrom(fileUrl:String)->String{
    let name = fileUrl.components(separatedBy: "-").last
    
    let name1 = name?.components(separatedBy: "?").first
    let name2 = name?.components(separatedBy: ".").first
    
    return name2!
}


func timeElapsed(_ date:Date)->String{
    let seconde = Date ().timeIntervalSince(date)
    var elapsed = ""
    
    if seconde < 60{
        elapsed = "just now"
    }
    else if seconde < 60*60 {
        let minutes = Int(seconde/60)
        let minText = minutes > 1 ? "mins" : "min"
        elapsed = "\(minutes) \(minText)"
    }
    else if seconde < 24*60*60{
        let hours = Int(seconde/(60*60))
        let hourText = hours > 1 ? "hours" : "hour"
        elapsed = "\(hours) \(hourText)"
    }
    else{
        elapsed = "\(date.longDate())"
    }
    return elapsed
    
}



func videoThumbnail(videoUrl: URL) -> UIImage {
    do {
        let asset = AVURLAsset(url: videoUrl, options: nil)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        imgGenerator.appliesPreferredTrackTransform = true
        let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
        let thumbnail = UIImage(cgImage: cgImage)
        return thumbnail
    } catch let error {
        print("*** Error generating thumbnail: \(error.localizedDescription)")
        return UIImage(named: "icon")!
    }
}

