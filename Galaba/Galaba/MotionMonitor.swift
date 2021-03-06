//
//  MotionMonitor.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
import CoreMotion
import CoreGraphics

class MotionMonitor{
    
    static let sharedMotionMonitor = MotionMonitor()
    let manager = CMMotionManager()
    var rotation: CGFloat = 0
    var gravityVectorNormalized = CGVector.zero
    var gravityVector = CGVector.zero
    
    private init() {}
    
    func startUpdates(){
        
        if manager.isDeviceMotionAvailable{
            
            print("** starting motion updates")
            manager.deviceMotionUpdateInterval = 0.1
            manager.startDeviceMotionUpdates(to: OperationQueue.main){
                
                data, error in
                guard data != nil else{
                    
                    print("There was an error: \(error)")
                    return
                }
                
                self.rotation = CGFloat(atan2(data!.gravity.x, data!.gravity.y)) - (CGFloat.pi / 2)
                self.gravityVectorNormalized = CGVector(dx: CGFloat(data!.gravity.x), dy: CGFloat(data!.gravity.y))
                self.gravityVector = CGVector(dx: CGFloat(data!.gravity.x), dy: CGFloat(data!.gravity.y)) * 9.8
                
                //print("self.rotation = \(self.rotation)")
                //print("self.gravityVectorNormalized = \(self.gravityVectorNormalized)")
            }
        } else{
            
            print("Device Motion is not available! Are you on the simulator?")
        }
    }
    
    func stopUpdates(){
        
        print("** stopping motion updates **")
        
        if manager.isDeviceMotionAvailable{
            
            manager.stopDeviceMotionUpdates()
        }
    }
}
