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
    var health: Int = GameData.upgrades.playerHealth{
        didSet{
            if(GameData.upgrades.playerHealth < 0){
                GameData.upgrades.playerHealth = 0
            }
            if(GameData.upgrades.playerHealth > maxHealth){
                GameData.upgrades.playerHealth = maxHealth
            }
        }
    }
    
    // MARK - Initialization -
    init(){
        let texture = SKTexture(imageNamed: "Spaceship")
        super.init(texture: texture, color: SKColor.clear, size: texture.size())
        
        self.name = "ship"
        self.setScale(0.25)
        
        
        self.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width - 10, height: self.frame.height / 2))
        self.physicsBody?.isDynamic = true
        self.physicsBody?.categoryBitMask = PhysicsCategory.Player
        self.physicsBody?.contactTestBitMask = PhysicsCategory.EProjectile
        self.physicsBody?.collisionBitMask = PhysicsCategory.None
        self.physicsBody?.affectedByGravity = false
        
        self.zPosition = GameLayer.sprite
    }
    
    required init?(coder aDecoder: NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK - Methods -
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
        
        // Shooting sound
        run(SKAction.playSoundFileNamed("laserBlast.wav", waitForCompletion: false))
    }
}

