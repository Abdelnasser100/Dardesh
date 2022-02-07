//
//  MapViewController.swift
//  Dardesh
//
//  Created by Abdelnasser on 13/10/2021.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    var location : CLLocation?
    var mapView:MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureMapView()
        configureLiftBarButton()
        
        self.title = "Map View"
        
        // Do any additional setup after loading the view.
    }
    
    
    
     private func configureMapView(){
        
        mapView = MKMapView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        
        mapView?.showsUserLocation = true
        
        if location != nil{
            mapView?.setCenter(location!.coordinate,animated:false)
            
            mapView?.addAnnotation(MapAnnotation(title: "User Location", coordinate: location!.coordinate))
        }
        view.addSubview(mapView!)
    }

    
    private func configureLiftBarButton(){
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(self.backButtonPressed))
        
    }
    
    
    @objc func backButtonPressed(){
        self.navigationController?.popViewController(animated: true)
    }
    

}
