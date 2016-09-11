//
//  ViewController.swift
//  vulcanDetector
//
//  Created by Park Seyoung on 11/09/16.
//  Copyright © 2016 Park Seyoung. All rights reserved.
//

import UIKit
import CoreMotion

class VulcanDetectorController: UIViewController {
    
    lazy var motionManager = CMMotionManager()
    
    var accelerationDataHolder: CMAcceleration?
    
    var faceView: UIImageView!
    var faceStatus = VibrationStatus.Steady
    var timeIntervalAtEarthquake: NSTimeInterval?
    
    private func didShake(old: CMAcceleration?, new: CMAcceleration) -> Bool {
        guard let old = old else {
            accelerationDataHolder = new
            return false }
        let diff = abs(old.x - new.x) + abs(old.y - new.y) + abs(old.z - new.z)
        
        return diff > 1
    }
    
    private func isFaceUpdatableBackToSteady() -> Bool {
        guard let old = timeIntervalAtEarthquake else { return true }
        let new = NSDate().timeIntervalSince1970
        let diff = new - old
        return diff > 1
    }
    
    private func updateFace(status: VibrationStatus) {
        guard faceStatus != status else { return }
        print("New image! \t \(status.rawValue)")
        let image = UIImage(named: status.rawValue)
        faceView.image = image
        faceStatus = status
    }
    
    private func printAcceleration(data: CMAcceleration){
        if didShake(accelerationDataHolder, new: data) {
            accelerationDataHolder = data
            timeIntervalAtEarthquake = NSDate().timeIntervalSince1970
            print("X = \(data.x)\t Y = \(data.y)\t Z = \(data.z)")
            updateFace(.Earthquake)
        } else if isFaceUpdatableBackToSteady() {
            //            print("updateFace(.Steady)")
            updateFace(.Steady)
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        loadFaceImage()
        loadMotionManager()
        
    }
    
    private func loadMotionManager() {
        motionManager.accelerometerUpdateInterval = 1.0 / 30
        
        if motionManager.accelerometerAvailable{
            /// UI elements can be only updated in main queue
            /// Recommend: let queue = NSOperationQueue()
            let queue = NSOperationQueue.mainQueue()
            
            /// Load queue
            motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
                {data, error in
                    
                    guard let data = data else{
                        return
                    }
                    
                    self.printAcceleration(data.acceleration)
                    
                }
            )
        } else {
            print("Accelerometer is not available")
        }
    }
    
    private func loadFaceImage() {
        let faceImage = UIImage(named: VibrationStatus.Steady.rawValue)
        let x = (view.bounds.width - faceImage!.size.width) / 2
        let y = (view.bounds.height - faceImage!.size.height) / 2
        let frame = CGRectMake(
            x, y, faceImage!.size.width, faceImage!.size.height)
        faceView = UIImageView(image: faceImage)
        faceView.frame = frame
        
        view.addSubview(faceView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

