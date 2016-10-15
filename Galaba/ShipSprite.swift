//
//  ShipSprite.swift
//  Galaba
//
//  Created by student on 10/15/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
import SpriteKit

class ShipSprite: SKSpriteNode{
    
    // MARK - ivars -
    var fwd: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var velocity: CGPoint = CGPoint.zero
    var delta: CGFloat = 100.0
    var hit: Bool = false
    var fireRate: Int = 2
    var projectilesFired: Int = 0
    var maxHealth: Int = 100
    var splitFire: Bool = false
    struct upgrades{}
    
    var health: Int = 100{
        
        didSet{
            
            if(health < 0){
                
                health = 0
            }
            
            if(health > maxHealth){
                
                health = maxHealth
            }
        }
    }
    
    // MARK - Initialization -
    init(){
        
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "ship"
        self.setScale(0.25)
        self.zPosition = GameLayer.sprite
    }
    
    required init?(coder aDecoder: NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Methods -
    func update(dt: CGFloat){
        
        velocity = fwd * delta
        position = position + velocity * dt
    }
    
    func fire(playableRect: CGRect){
        
        
    }
}

