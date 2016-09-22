//
//  GameScene.swift
//  Galaba
//
//  Created by student on 9/20/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit
import GameplayKit

struct GameLayer {
    static let background: CGFloat = 0
    static let hud       : CGFloat = 1
    static let sprite    : CGFloat = 2
    static let message   : CGFloat = 3
}

class GameScene: SKScene {
    
    var playableRect = CGRect.zero
    var tapCount = 0
    var totalSprites = 0
    var levelNum: Int
    var levelScore: Int = 0 {
        
        didSet(score){
            
            scoreLabel.text = "Score: \(score)"
        }
    }
    var totalScore: Int
    var lastUpdateTime: TimeInterval = 0
    var dt: TimeInterval = 0
    var spritesMoving = false
    
    let sceneManager:GameViewController
    
    let levelLabel = SKLabelNode(fontNamed: "Futura")
    let scoreLabel = SKLabelNode(fontNamed: "Futura")
    let otherLabel = SKLabelNode(fontNamed: "Futura")
    
    // MARK: - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, levelNum:Int, totalScore:Int, sceneManager:GameViewController){
        
        self.levelNum = levelNum
        self.totalScore = totalScore
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init?(coder aDecoder:NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle -
    override func didMove(to view: SKView) {
        setupUI()
        
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
        scoreLabel.text = "Score: 000"
        let scoreLabelWidth = scoreLabel.frame.size.width
        
        // here is the starting text of scoreLabel
        scoreLabel.text = "Score: \(levelScore)"
        
        scoreLabel.position = CGPoint(x: playableRect.maxX - scoreLabelWidth - marginH,y: playableRect.maxY - marginV)
        scoreLabel.zPosition = GameLayer.hud
        addChild(scoreLabel)
        
        otherLabel.fontColor = fontColor
        otherLabel.fontSize = fontSize
        otherLabel.position = CGPoint(x: marginH, y: playableRect.minY + marginV)
        otherLabel.verticalAlignmentMode = .bottom
        otherLabel.horizontalAlignmentMode = .left
        otherLabel.text = "Num Sprites: 0"
        otherLabel.zPosition = GameLayer.hud
        addChild(otherLabel)
        
        let background = SKSpriteNode(imageNamed: "1080x1920-bg")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = GameLayer.background
        addChild(background)
        
        let ship = SKSpriteNode(imageNamed: "Spaceship")
        ship.setScale(0.5)
        ship.name = "ship"
        ship.position = CGPoint(x: playableRect.midX, y: playableRect.midY)
        ship.zPosition = GameLayer.sprite
        addChild(ship)
        
        let arrow = SKSpriteNode(imageNamed: "arrow")
        arrow.name = "arrow"
        arrow.position = CGPoint(x: playableRect.midX, y: playableRect.midY - arrow.size.height)
        arrow.zPosition = GameLayer.sprite
        addChild(arrow)
    }
    
    func makeSprites(howMany: Int){
        
        totalSprites = totalSprites + howMany
        otherLabel.text = "Num Sprites: \(totalSprites)"
        var s: DiamondSprite
        
        for _ in 0...howMany-1{
            
            s = DiamondSprite(size: CGSize(width: 60, height: 100), lineWidth: 10, strokeColor: SKColor.green, fillColor: SKColor.magenta)
            s.name = "diamond"
            s.position = randomCGPointInRect(playableRect, margin: 300)
            s.fwd = CGPoint.randomUnitVector()
            s.zPosition = GameLayer.sprite
            addChild(s)
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
            
            enumerateChildNodes(withName: "diamond", using: {
                
                node, stop in
                let s = node as! DiamondSprite
                let halfWidth = s.frame.width/2
                let halfHeight = s.frame.height/2
                
                s.update(dt: dt)
                
                // check left/right
                if s.position.x <= halfWidth || s.position.x >= self.size.width - halfWidth{
                    
                    s.reflectX()
                    s.update(dt: dt)
                    self.levelScore = self.levelScore + 1
                    self.totalScore = self.totalScore + 1
                }
                
                // check top/bottom
                if s.position.y <= self.playableRect.minY + halfHeight || s.position.y >= self.playableRect.maxY - halfHeight{
                    
                    s.reflectY()
                    s.update(dt: dt)
                    self.levelScore = self.levelScore + 1
                    self.totalScore = self.totalScore + 1
                }
            })
        }
    }
    
    func unpauseSprites(){
        
        let unpauseAction = SKAction.sequence([SKAction.wait(forDuration: 2), SKAction.run({self.spritesMoving = true})])
        
        run(unpauseAction)
    }
    
    func rotateArrow(){
        
        if let arrow = childNode(withName: "arrow"){
            
            arrow.zRotation = MotionMonitor.sharedMotionMonitor.rotation
        }
    }
    
    func movePlayer(dt: CGFloat){
        
        let gravityVector = MotionMonitor.sharedMotionMonitor.gravityVectorNormalized
        var xVelocity = gravityVector.dx
        xVelocity = xVelocity < -0.33 ? -0.33 : xVelocity
        xVelocity = xVelocity > 0.33 ? 0.33 : xVelocity
        
        xVelocity = xVelocity * 3
        
        if abs(xVelocity) < 0.1{
            
            xVelocity = 0
        }
        
        print("xVelocity = \(xVelocity)")
        
        if let playerSprite = childNode(withName: "ship"){
            
            let halfWidth = playerSprite.frame.size.width/2
            let halfHeight = playerSprite.frame.size.height/2
            let xRange = SKRange(lowerLimit: halfWidth, upperLimit: size.width - halfWidth)
            let yRange = SKRange(lowerLimit: 0, upperLimit: 0)
            playerSprite.constraints = [SKConstraint.positionX(xRange, y: yRange)]
            playerSprite.position.x += xVelocity * GameData.hud.shipMaxSpeedPerSecond * dt
        }
        
    }

    //MARK: - Events -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        tapCount = tapCount + 1
        
        if tapCount < 3{
            
            return
        }
        
        if levelNum < GameData.maxLevel{
            
            let results = LevelResults(levelNum: levelNum, levelScore: levelScore, totalScore: totalScore, msg: "You finished level \(levelNum)")
            sceneManager.loadLevelFinishScene(results: results)
        } else {
            
            let results = LevelResults(levelNum: levelNum, levelScore: levelScore, totalScore: totalScore, msg: "You finished level \(levelNum)")
            sceneManager.loadGameOverScene(results: results)
        }
    }
    
    //MARK: - Game Loop -
    override func update(_ currentTime: TimeInterval){
        
        calculateDeltaTime(currentTime: currentTime)
        moveSprites(dt: CGFloat(dt))
        rotateArrow()
        movePlayer(dt: CGFloat(dt))
    }
}
