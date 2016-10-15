//
//  GameScene.swift
//  Galaba
//
//  Created by student on 9/20/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let None             : UInt32 = 0
    static let All              : UInt32 = UInt32.max
    static let Enemy            : UInt32 = 0b1        // 1
    static let PProjectile      : UInt32 = 0b10       // 2
    static let Player           : UInt32 = 0b100      // 4
    static let EProjectile      : UInt32 = 0b1000     // 8
    static let AllProjectiles   : UInt32 = 0b1010
}

struct GameLayer {
    static let background: CGFloat = 0
    static let projectile: CGFloat = 1
    static let sprite    : CGFloat = 2
    static let hud       : CGFloat = 3
    static let message   : CGFloat = 4
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ship: ShipSprite
    var playableRect = CGRect.zero
    var tapCount = 0
    var totalSprites: Int = 0 {
        
        willSet(numSprites){
            
            otherLabel.text = "Enemies left \(numSprites)"
        }
    }
    var levelNum: Int
    var levelScore: Int = 0 {
        
        willSet(score){
            
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var totalScore: Int
    var credits: Int
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    
    let sceneManager:GameViewController
    
    let levelLabel = SKLabelNode(fontNamed: "Futura")
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let otherLabel = SKLabelNode(fontNamed: "Futura")
    let healthLabel = SKLabelNode(fontNamed: "Futura")
    let creditsLabel = SKLabelNode(fontNamed: "Futura")
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, levelNum:Int, totalScore:Int, sceneManager:GameViewController){
        
        self.ship = ShipSprite()
        ship.fireRate = GameData.upgrades.playerFireRate
        ship.maxHealth = GameData.upgrades.playerMaxHealth
        ship.splitFire = GameData.upgrades.playerSplitFiring
        self.levelNum = levelNum
        self.totalScore = totalScore
        self.sceneManager = sceneManager
        self.credits = GameData.playerStats.credits
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder:NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func didMove(to view: SKView) {
        setupUI()
        
        physicsWorld.contactDelegate = self
        
        makeSprites(howMany: 10)
        unpauseSprites()
    }
    
    deinit{
        // TODO: Clean up resources, timers, listeners, etc...
    }
    
    //MARK - Helpers -
    private func setupUI(){
        
        /*
            Calculate playable rectL
            - this will calculate the clip for the top and the bottom of the scene on the ipad
            - the iPhone 5, iPhone 6, iPhone SE, iPhone 7 playableRect will always be (0, 0, 1080, 1920)
            - the iPad playableRect will always be (0, 240, 1080, 1440)
        */
        
        playableRect = getPlayableRectPhonePortrait(size: size)
        
        ship.position = CGPoint(x: playableRect.midX, y: playableRect.midY - 250)
        addChild(ship)
        
        let fontSize = GameData.hud.fontSize
        let fontColor = GameData.hud.fontColorWhite
        let marginH = GameData.hud.marginH
        let marginV = GameData.hud.marginV
        
        backgroundColor = GameData.hud.backgroundColor
        
        levelLabel.fontColor = fontColor
        levelLabel.fontSize = fontSize
        levelLabel.position = CGPoint(x: marginH,y: playableRect.maxY - marginV)
        levelLabel.verticalAlignmentMode = .top
        levelLabel.horizontalAlignmentMode = .left
        levelLabel.text = "Level: \(levelNum)"
        levelLabel.zPosition = GameLayer.hud
        addChild(levelLabel)
        
        scoreLabel.fontColor = fontColor
        scoreLabel.fontSize = fontSize
        
        scoreLabel.verticalAlignmentMode = .top
        scoreLabel.horizontalAlignmentMode = .left
        // next 2 lines calculate the max width of scoreLabel
        scoreLabel.text = "Score: \(levelScore)"
        
        let scoreLabelWidth = scoreLabel.frame.size.width
        scoreLabel.position = CGPoint(x: playableRect.maxX - scoreLabelWidth - marginH,y: playableRect.maxY - marginV)
        scoreLabel.zPosition = GameLayer.hud
        addChild(scoreLabel)
        
        creditsLabel.fontColor = fontColor
        creditsLabel.fontSize = fontSize
        creditsLabel.verticalAlignmentMode = .top
        creditsLabel.horizontalAlignmentMode = .left
        creditsLabel.text = "Credits: \(credits)"
        
        let credtisLabelWidth = creditsLabel.frame.size.width
        creditsLabel.position = CGPoint(x: playableRect.maxX - credtisLabelWidth - marginH,y: playableRect.maxY - (marginV * 2) - 30)
        creditsLabel.zPosition = GameLayer.hud
        addChild(creditsLabel)
        
        otherLabel.fontColor = fontColor
        otherLabel.fontSize = fontSize
        otherLabel.position = CGPoint(x: marginH, y: playableRect.minY + marginV)
        otherLabel.verticalAlignmentMode = .bottom
        otherLabel.horizontalAlignmentMode = .left
        otherLabel.text = "Enemies left: 0"
        otherLabel.zPosition = GameLayer.hud
        addChild(otherLabel)
        
        healthLabel.fontColor = fontColor
        healthLabel.fontSize = fontSize
        healthLabel.position = CGPoint(x: marginH, y: playableRect.minY + (marginV * 2) + 30)
        healthLabel.verticalAlignmentMode = .bottom
        healthLabel.horizontalAlignmentMode = .left
        healthLabel.text = "Health: \(ship.health)"
        healthLabel.zPosition = GameLayer.hud
        addChild(healthLabel)
        
        let background = SKSpriteNode(imageNamed: "space_background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = GameLayer.background
        addChild(background)
    }
    
    func makeSprites(howMany: Int){
        
        totalSprites = totalSprites + howMany
        otherLabel.text = "Enemies left: \(totalSprites)"
        var s: SKSpriteNode
        for _ in 0...howMany-1{
            
            let randY = randInRange(min: Int(playableRect.maxY), max: Int(playableRect.maxY + 300))
            let randX = randInRange(min: Int(playableRect.minX + 50), max: Int(playableRect.maxX - 50))
            s = EnemySprite()
            s.setScale(0.75);
            s.position = CGPoint(x: randX, y: randY)
            addChild(s)
            
            /*//debug for enemy bounding box
            let size = CGSize(width: s.frame.width - 10, height: s.frame.height / 2)
            let halfHeight = size.height / 2
            let halfWidth = size.width / 2
            
            let topLeft = CGPoint(x: -halfWidth, y: halfHeight)
            let topRight = CGPoint(x: halfWidth, y: halfHeight)
            let bottomRight = CGPoint(x: halfWidth, y: -halfHeight)
            let bottomLeft = CGPoint(x: -halfWidth, y: -halfHeight)
            
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: topLeft)
            pathToDraw.addLine(to: topRight)
            pathToDraw.addLine(to: bottomRight)
            pathToDraw.addLine(to: bottomLeft)
            pathToDraw.closeSubpath()
            
            let box = SKShapeNode(path: pathToDraw)
            
            box.position = s.position
            box.zPosition = GameLayer.projectile
            box.strokeColor = SKColor.red
            box.lineWidth = CGFloat(1)
            box.fillColor = SKColor.red
            
            addChild(box)
            */
        }
    }
    
    func calculateDeltaTime(currentTime: TimeInterval){
        
        if lastUpdateTime > 0{
            
            dt = currentTime - lastUpdateTime
        } else {
            
            dt = 0
        }

        lastUpdateTime = currentTime
    }
    
    func moveSprites(dt: CGFloat) {
        
        if spritesMoving{
            
            enumerateChildNodes(withName: "enemy", using: {
                
                node, stop in
                let s = node as! EnemySprite
                let halfWidth = s.frame.width/2
                let halfHeight = s.frame.height/2
                
                s.update(dt: dt)
                
                // check left/right
                if s.position.x <= halfWidth || s.position.x >= self.size.width - halfWidth{
                    
                    s.reflectX()
                    s.update(dt: dt)
                }
                
                // check top/bottom
                if s.position.y <= self.playableRect.minY - halfHeight{
                    
                    s.removeFromParent()
                }
            })
        }
    }
    
    func unpauseSprites(){
        
        let unpauseAction = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run({self.spritesMoving = true})])
        
        run(unpauseAction)
    }
    
    func movePlayer(dt: CGFloat){
        
        let gravityVector = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
        var xVelocity = gravityVector.dy
        xVelocity = xVelocity < -0.33 ? -0.33 : xVelocity
        xVelocity = xVelocity > 0.33 ? 0.33 : xVelocity
        
        xVelocity = xVelocity * 3
        
        if abs(xVelocity) < 0.1{
            
            xVelocity = 0
        }
        
        //print("xVelocity = \(xVelocity)")
        
        if let playerSprite = childNode(withName: "ship"){
            
            let halfWidth = playerSprite.frame.size.width/2
            let xRange = SKRange(lowerLimit: halfWidth, upperLimit: size.width - halfWidth)
            let yRange = SKRange(lowerLimit: 0, upperLimit: playableRect.maxY)
            playerSprite.constraints = [SKConstraint.positionX(xRange, y: yRange)]
            playerSprite.position.x += xVelocity * GameData.hud.shipMaxSpeedPerSecond * dt
        }
        
    }
    
    func randInRange(min: Int, max: Int) -> Int{
        
        return Int(arc4random_uniform(UInt32(max - min)) + UInt32(min))
    }
    
    //MARK: - Events -
    func didBegin(_ contact: SKPhysicsContact){
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else{
            
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) && (secondBody.categoryBitMask & PhysicsCategory.PProjectile != 0)){
            if (firstBody.node != nil && secondBody.node != nil ) {
                projectileDidCollideWithEnemy(projectile: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
            }
        }
    }
    
    func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode){
        
        print("Hit!")
        projectile.removeFromParent()
        enemy.removeFromParent()
        
        ship.projectilesFired -= 1
        totalSprites -= 1
        levelScore += 1
        credits += 5
        totalScore += 1
        
        creditsLabel.text = "Credits: \(credits)"
        let credtisLabelWidth = creditsLabel.frame.size.width
        creditsLabel.position = CGPoint(x: playableRect.maxX - credtisLabelWidth - GameData.hud.marginH,y: playableRect.maxY - (GameData.hud.marginV * 2) - 30)
        
        if totalSprites > 0{
            
            return
        }
        
        if levelNum < GameData.maxLevel{
            GameData.playerStats.credits = credits
            let results = LevelResults(levelNum: levelNum, credits: credits, levelScore: levelScore, totalScore: totalScore, msg: "Wave \(levelNum) Complete")
            sceneManager.loadLevelFinishScene(results: results)
        } else {
            GameData.playerStats.credits = credits
            let results = LevelResults(levelNum: levelNum, credits: credits, levelScore: levelScore, totalScore: totalScore, msg: "You finished level \(levelNum)")
            sceneManager.loadGameOverScene(results: results)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        
        if let playerSprite = childNode(withName: "ship"){
            
            if(ship.projectilesFired < ship.fireRate){
                
                ship.projectilesFired += 1
                let projectile = ProjectileSprite()
                projectile.position = CGPoint(x: playerSprite.position.x, y: playerSprite.position.y + (projectile.frame.height / 2))
                projectile.zPosition = GameLayer.projectile
                
                addChild(projectile)
                
                let actionMove = SKAction.moveTo(y: playableRect.maxY + (projectile.frame.height / 2), duration: 0.5)
                let actionMoveDone = SKAction.removeFromParent()
                projectile.run(SKAction.sequence([actionMove, actionMoveDone])){
                    
                    self.ship.projectilesFired -= 1
                }
            }
            
            /*//debug for projectile bounding box
            let size = CGSize(width: projectile.frame.width - 10, height: projectile.frame.height / 2 + 10)
            let halfHeight = size.height / 2
            let halfWidth = size.width / 2
            
            let topLeft = CGPoint(x: -halfWidth, y: halfHeight)
            let topRight = CGPoint(x: halfWidth, y: halfHeight)
            let bottomRight = CGPoint(x: halfWidth, y: -halfHeight)
            let bottomLeft = CGPoint(x: -halfWidth, y: -halfHeight)
            
            let pathToDraw = CGMutablePath()
            pathToDraw.move(to: topLeft)
            pathToDraw.addLine(to: topRight)
            pathToDraw.addLine(to: bottomRight)
            pathToDraw.addLine(to: bottomLeft)
            pathToDraw.closeSubpath()
            
            let box = SKShapeNode(path: pathToDraw)
            
            box.position = projectile.position
            box.zPosition = GameLayer.projectile
            box.strokeColor = SKColor.red
            box.lineWidth = CGFloat(1)
            box.fillColor = SKColor.red
            
            let actionBoxMove = SKAction.moveTo(y: playableRect.maxY + (box.frame.height / 2), duration: 0.5)
            let actionBoxMoveDone = SKAction.removeFromParent()
            box.run(SKAction.sequence([actionBoxMove, actionBoxMoveDone]))
            
            addChild(box)
            */
        }
    }
    
    //MARK: - Game Loop -
    override func update(_ currentTime: TimeInterval){
        
        calculateDeltaTime(currentTime: currentTime)
        moveSprites(dt: CGFloat(dt))
        movePlayer(dt: CGFloat(dt))
    }
}
