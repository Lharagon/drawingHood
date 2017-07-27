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
    var motionManager: CMMotionManager?
    var myQ: OperationQueue? = nil
    var MGMT: CMMotionManager?
    var touched = false
    var timer = Timer()
    var currentColor = UIColor.black
    
    @IBOutlet weak var currentChosenColor: UILabel!
    
    
    @IBAction func onRealRelease(_ sender: UIButton) {
        touched = false
        timer.invalidate()
        if let manager = motionManager {
            manager.stopDeviceMotionUpdates()
        }
        
        
        
    }
    
    
    
    @IBAction func resetFunc(_ sender: UIButton) {
        permView.image = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        motionManager = CMMotionManager()
        if let manager = motionManager {
            MGMT = manager
            print("We have a motion manager")
            if manager.isDeviceMotionAvailable {
                print("We can detect device motion!")
                myQ = OperationQueue()
                manager.deviceMotionUpdateInterval = 0.07
            } else {
                let alert = UIAlertController(title: "Drawing", message: "Your device does not have the necessary sensors. You might want to try on another device.", preferredStyle: .alert)
                present(alert, animated: true, completion: nil)
                print("We can not detect device motion!")
            }
        } else {
            print("We do not have a motion manager")
        }
        currentChosenColor.backgroundColor = currentColor
    }
    
    @IBAction func colorChange(_ sender: UIButton) {
        currentColor = sender.backgroundColor!
        currentChosenColor.backgroundColor = currentColor
    }

    
    @IBAction func onRelease(_ sender: UIButton) {
        touched = true
        MGMT!.startDeviceMotionUpdates(to: myQ!, withHandler: {
            (data: CMDeviceMotion?, error: Error?) in
            if let mydata = data {
                print("My pitch ", mydata.attitude.pitch)
                print("My roll ", mydata.attitude.roll)
                let thisPitch = self.degrees(radians: mydata.attitude.pitch * 5) + 300
                let thisRoll = self.degrees(radians: mydata.attitude.roll * 2.5) + 200
                let currentPoint = CGPoint(x: thisRoll, y: thisPitch)
                print(currentPoint)
                self.lastPoint = currentPoint
                DispatchQueue.main.async {
                    self.drawLines(fromPoint: currentPoint, toPoint: self.lastPoint)
                }
                }
            if let myerror = error {
                print("myError", myerror)
                self.MGMT!.stopDeviceMotionUpdates()
            }
        })
    }
   
    func degrees(radians:Double) -> Double {
        return (180/Double.pi) * radians
    }
    
    @IBOutlet weak var permView: UIImageView!
    var lastPoint = CGPoint.zero
//    var red: CGFloat = 0.0
//    var green: CGFloat = 0.0
//    var blue: CGFloat = 0.0
//    var brushWidth: CGFloat = 10.0
//    var opacity: CGFloat = 1.0
//    var swiped = false
    
//    let colors: [(CGFloat, CGFloat, CGFloat)] = [(0,0,0)]
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = false
//        if let touch = touches.first {
//            lastPoint = touch.location(in: self.view)
//        }
//    }
    
     @objc func drawLines(fromPoint: CGPoint, toPoint: CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        permView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        print (fromPoint, " and ", toPoint)
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(15)
        context?.setStrokeColor(currentColor.cgColor)
        
        context?.strokePath()
        permView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        swiped = true
//        if let touch = touches.first {
//            let currentPoint = touch.location(in: self.view)
//            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
//            
//            lastPoint = currentPoint
//        }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if !swiped {
//            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
//        }
//    }

    
//    let interval = 0.5
    
//    func isDevicesAvailable() -> Bool {
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
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    


}

