//
//  ViewController.swift
//  googleintegration
//
//  Created by Chucks Mac Book on 11/10/17.
//  Copyright © 2017 Chucks Mac Book. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation


class MapsViewController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {

    // You don't need to modify the default init(nibName:bundle:) method.
    var targetLong: Double = -79.047150 //Niagara Falls
    var targetLat: Double = 43.092461 //Niagara Falls
    var mView: GMSMapView?
    //current start point-- this will get updated during the didViewLoad
    var homeLong: Double = 37.37 // San Jose
    var homeLat: Double = -128//San jose

    
    var startlong: Double = 00.00
    var startlat: Double = 00.00
    let zm: Float = 15.0
    // gsmarker array
    var arrMarkers = [GMSMarker?]()
    //corelocation
    let manager = CLLocationManager()
    
    var firedLong: Double = 00.00
    var firedlat: Double = 0.00
    //let zm: Float = 15.0
    
//    var locationManager: CLLocationManager!
    
    
    override func loadView() {
        
        //Heading Information+++++++++++++++++++++++++++++++++
        //Heading not working in simulator
        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self as? CLLocationManagerDelegate
//
//        locationManager.startUpdatingHeading()
        
        
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++
        print("Starting Lat = \(startlat)")
        print("Starting Long = \(startlong)")
        //Heading Information+++++++++++++++++++++++++++++++++
        func locationManagerChecker(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!){
            print("Heading information: \(newHeading.magneticHeading) at: \(newHeading.timestamp)")
        }
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++
        //showCamera()
        //startlat = 43.092461
        //startlong = -79.047150
//        print(startlat, startlong, "ADSFASDFSDAAFSD")
        let setTarget = CLLocation(latitude: targetLat, longitude: targetLong)
        let firedLocation = CLLocation(latitude: startlat, longitude: startlong)
        //findout how far we should zoom based upon the fired distance and the target distance
        
        let zoomDistance = returnZoom(target1: setTarget, firedLocation: firedLocation)
        var camera = GMSCameraPosition.camera(withLatitude:  targetLat, longitude: targetLat, zoom: zoomDistance)
        var mapView = GMSMapView.map(withFrame: CGRect(x: 50, y: 50, width: 300, height: 300), camera: camera)
        mapView.isMyLocationEnabled = true
        view = mapView
        mView = mapView
        //        self.view.addSubview(mapView)
        mapView.mapType = .satellite
        mapView.delegate = self
        mapView.isMyLocationEnabled = true
        view = mapView

        
        camera = GMSCameraPosition.camera(withLatitude:  startlat, longitude: startlong, zoom: zoomDistance)
        mapView = GMSMapView.map(withFrame: CGRect(x: 50, y: 50, width: 300, height: 300), camera: camera)
        view = mapView
        mapView.mapType = .satellite
        mapView.delegate = self
        
        let startCL = CLLocationCoordinate2D(latitude: startlat, longitude: startlong)
        let targetCL = CLLocationCoordinate2D(latitude: targetLat, longitude: targetLong)
        dropMarker(latitude: startlat, longitude: startlong, targetIconType: "explosion")
        dropMarker(latitude: targetLat, longitude: targetLong, targetIconType: "target")
        checkDistance(startCL, targetPoint: targetCL)
        
        
        // Do any additional setup after loading the view, typically from a nib.
        manager.delegate = self
        // we want to get the best and accurate data
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // only need to get the husers location when using the app
        manager.requestWhenInUseAuthorization()
        // manager will start updating the location live.
        manager.startUpdatingLocation()
    }

    
    
    func returnZoom(target1: CLLocation, firedLocation: CLLocation)->Float{
        var zoom: Float = 8.0
        
        if getDistanceByPoint(target1, point2: firedLocation) >= 50000 {
            zoom = 3.0
        }else if getDistanceByPoint(target1, point2: firedLocation) < 50000 && getDistanceByPoint(target1, point2: firedLocation) >= 20000{
            zoom = 8.0
        }else if getDistanceByPoint(target1, point2: firedLocation) < 20000 && getDistanceByPoint(target1, point2: firedLocation) >= 10000{
            zoom = 10.0
        }else {
            zoom = 14.0
        }
        
        return zoom
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        //        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        //        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        //        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)
        //        map.setRegion(region, animated: true)
        //        self.map.showsUserLocation = true
        startlong = location.coordinate.longitude
        startlat = location.coordinate.latitude
        
    }
    func checkDistance(_ point1: CLLocationCoordinate2D, targetPoint point2: CLLocationCoordinate2D){
        /// This function is based on the users tap on the screen.  It returns the coordinates.
        //point1 is the start and point 2 is the target
        let location1 = CLLocation(latitude: point1.latitude, longitude: point1.longitude)
        let location2 = CLLocation(latitude: point2.latitude, longitude: point2.longitude)
        let distanceToTarget = getDistanceByPoint(location1, point2: location2)
        if targetLong != 0.0000 {
            // get distance from this click to the target
//            dropMarker(latitude: point1.latitude, longitude: point1.longitude, targetIconType: "explosion")
            
            if distanceToTarget >= 10000.000 {
                print("You're to far")
            } else if distanceToTarget < 10000.000 && distanceToTarget >= 5000.000{
                print("You're getting closer. you're distance : ", String(distanceToTarget))
            } else if distanceToTarget < 5000.000 && distanceToTarget >= 2500.000{
                print("You're super close ", String(distanceToTarget))
            } else {
                print("You hit it. your distance : ", String(distanceToTarget))
            }
            //
            
        } else {
            // set the target where you want
            targetLong = point1.longitude
            targetLat = point1.latitude
//            dropMarker(latitude: targetLat, longitude: targetLong, targetIconType: "target")
        }
        //return distanceToTarget
    }
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        /// This function is based on the users tap on the screen.  It returns the coordinates.
        
        let location1 = CLLocation(latitude: targetLat, longitude: targetLong)// this is the tartget
        let location2 = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude) // this is the chosen target.
        
        if targetLong != 0.0000 {
            // get distance from this click to the target
            dropMarker(latitude: coordinate.latitude, longitude: coordinate.longitude, targetIconType: "explosion")
            let distanceToTarget = getDistanceByPoint(location1, point2: location2)
            if distanceToTarget >= 10000.000 {
                print("You're to far")
            } else if distanceToTarget < 10000.000 && distanceToTarget >= 5000.000{
                print("You're getting closer. you're distance : ", String(distanceToTarget))
            } else if distanceToTarget < 5000.000 && distanceToTarget >= 2500.000{
                print("You're super close ", String(distanceToTarget))
            } else {
                print("You hit it. your distance : ", String(distanceToTarget))
            }
            //
            
        } else {
            // set the target where you want
            targetLong = coordinate.longitude
            targetLat = coordinate.latitude
            dropMarker(latitude: targetLat, longitude: targetLong, targetIconType: "target")
        }
        
    }

    func dropMarker(latitude: Double, longitude: Double, targetIconType: String){
        // Creates a marker in the center of the map.
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //marker.tracksViewChanges = false
        
        if targetIconType == "home" {
            // this will set the intial location
            marker.icon = GMSMarker.markerImage(with: .red)
        } else if targetIconType == "target" {
            // this will set the intial location
            marker.icon = GMSMarker.markerImage(with: .blue)
        }
        else if targetIconType == "explosion" {
            // this is the shot fired
            // adjust the color of the image
            let explosionpng = UIImage(named: "exp2")!.withRenderingMode(.alwaysTemplate)
            let markerView = UIImageView(image: explosionpng)
            markerView.tintColor = .red
            
            if arrMarkers.count != 0 {
                // if there are shots fired, then change color of the previous shots.
                arrMarkers[arrMarkers.count-1]!.iconView?.tintColor = .blue
            }
            marker.iconView = markerView
            arrMarkers.append(marker)
        }
        marker.map = view as! GMSMapView
    }
    
    func getDistanceByPoint(_ point1: CLLocation, point2: CLLocation)-> Double{
        let distance = point1.distance(from: point2)
        return distance
    }
}


