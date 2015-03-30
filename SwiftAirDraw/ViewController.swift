//
//  ViewController.swift
//  SwiftAirDraw
//
//  Created by Daniel Runkles on 6/4/14.
//  Copyright (c) 2014 Thinking Spastic Studios. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
                            
    @IBOutlet var xLabel : UILabel!
    @IBOutlet var yLabel : UILabel!
    @IBOutlet var zLabel : UILabel!
    
    let motion = CMMotionManager()
    
    let refRect = CGRectMake(80, 180, 40, -10)
    var rectViewX : UIView = UIView()
    var rectViewY : UIView = UIView()
    var rectViewZ : UIView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        motion.gyroUpdateInterval = 0.2
        motion.accelerometerUpdateInterval = 0.2
        
        
        rectViewX = UIView(frame: refRect)
        
        rectViewX.backgroundColor = UIColor.blueColor()
        
        rectViewY = UIView(frame: CGRectMake(rectViewX.frame.origin.x + rectViewX.frame.size.width + 20, refRect.origin.y, 40.0, -10.0))
        rectViewY.backgroundColor = UIColor.blueColor()
        
        rectViewZ = UIView(frame: CGRectMake(rectViewY.frame.origin.x + rectViewY.frame.size.width + 20, refRect.origin.y, 40.0, -10.0))
        rectViewZ.backgroundColor = UIColor.blueColor()
        
        view.addSubview(rectViewX); view.addSubview(rectViewY); view.addSubview(rectViewZ)
        
        let blackLineImageView : UIImageView = UIImageView(image: self.createBlackLine())
        blackLineImageView.frame = CGRectMake(refRect.origin.x - 30, refRect.origin.y, 220, 1)
        view.addSubview(blackLineImageView)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func aDumbMethod(rotation: CMRotationRate) {
        xLabel.text = "\(rotation.x)"
        yLabel.text = "\(rotation.y)"
        zLabel.text = "\(rotation.z)"
        
        UIView.animateWithDuration(0.2, animations: {()
                self.rectViewX.frame = CGRectMake(self.refRect.origin.x, self.refRect.origin.y, self.refRect.size.width, CGFloat(-rotation.x * 30.0))
                self.rectViewY.frame = CGRectMake(self.rectViewX.frame.origin.x + self.rectViewX.frame.size.width + 20.0, self.refRect.origin.y, self.refRect.size.width, CGFloat(-rotation.y * 30.0))
                self.rectViewZ.frame = CGRectMake(self.rectViewY.frame.origin.x + self.rectViewY.frame.size.width + 20.0, self.refRect.origin.y, self.refRect.size.width, CGFloat(-rotation.z * 30.0))
            })
    }
    
    func changeBackgroundColorOnAccel(acceleration: CMAcceleration) {
        var maxAcceleration = max(acceleration.x, acceleration.y, max(acceleration.y, acceleration.z))
        
        UIView.animateWithDuration(0.2, animations: {()
            self.view.backgroundColor = UIColor(red: 1.0, green: CGFloat(1.0 - (maxAcceleration * 1.5)), blue: CGFloat(1.0 - (maxAcceleration * 1.5)), alpha: 1.0)
        
            })
    }
    
    func createBlackLine() -> UIImage {
        
        UIGraphicsBeginImageContext(CGSizeMake(220, 1.0))
            let blackLinePath = UIBezierPath()
            blackLinePath.moveToPoint(CGPointMake(0.0, 0.0))
            blackLinePath.addLineToPoint(CGPointMake(220.0, 0.0))
            blackLinePath.lineWidth = 1
            UIColor(red: 1.0, green: 0.9, blue: 0.6, alpha: 1.0).setStroke()
            blackLinePath.stroke()
            let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }

    @IBAction func startButton(sender : AnyObject) {
        motion.startGyroUpdatesToQueue(NSOperationQueue.mainQueue(), withHandler: {(gyroData: CMGyroData!, error: NSError!) in self.aDumbMethod(gyroData.rotationRate) })
        motion.startAccelerometerUpdatesToQueue(NSOperationQueue .mainQueue(), withHandler: {(accelData: CMAccelerometerData!, error: NSError!) in self.changeBackgroundColorOnAccel(accelData.acceleration) })
    }
    
    @IBAction func stopButton(sender : AnyObject) {
    
        let queue = NSOperationQueue.mainQueue()
        
        queue.addOperationWithBlock({()
        
            self.motion.stopGyroUpdates()
            self.motion.stopAccelerometerUpdates()
        })
    }
    

}

