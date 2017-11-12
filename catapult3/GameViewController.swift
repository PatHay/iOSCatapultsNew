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

class GameViewController: UIViewController {
    
    @IBOutlet weak var powerUpSlider: UISlider!
    
    //Storyboard Controls
    //--------------------------------
    
    @IBOutlet weak var powerValue: UILabel!
    
    @IBAction func powerValueSlider(_ sender: UISlider) {
//        let value = "\(sender.value)"
        let value = round(Double(Int(sender.value)))
        powerValue.text = String(value)
        
    }
    @IBAction func powerUpSlider(_ sender: UISlider) {
        
//        let value: String!
//            print("\(10,Int(powerValue.text!))")
//        print("This is the power level value \(value)")
//
            calculate()
    }
    
    @IBAction func fireButtonPressed(_ sender: UIButton) {
        print("Fire!")
    }
    
    //--------------------------------
    
    //2nd power slider++++++++++++++++++++++++
    func calculate(){
        if let x = powerValue.text {
            let input = Double(x)
            let powerUp = Double(round(pow(10, powerUpSlider.value)))
            
            let multiply = input! * powerUp
            
            powerValue.text = String(round(multiply))
            
        }
    }
    //++++++++++++++++++++++++
    
    
    var locationManager: CLLocationManager!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        //Heading Information+++++++++++++++++++++++++++++++++
//        
//        locationManager = CLLocationManager()
//        locationManager.delegate = self as? CLLocationManagerDelegate
//        
//        locationManager.startUpdatingHeading()
//        
//        
//        
//        //++++++++++++++++++++++++++++++++++++++++++++++++++++
//        
//        //Heading Information+++++++++++++++++++++++++++++++++
//        func locationManagerChecker(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!){
//            print("Heading information: \(newHeading.magneticHeading) at: \(newHeading.timestamp)")
//        }
//        
//        //++++++++++++++++++++++++++++++++++++++++++++++++++++
        
        
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
    
    
    //below sends data to the next view to calculate the shot
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MapsViewController
        destination.startlong = -122.431297
        destination.startlat = 37.7749
    }
}

