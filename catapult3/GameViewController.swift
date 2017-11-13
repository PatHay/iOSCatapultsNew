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

class GameViewController: UIViewController {
    
    @IBOutlet weak var powerUpSlider: UISlider!
    
    @IBOutlet weak var basePower: UISlider!

    
    @IBOutlet weak var powerValue: UILabel!
    
    
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
        print("Fire!")
    }

    //exponential increase in power calculator
    func calculate(){
        if powerValue.text != nil {
            let base = Double(round(basePower.value))
            let powerUp = Double(round(pow(10, powerUpSlider.value)))
            
            let multiply = base * powerUp
            
            powerValue.text = String(round(multiply))
            
        }
    }
    //--------------------------------

    
    
    var locationManager: CLLocationManager!
    
    var audioPlayer = AVAudioPlayer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    
    //below sends data to the next view to calculate the shot
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! MapsViewController
        destination.startlong = -122.431297
        destination.startlat = 37.7749
    }
}

