//
//  MapAnnotation.swift
//  Dardesh
//
//  Created by Abdelnasser on 13/10/2021.
//

import Foundation
import MapKit

class MapAnnotation: NSObject,MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    let title : String?
    
    init(title:String?,coordinate:CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
    
}
