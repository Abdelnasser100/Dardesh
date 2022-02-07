//
//  LocationManager.swift
//  Dardesh
//
//  Created by Abdelnasser on 12/10/2021.
//

import Foundation
import CoreLocation

class LocationManager: NSObject,CLLocationManagerDelegate {
    
    static var shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    private override init(){
        super.init()
        requestLocationAccess()
    }
    
    
    func requestLocationAccess(){
        
        if locationManager == nil{
            locationManager = CLLocationManager()
            locationManager!.delegate = self
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            
        }else{
            print("We have already location manager")
        }
    }
    
    
    func startUpdating(){
        
        locationManager!.startUpdatingLocation()
    }
    
    func stopUpdating(){
        
        locationManager!.stopUpdatingLocation()
    }
    
    
    //MARK: - Delegete Function
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLocation = locations.last!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        
        print("faild to get location",error!.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        if manager.authorizationStatus == .notDetermined{
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
    
}
