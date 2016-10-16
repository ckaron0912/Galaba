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
    var projectilesFired: Int = 0
    var maxHealth: Int = 100
    var maxProjectiles: Int = 0
    var fireRate: Double = 0.0
    var weaponType = GameData.upgrades.type.none {
        didSet{
            switch weaponType {
            case GameData.upgrades.type.none:
                maxProjectiles = GameData.upgrades.defaultMaxProj
                fireRate = GameData.upgrades.defaultFireRate
                //debugPrint("Switched to Normal Fire")
                break
            case GameData.upgrades.type.rapid:
                maxProjectiles = GameData.upgrades.rapidMaxProj
                fireRate = GameData.upgrades.rapidFireRate
                //debugPrint("Switched to Rapid Fire")
                break
            default:
                break
            }
        }
    }
    var weaponRange: CGFloat = 680.0
    var splitFire: Bool = true
    var isFiring: Bool = false
    
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
        weaponType = GameData.upgrades.type.rapid
    }
    
    required init?(coder aDecoder: NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Methods -
    func update(dt: CGFloat){
        velocity = fwd * delta
        position = position + velocity * dt
    }
    
    func fire(){
        // TODO: Add actual weapon switching -> Timer Todo
        weaponType = GameData.upgrades.type.rapid
        if (isFiring == false || projectilesFired > maxProjectiles) {
            return
        }
        
        if splitFire {
            projectilesFired += 2
            let projectileL = ProjectileSprite(position: CGPoint(x: position.x - 30, y: position.y + 25))
            let projectileR = ProjectileSprite(position: CGPoint(x: position.x + 30, y: position.y + 25))
            self.parent?.addChild(projectileL)
            self.parent?.addChild(projectileR)
            
            let actionMove = SKAction.moveTo(y: position.y + weaponRange, duration: 0.5)
            let actionMoveDone = SKAction.removeFromParent()
            projectileL.run(SKAction.sequence([actionMove, actionMoveDone])){
                self.projectilesFired -= 1
            }
            projectileR.run(SKAction.sequence([actionMove, actionMoveDone])){
                self.projectilesFired -= 1
            }
        } else {
            projectilesFired += 1
            let projectile = ProjectileSprite(position: CGPoint(x: position.x, y: position.y + 25))
            self.parent?.addChild(projectile)
            
            let actionMove = SKAction.moveTo(y: position.y + weaponRange, duration: 0.5)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.run(SKAction.sequence([actionMove, actionMoveDone])){
                self.projectilesFired -= 1
            }
        }
        
    }
}

