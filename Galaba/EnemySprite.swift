//
//  EnemySprite.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
import SpriteKit

class EnemySprite: SKSpriteNode{
    
    // MARK - ivars -
    var fwd: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var velocity: CGPoint = CGPoint.zero
    var delta: CGFloat = GameData.scene.enemySpeed + GameData.scene.enemySpeedIncrease
    var hit: Bool = false
    
    // MARK - Initialization -
    init(){
        let texture = SKTexture(imageNamed: "enemy")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "enemy"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width - 10, height: self.frame.height / 2))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Enemy
        self.physicsBody?.contactTestBitMask = PhysicsCategory.PProjectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.affectedByGravity = false
        
        self.zPosition = GameLayer.sprite
        
        //need a better solution for this, sprites can be off screen for a very long time
        self.fwd = CGPoint.randomUnitVector()
        
        if(fwd.y > 0){
            
            reflectY()
        }
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
    //need to figure out why this crashed when called within this class
    /*private func randInRange(min: Int, max: Int) -> Int{
     
     return Int(arc4random_uniform(UInt32(max - min)) + UInt32(min))
     }*/
}
