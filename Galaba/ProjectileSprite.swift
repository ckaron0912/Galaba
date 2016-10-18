//
//  ProjectileSprite.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import Foundation
import SpriteKit

class ProjectileSprite: SKSpriteNode{
    
    // MARK - ivars -
    
    // MARK - Initialization -
    init(position: CGPoint){
        let texture = SKTexture(imageNamed: "normal_shot")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "projectile"
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width - 10, height: (self.frame.height / 2) + 10))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.PProjectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.Enemy
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.usesPreciseCollisionDetection = true
        self.zPosition = GameLayer.projectile
    }
    
    required init?(coder aDecoder: NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Methods -
}
