//
//  GameViewController.swift
//  catapult3
//
//  Created by Patrick Hayes on 11/11/17.
//  Copyright © 2017 Patrick Hayes. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import GoogleMaps
import AVFoundation

class GameViewController: UIViewController{
    
    @IBOutlet weak var powerUpSlider: UISlider!
    
    @IBOutlet weak var basePower: UISlider!
    
    
    @IBOutlet weak var powerValue: UILabel!
    
    var currentLat: Double? = 37.773972 //San Francisco
    var currentLong: Double? = -122.431297 //San Francisco
    var angle: Double? = 79.00 //randomly chosen
    var distance: Double? = 0
    
    var targetLat: Double? = 0
    var targetLong: Double? = 0
    
    
    //Storyboard Controls
    //--------------------------------
    //Base power bar
    @IBAction func powerValueSlider(_ sender: UISlider) {
//        let value = "\(sender.value)"
        let value = round(Double(Int(basePower.value)))
        powerValue.text = String(value)
        
        calculate()
        
    }
    
    //2nd power slider++++++++++++++++++++++++
    @IBAction func powerUpSlider(_ sender: UISlider) {
        calculate()
    }
    
    @IBAction func fireButtonPressed(_ sender: UIButton) {
        distanceCalc()
        print("Fire!")
    }

    //exponential increase in power calculator
    func calculate(){
        if powerValue.text != nil {
            let base = Double(round(basePower.value))
            let powerUp = Double(round(pow(10, powerUpSlider.value)))
            
            let multiply = base * powerUp
            
            distance = round(multiply)
            powerValue.text = String(round(multiply))
            
        }
    }
    //--------------------------------

    
    
    var locationManager: CLLocationManager!
    
    var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        var delegate: TargetDelegate?
        //Music player Start++++++++++++++
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL.init(fileURLWithPath: Bundle.main.path(forResource: "PiratesMainTheme", ofType: "mp3")!))
            audioPlayer.prepareToPlay()
            audioPlayer.play()
        } catch {
            print(error)
        }
        
        //++++++++++++++++++++++++++++++++++++++++++
        
        
        //Heading Information+++++++++++++++++++++++++++++++++
        
        locationManager = CLLocationManager()
        locationManager.delegate = self as? CLLocationManagerDelegate
        
        locationManager.startUpdatingHeading()
        
        
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        //Heading Information+++++++++++++++++++++++++++++++++
        func locationManagerChecker(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!){
            print("Heading information: \(newHeading.magneticHeading) at: \(newHeading.timestamp)")
        }
        
        //++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {
            
            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {
                
                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs
                
                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill
                
                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)
                    
                    view.ignoresSiblingOrder = true
                    
                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    func distanceCalc(){
        let earthRadius = 6378140.00 // in meters
        
        //degrees to radians
        let lat1 = currentLat! * (M_PI/180)
        let long1 = currentLong! * (M_PI/180)
        let brng = angle! * (M_PI/180)
        
        let latCalc1 = sin(lat1)*cos(distance!/earthRadius)
        let latCalc2 = cos(lat1)*sin(distance!/earthRadius)*cos(brng)
        
        var lat2 = asin(latCalc1 + latCalc2)
        
        let longCalc1 = sin(brng)*sin(distance!/earthRadius)*cos(lat1)
        let longCalc2 = cos(distance!/earthRadius)-sin(lat1)*sin(lat2)
        var long2 = long1 + atan2(longCalc1, longCalc2)
        
        //radians to degrees
        lat2 = lat2*(180/M_PI)
        long2 = long2*(180/M_PI)
        
        //6 decimal point for coords
        
//        print(floor(lat2 * 1000000)/1000000)
//        print(floor(long2 * 1000000)/1000000)
        
        targetLat = floor(lat2 * 1000000)/1000000
        targetLong = floor(long2 * 1000000)/1000000
        
    }
    
    //below sends data to the next view to calculate the shot
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MapsViewController
        destination.startlong = targetLong!
        destination.startlat = targetLat!
        

    }
}

