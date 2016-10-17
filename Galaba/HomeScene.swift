//
//  HomeScene.swift
//  Galaba
//
//  Created by student on 9/22/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit

class HomeScene: SKScene {
    
    // MARK - ivars -
    let sceneManager:GameViewController
    let button:SKLabelNode = SKLabelNode(fontNamed: GameData.font.mainFont)
    
    // MARK - Initialization -
    init(size:CGSize, scaleMode:SKSceneScaleMode, sceneManager:GameViewController) {
        
        self.sceneManager = sceneManager
        super.init(size:size)
        self.scaleMode = scaleMode
    }
    
    required init(coder aDecoder:NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view:SKView) {
        
        backgroundColor = GameData.scene.backgroundColor
        
        let background = SKSpriteNode(imageNamed: "space_background")
        background.position = CGPoint(x: size.width/2, y: size.height/2)
        background.zPosition = GameLayer.background
        addChild(background)
        
        let label = SKLabelNode(fontNamed: GameData.font.mainFont)
        label.text = "Galaba"
        
        label.fontSize = 100
        
        label.position = CGPoint(x:size.width/2, y:size.height/2)
        
        label.zPosition = GameLayer.hud
        addChild(label)
        
        // label3 was an image - I'll let you do that on your own
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = "Tap to continue"
        label2.fontColor = UIColor.red
        label2.fontSize = 40
        label2.position = CGPoint(x:size.width/2, y:size.height/2 - 400)
        label2.zPosition = GameLayer.hud
        addChild(label2)
        
        let ship = ShipSprite()
        ship.position = CGPoint(x: size.width/2, y: size.height/2 - 250)
        addChild(ship)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneManager.loadGameScene(levelNum: 1, totalScore: 0)
    }
}
