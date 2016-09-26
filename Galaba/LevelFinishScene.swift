//
//  LevelFinishScene.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit

class LevelFinishScene: SKScene{
    
    // MARK - ivars -
    let sceneManager: GameViewController
    let results: LevelResults
    let button: SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    // MARK - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, results: LevelResults, sceneManager: GameViewController){
        
        self.results = results
        self.sceneManager = sceneManager
        super.init(size: size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder: NSCoder){
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "space_background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = GameLayer.background
        addChild(background)
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Level Results"
        label.fontSize = 100
        label.position = CGPoint(x:size.width/2, y:size.height/2 + 300)
        label.zPosition = GameLayer.hud
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = "You beat level \(results.levelNum)!"
        label2.fontSize = 70
        label2.position = CGPoint(x:size.width/2, y:size.height/2 + 100)
        label2.zPosition = GameLayer.hud
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "You destroyed \(results.levelScore) ships!"
        label3.fontSize = 70
        label3.position = CGPoint(x:size.width/2, y:size.height/2 - 100)
        label3.zPosition = GameLayer.hud
        addChild(label3)
        
        let label4 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label4.text = "Tap to continue"
        label4.fontColor = UIColor.red
        label4.fontSize = 70
        label4.position = CGPoint(x:size.width/2, y:size.height/2 - 400)
        label4.zPosition = GameLayer.hud
        addChild(label4)
    }
    
    // MARK - Events -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadGameScene(levelNum: results.levelNum + 1, totalScore: results.totalScore)
    }
}
