//
//  ViewController.swift
//  drawing
//
//  Created by Luis Garcia on 7/6/17.
//  Copyright © 2017 GT. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    
    
    @IBAction func beginPaint(_ sender: UIButton) {
        
        
    }
    @IBOutlet weak var permView: UIImageView!
    
    var lastPoint = CGPoint.zero
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    
//    let colors: [(CGFloat, CGFloat, CGFloat)] = [(0,0,0)]
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
        }
    }
    func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        permView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        print (fromPoint, " and ", toPoint)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(5)
        context?.setStrokeColor(UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor)
        
        context?.strokePath()
        permView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        swiped = true
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
    }
    
    var motionManager: CMMotionManager?
//    let interval = 0.5
    
//    func isDevicesAvailable() -> Bool {
//        let gyroAvailable = motionManager.isGyroAvailable
//        let accelAvailable = motionManager.isAccelerometerAvailable
//        if !motionManager.isDeviceMotionAvailable {
//            let alert = UIAlertController(title: "Drawing", message: "Your device does not have the necessary sensors. You might wat to try on another device.", preferredStyle: .alert)
//            present(alert, animated: true, completion: nil)
//            print("Devices not detected")
//        }
//        return motionManager.isDeviceMotionAvailable
//    }
    
//    func myDeviceMotion() {
//        motionManager.startDeviceMotionUpdates(to: <#T##OperationQueue#>, withHandler: <#T##CMDeviceMotionHandler##CMDeviceMotionHandler##(CMDeviceMotion?, Error?) -> Void#>)
//    }
//    
    
        
        
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        if isDevicesAvailable() {
//            print("Core Motion Launched")
//        }
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
//          THESE ARE THE CODES THAT I REMOVED IN ORDER TO MAKE DRAW APP
        motionManager = CMMotionManager()
        if let manager = motionManager {
            print("We have a motion manager")
            if manager.isDeviceMotionAvailable {
                print("We can detect device motion!")
            } else {
                print("We can not detect device motion!")
            }
        } else {
            print("We do not have a motion manager")
        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

