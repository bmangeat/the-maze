//
//  ViewController.swift
//  mazeGame
//
//  Created by Brice on 15/05/2019.
//  Copyright © 2019 Brice Mangeat. All rights reserved.
//

import UIKit
import CoreMotion

class FirstLevelController: UIViewController, UIDynamicAnimatorDelegate {

    @IBOutlet weak var ball: UIView!
    @IBOutlet weak var redBtn: UIView!
    @IBOutlet weak var blueBtn: UIView!
    @IBOutlet weak var greenBtn: UIView!
    @IBOutlet weak var cleanBtn: UIView!

    @IBOutlet weak var endBtn: UIView!

    @IBOutlet weak var gateBtn: UIView!
    @IBOutlet weak var gate: UIView!
    @IBOutlet weak var penduleBtn: UIView!
    @IBOutlet weak var pendule: UIView!
    
    @IBOutlet var collectionOfObs: [UIView]!
    
    var motion = CMMotionManager()
    var animator: UIDynamicAnimator? = nil
    var snapGate: UISnapBehavior? = nil
    var snapPendule: UISnapBehavior? = nil

    var walls : UICollisionBehavior? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startDeviceMotion()

        ball.center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        ballStyle()
        styleBtn()
        
        animator = UIDynamicAnimator(referenceView: self.view)
        animator?.delegate = self

        
        
        walls = UICollisionBehavior(items: [ball, gate, pendule] + collectionOfObs)
        
        for i in 0...collectionOfObs.count - 1 {
            let obj = collectionOfObs[i]
            walls!.addBoundary(withIdentifier: "wall_\(i)" as NSString, for: UIBezierPath(rect: obj.frame))
        }
        
        walls!.translatesReferenceBoundsIntoBoundary = true
        walls!.addBoundary(withIdentifier: "endBtn" as NSString, for: UIBezierPath(rect: endBtn.frame))
        walls!.addBoundary(withIdentifier: "redBtn" as NSString, for: UIBezierPath(rect: redBtn.frame))
        walls!.addBoundary(withIdentifier: "blueBtn" as NSString, for: UIBezierPath(rect: blueBtn.frame))
        walls!.addBoundary(withIdentifier: "greenBtn" as NSString, for: UIBezierPath(rect: greenBtn.frame))
        walls!.addBoundary(withIdentifier: "cleanBtn" as NSString, for: UIBezierPath(rect: cleanBtn.frame))
        
        walls!.addBoundary(withIdentifier: "gateBtn" as NSString, for: UIBezierPath(rect: gateBtn.frame))
        walls!.addBoundary(withIdentifier: "penduleBtn" as NSString, for: UIBezierPath(rect: penduleBtn.frame))

        
        walls?.collisionDelegate = self
     
        animator?.addBehavior(walls!)
        
        snapGate = UISnapBehavior(item: gate, snapTo: gate.center)
        animator?.addBehavior(snapGate!)
        snapPendule = UISnapBehavior(item: pendule, snapTo: pendule.center)
        animator?.addBehavior(snapPendule!)

        
//        for obs in collectionOfObs {
//            snap = UISnapBehavior(item: obs, snapTo: obs.center )
//            animator?.addBehavior(snap!)
//        }
        
        
        

        
    }

    
    func startDeviceMotion(){
        if motion.isDeviceMotionAvailable{
            self.motion.deviceMotionUpdateInterval = 1.0/50.0
            self.motion.startDeviceMotionUpdates(using: .xMagneticNorthZVertical, to: OperationQueue.main){
                (d, err) in
                if let d = d {
                    let push = UIPushBehavior(items: [self.ball], mode: .instantaneous)
                    push.pushDirection = CGVector(dx: CGFloat((d.attitude.roll ) / 100),
                                                  dy: CGFloat((d.attitude.pitch) / 100)
                    )
                    self.animator?.addBehavior(push)
                }

            }
            
        }
    }

}

extension FirstLevelController: UICollisionBehaviorDelegate{
    func collisionBehavior(_ behavior: UICollisionBehavior, beganContactFor item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?, at p: CGPoint) {
        if let id = identifier as? NSString {
            print(id)
//            if (id as String) =~ "^wall_" {
//                print("YOLO")
//            }
            if id == "redBtn"{
                if ball.backgroundColor == .white {
                    ball.backgroundColor = .red
                } else if  ball.backgroundColor == .red {
                    ball.backgroundColor = .red
                } else if ball.backgroundColor == .blue {
                    ball.backgroundColor = .magenta
                } else if ball.backgroundColor == .green{
                    ball.backgroundColor = .yellow
                } 
            }
            if id == "greenBtn"{
                if ball.backgroundColor == .white {
                    ball.backgroundColor = .green
                } else if  ball.backgroundColor == .green {
                    ball.backgroundColor = .green
                } else if ball.backgroundColor == .blue {
                    ball.backgroundColor = .cyan
                } else if ball.backgroundColor == .red{
                    ball.backgroundColor = .yellow
                }
            }
            
            if id == "blueBtn"{
                if ball.backgroundColor == .white {
                    ball.backgroundColor = .blue
                } else if  ball.backgroundColor == .blue {
                    ball.backgroundColor = .blue
                } else if ball.backgroundColor == .red {
                    ball.backgroundColor = .magenta
                } else if ball.backgroundColor == .green{
                    ball.backgroundColor = .yellow
                }
            }
            
            if id == "endBtn" && ball.backgroundColor == .magenta {
                performSegue(withIdentifier: "endGame", sender: nil)
            }
            
            if id == "cleanBtn"{
                ball.backgroundColor = .white
            }
            
            if id == "gateBtn"{
                animator?.removeBehavior(snapGate!)
                gate.backgroundColor = .orange
            }
            
            if id == "penduleBtn"{
                animator?.removeBehavior(snapPendule!)
                pendule.backgroundColor = .orange
            }
            
        }
    }
}

infix operator =~
extension String {
    static func =~(string:String, regex:String) -> Bool {
        if let r = try? NSRegularExpression(pattern: regex, options: []) {
            return r.numberOfMatches(in: string, options: [], range: NSMakeRange(0, (string.count) - 1)) > 0
        }
        
        return false
    }
}

extension FirstLevelController{
    func ballStyle(){
        ball.layer.cornerRadius = ball.frame.width / 2
        ball.backgroundColor = .white
    }
    
    func styleBtn(){
        cleanBtn.layer.borderColor = UIColor.white.cgColor
        cleanBtn.layer.borderWidth = 2
        cleanBtn.layer.cornerRadius = cleanBtn.frame.width / 2
        
        redBtn.layer.borderColor = UIColor.white.cgColor
        redBtn.layer.borderWidth = 2
        redBtn.layer.cornerRadius = redBtn.frame.width / 2
        
        blueBtn.layer.borderColor = UIColor.white.cgColor
        blueBtn.layer.borderWidth = 2
        blueBtn.layer.cornerRadius = blueBtn.frame.width / 2
        
        greenBtn.layer.borderColor = UIColor.white.cgColor
        greenBtn.layer.borderWidth = 2
        greenBtn.layer.cornerRadius = greenBtn.frame.width / 2
    }
    
}
