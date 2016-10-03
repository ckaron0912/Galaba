//
//  DiamondSprite.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
import SpriteKit

class ProjectileSprite: SKSpriteNode{
    
    // MARK - ivars -
    var fwd: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var velocity: CGPoint = CGPoint.zero
    var delta: CGFloat = 300.0
    var hit: Bool = false
    
    // MARK - Initialization -
    init(){
        let texture = SKTexture(imageNamed: "normal_shot")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "projectile"
        
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width - 10, height: (self.frame.height / 2) + 10))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.PProjectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.zPosition = GameLayer.projectile
        
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
    
    func reflectX(){
        
        fwd.x *= CGFloat(-1.0)
    }
    
    func reflectY(){
        
        fwd.y *= CGFloat(-1.0)
    }
}
