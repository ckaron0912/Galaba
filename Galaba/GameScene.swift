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
    var levelScore: Int = GameData.playerStats.score {
        
        willSet(score){
            
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var totalScore: Int
    var credits: Int
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var timer: Timer?
    var spritesMoving = false
    
    let sceneManager:GameViewController
    
    let levelLabel = SKLabelNode(fontNamed: "Futura")
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let otherLabel = SKLabelNode(fontNamed: "Futura")
    let healthLabel = SKLabelNode(fontNamed: "Futura")
    let creditsLabel = SKLabelNode(fontNamed: "Futura")
    let fleetLabel = SKLabelNode(fontNamed: "Futura")
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, levelNum:Int, totalScore:Int, sceneManager:GameViewController){
        
        self.ship = ShipSprite()
        self.levelNum = levelNum
        self.totalScore = totalScore
        self.sceneManager = sceneManager
        self.credits = GameData.playerStats.credits
        self.timer = nil
        super.init(size: size)
        self.scaleMode = scaleMode
        
        // TODO: Make new timer based upon equipped weapon
        self.timer = Timer.scheduledTimer(timeInterval: TimeInterval(GameData.upgrades.rapidFireRate), target: self, selector: #selector(fire), userInfo: nil, repeats: true)
    }
    
    required init?(coder aDecoder:NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func didMove(to view: SKView) {
        setupUI()
        
        physicsWorld.contactDelegate = self
        
        makeSprites(howMany: GameData.scene.numEnemiesToSpawn)
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
        
        fleetLabel.fontColor = fontColor
        fleetLabel.fontSize = fontSize
        
        fleetLabel.text = "Fleet strength: \(GameData.upgrades.fleetHealth)"
        let fleetLabelWidth = fleetLabel.frame.size.width
        fleetLabel.position = CGPoint(x: playableRect.maxX - fleetLabelWidth - marginH, y: playableRect.minY + marginV)
        fleetLabel.verticalAlignmentMode = .bottom
        fleetLabel.horizontalAlignmentMode = .left
        fleetLabel.zPosition = GameLayer.hud
        addChild(fleetLabel)
        
        healthLabel.fontColor = fontColor
        healthLabel.fontSize = fontSize
        healthLabel.position = CGPoint(x: marginH, y: playableRect.minY + (marginV * 2) + 30)
        healthLabel.verticalAlignmentMode = .bottom
        healthLabel.horizontalAlignmentMode = .left
        healthLabel.text = "Health: \(ship.health)"
        healthLabel.zPosition = GameLayer.hud
        addChild(healthLabel)
        
        let background = SKSpriteNode(imageNamed: "background")
        
        if(GameData.scene.backgroundPosition.y == 0){
            background.position = CGPoint(x: size.width/2, y: size.height/2 + 400)
        }else{
            background.position = GameData.scene.backgroundPosition
        }
        background.zPosition = GameLayer.background
        background.name = "background"
        addChild(background)
        
        let moveAction = SKAction.moveTo(y: background.position.y - 810, duration: 500)
        
        background.run(moveAction)
        let music = SKAudioNode(fileNamed: "backgroundMusic.wav")
        music.autoplayLooped = true;
        addChild(music)
        music.run(SKAction.play())
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
                    GameData.upgrades.fleetHealth -= 10
                    self.fleetLabel.text = "Fleet strength: \(GameData.upgrades.fleetHealth)"
                    let fleetLabelWidth = self.fleetLabel.frame.size.width
                    self.fleetLabel.position = CGPoint(x: self.playableRect.maxX - fleetLabelWidth - GameData.hud.marginH, y: self.playableRect.minY + GameData.hud.marginV)
                    self.totalSprites -= 1
                    s.removeFromParent()
                }
                
                // Check for fire
                if abs(s.position.x - self.ship.position.x) < 50 && s.lastFired - TimeInterval(0.01) > self.lastUpdateTime {
                    print(self.lastUpdateTime)
                    s.lastFired = self.lastUpdateTime
                    
                    let projectile = ProjectileSprite(position: CGPoint(x: s.position.x, y: s.position.y - 25))
                    projectile.physicsBody?.categoryBitMask = PhysicsCategory.EProjectile
                    self.addChild(projectile)
                    
                    let actionMove = SKAction.moveTo(y: 500, duration: 2.5)
                    let actionMoveDone = SKAction.removeFromParent()
                    projectile.run(SKAction.sequence([actionMove, actionMoveDone])){}
                }
                
            })
        }
    }
    
    func unpauseSprites(){
        
        let unpauseAction = SKAction.sequence([SKAction.wait(forDuration: 0.8), SKAction.run({self.spritesMoving = true})])
        
        run(unpauseAction)
    }
    
    func movePlayer(dt: CGFloat){
        
        let gravityVector = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
        var xVelocity = gravityVector.dy
        xVelocity = xVelocity < -0.33 ? -0.33 : xVelocity
        xVelocity = xVelocity > 0.33 ? 0.33 : xVelocity
        
        xVelocity = xVelocity * 2.2
        
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
    
    // Check for wave and game end conditions
    func checkForEnd(){
        
        guard totalSprites == 0 || GameData.upgrades.fleetHealth <= 0 else{
            return
        }
        
        let finishAction = SKAction.moveTo(x: playableRect.midX, duration: 1)
        
        ship.run(finishAction, completion: {
            
            if GameData.upgrades.fleetHealth > 0{
                GameData.playerStats.credits = self.credits
                let background = self.childNode(withName: "background")!
                GameData.scene.backgroundPosition = background.position
                GameData.scene.enemySpeedIncrease += 2
                GameData.scene.numEnemiesToSpawn += GameData.scene.numEnemiesToIncrease
                GameData.playerStats.score += self.levelScore
                
                let results = LevelResults(levelNum: self.levelNum, credits: self.credits, levelScore: self.levelScore, totalScore: self.totalScore, msg: "Wave \(self.levelNum) Complete")
                self.sceneManager.loadLevelFinishScene(results: results)
            } else{
                GameData.playerStats.credits = self.credits
                let results = LevelResults(levelNum: self.levelNum, credits: self.credits, levelScore: self.levelScore, totalScore: self.totalScore, msg: "You finished level \(self.levelNum)")
                self.sceneManager.loadGameOverScene(results: results)
            }
        })
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
        
        // Check for bullet to enemy collision
        if ((firstBody.categoryBitMask & PhysicsCategory.Enemy != 0) && (secondBody.categoryBitMask & PhysicsCategory.PProjectile != 0)){
            if (firstBody.node != nil && secondBody.node != nil ) {
                projectileDidCollideWithEnemy(projectile: firstBody.node as! SKSpriteNode, enemy: secondBody.node as! SKSpriteNode)
            }
        }
        
        // TODO: Check for enemy to player collisions
        
        // Check for enemy bullet to player collisions
        if ((firstBody.categoryBitMask & PhysicsCategory.Player != 0) && (secondBody.categoryBitMask & PhysicsCategory.EProjectile != 0)){
            if (firstBody.node != nil && secondBody.node != nil ) {
                projectileDidCollideWithPlayer(projectile: secondBody.node as! SKSpriteNode, player: firstBody.node as! SKSpriteNode)
            }
        }
    }
    
    func projectileDidCollideWithEnemy(projectile: SKSpriteNode, enemy: SKSpriteNode){
        
        print("Hit!")
        projectile.removeFromParent()
        enemy.removeFromParent()
        run(SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false))
        
        // Emitters
        let explodeEmitter = SKEmitterNode(fileNamed: "explode")!
        explodeEmitter.particlePosition = enemy.position
        explodeEmitter.zPosition = GameLayer.sprite
        self.addChild(explodeEmitter)
        self.run(SKAction.wait(forDuration: 2), completion: {explodeEmitter.removeFromParent()})
        
        let sparkEmitter = SKEmitterNode(fileNamed: "sparks")!
        sparkEmitter.particlePosition = CGPoint(x: projectile.position.x + (projectile.size.width/2), y: projectile.position.y + (projectile.size.height/2))
        sparkEmitter.zPosition = GameLayer.sprite
        self.addChild(sparkEmitter)
        self.run(SKAction.wait(forDuration: 2), completion: {sparkEmitter.removeFromParent()})
        
        // Update vars
        ship.projectilesFired -= 1
        totalSprites -= 1
        levelScore += 1
        credits += 5
        totalScore += 1
        
        creditsLabel.text = "Credits: \(credits)"
        let credtisLabelWidth = creditsLabel.frame.size.width
        creditsLabel.position = CGPoint(x: playableRect.maxX - credtisLabelWidth - GameData.hud.marginH, y: playableRect.maxY - (GameData.hud.marginV * 2) - 30)
        
        let scoreLabelWidth = scoreLabel.frame.size.width
        scoreLabel.position = CGPoint(x: playableRect.maxX - scoreLabelWidth - GameData.hud.marginH,y: playableRect.maxY - GameData.hud.marginV)
    }
    
    func projectileDidCollideWithPlayer(projectile: SKSpriteNode, player: SKSpriteNode){
        
        print("Player Hit!")
        projectile.removeFromParent()
        
        run(SKAction.playSoundFileNamed("bomb.wav", waitForCompletion: false))
        
        let sparkEmitter = SKEmitterNode(fileNamed: "sparks")!
        sparkEmitter.particlePosition = CGPoint(x: projectile.position.x + (projectile.size.width/2), y: projectile.position.y + (projectile.size.height/2))
        sparkEmitter.zPosition = GameLayer.sprite
        self.addChild(sparkEmitter)
        self.run(SKAction.wait(forDuration: 2), completion: {sparkEmitter.removeFromParent()})
        
        // Update vars
        ship.health -= 10
        healthLabel.text = "Health: \(ship.health)"
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // TODO: Add/check button for press, then show store
        guard let touch = touches.first else {
            return
        }
        
        if let playerSprite = childNode(withName: "ship"){
            
            if childNode(withName: "ship") != nil{
                ship.isFiring = true
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        ship.isFiring = false
    }
    
    //MARK: - Game Loop -
    override func update(_ currentTime: TimeInterval){
        checkForEnd()
        calculateDeltaTime(currentTime: currentTime)
        moveSprites(dt: CGFloat(dt))
        movePlayer(dt: CGFloat(dt))
    }
    
    func fire(){
        ship.fire()
    }
}
