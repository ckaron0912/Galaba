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
    var healthUpgradeCostLabel: SKLabelNode
    var fleetUpgradeCostLabel: SKLabelNode
    var repairCostLabel: SKLabelNode
    var creditsLabel: SKLabelNode
    
    // MARK - Initialization -
    init(size: CGSize, scaleMode: SKSceneScaleMode, results: LevelResults, sceneManager: GameViewController){
        
        self.healthUpgradeCostLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        self.fleetUpgradeCostLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        self.creditsLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        self.repairCostLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
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
        label.fontSize = 70
        label.position = CGPoint(x:size.width/2, y:size.height/2 + 300)
        label.zPosition = GameLayer.hud
        addChild(label)
        
        let label2 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label2.text = results.msg
        label2.fontSize = 40
        label2.position = CGPoint(x:size.width/2, y:size.height/2 + 250)
        label2.zPosition = GameLayer.hud
        addChild(label2)
        
        let label3 = SKLabelNode(fontNamed: GameData.font.mainFont)
        label3.text = "You destroyed \(results.levelScore) ships!"
        label3.fontSize = 40
        label3.position = CGPoint(x:size.width/2, y:size.height/2 + 200)
        label3.zPosition = GameLayer.hud
        addChild(label3)
        
        creditsLabel.text = "Credits: \(GameData.playerStats.credits)"
        creditsLabel.fontSize = 40
        creditsLabel.position = CGPoint(x:size.width/2, y:size.height/2 + 150)
        creditsLabel.zPosition = GameLayer.hud
        creditsLabel.name = "creditsLabel"
        addChild(creditsLabel)
        
        // shop items
        let healthUpgradeLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        healthUpgradeLabel.text = "Health Upgrade"
        healthUpgradeLabel.fontSize = 25
        healthUpgradeLabel.position = CGPoint(x: size.width/2 + 300, y: size.height/2)
        healthUpgradeLabel.zPosition = GameLayer.hud
        addChild(healthUpgradeLabel)
        
        healthUpgradeCostLabel.text = "Cost: \(GameData.upgrades.healthUpgradeCost)"
        healthUpgradeCostLabel.fontSize = 25
        healthUpgradeCostLabel.position = CGPoint(x: size.width/2 + 300, y: size.height/2 - 30)
        healthUpgradeCostLabel.name = "healthUpgradeCostLabel"
        healthUpgradeCostLabel.zPosition = GameLayer.hud
        addChild(healthUpgradeCostLabel)
        
        let healthUpgradeButton = SKSpriteNode(imageNamed: "Purchase_button")
        healthUpgradeButton.position = CGPoint(x: size.width/2 + 300, y: size.height/2 - 100)
        healthUpgradeButton.name = "healthUpgradeButton"
        healthUpgradeButton.zPosition = GameLayer.sprite
        addChild(healthUpgradeButton);
        
        let fleetUpgradeLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        fleetUpgradeLabel.text = "Fleet upgrade"
        fleetUpgradeLabel.fontSize = 25
        fleetUpgradeLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        fleetUpgradeLabel.zPosition = GameLayer.hud
        addChild(fleetUpgradeLabel)
        
        fleetUpgradeCostLabel.text = "Cost: \(GameData.upgrades.fleetUpgradeCost)"
        fleetUpgradeCostLabel.fontSize = 25
        fleetUpgradeCostLabel.position = CGPoint(x: size.width/2, y: size.height/2 - 30)
        fleetUpgradeCostLabel.name = "fleetUpgradeCostLabel"
        fleetUpgradeCostLabel.zPosition = GameLayer.hud
        addChild(fleetUpgradeCostLabel)
        
        let fleetUpgradeButton = SKSpriteNode(imageNamed: "Purchase_button")
        fleetUpgradeButton.position = CGPoint(x: size.width/2, y: size.height/2 - 100)
        fleetUpgradeButton.name = "fleetUpgradeButton"
        fleetUpgradeButton.zPosition = GameLayer.sprite
        addChild(fleetUpgradeButton);
        
        let repairLabel = SKLabelNode(fontNamed: GameData.font.mainFont)
        repairLabel.text = "Ship repair"
        repairLabel.fontSize = 25
        repairLabel.position = CGPoint(x: size.width/2 - 300, y: size.height/2)
        repairLabel.zPosition = GameLayer.hud
        addChild(repairLabel)
        
        repairCostLabel.text = "Cost: \(GameData.upgrades.repairCost)"
        repairCostLabel.fontSize = 25
        repairCostLabel.position = CGPoint(x: size.width/2 - 300, y: size.height/2 - 30)
        repairCostLabel.name = "repairCostLabel"
        repairCostLabel.zPosition = GameLayer.hud
        addChild(repairCostLabel)
        
        let repairButton = SKSpriteNode(imageNamed: "Purchase_button")
        repairButton.position = CGPoint(x: size.width/2 - 300, y: size.height/2 - 100)
        repairButton.name = "repairButton"
        repairButton.zPosition = GameLayer.sprite
        addChild(repairButton);
        
        // Continue
        let continueButton = SKLabelNode(fontNamed: GameData.font.mainFont)
        continueButton.fontColor = UIColor.red
        continueButton.text = "Press here to continue"
        continueButton.fontSize = 70
        continueButton.position = CGPoint(x:size.width/2, y:size.height/2 - 400)
        continueButton.name = "continueButton"
        continueButton.zPosition = GameLayer.sprite
        addChild(continueButton);
        
        let ship = ShipSprite()
        ship.position = CGPoint(x: size.width/2, y: size.height/2 - 250)
        addChild(ship)
    }
    
    // MARK - Events -
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //sceneManager.loadGameScene(levelNum: results.levelNum + 1, totalScore: results.totalScore)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches {
            
            let healthUpgradebutton = childNode(withName: "healthUpgradeButton")!
            let fleetUpgradeButton = childNode(withName: "fleetUpgradeButton")!
            let continueButton = childNode(withName: "continueButton")!
            let repairButton = childNode(withName: "repairButton")!
            let location = touch.location(in: self)
            
            // upgrade health
            if healthUpgradebutton.contains(location){
                
                if(GameData.upgrades.healthUpgradeCost <= GameData.playerStats.credits){
                    
                    GameData.playerStats.credits -= GameData.upgrades.healthUpgradeCost
                    GameData.upgrades.healthUpgradeCost += 25
                    GameData.upgrades.playerMaxHealth += GameData.upgrades.healthUpgradeAmount
                    healthUpgradeCostLabel.text = "Cost: \(GameData.upgrades.healthUpgradeCost)"
                    creditsLabel.text = "Credits: \(GameData.playerStats.credits)"
                }
            }
            
            // upgrade fleet
            if fleetUpgradeButton.contains(location){
                if(GameData.upgrades.fleetUpgradeCost <= GameData.playerStats.credits){
                    
                    GameData.playerStats.credits -= GameData.upgrades.fleetUpgradeCost
                    GameData.upgrades.fleetUpgradeCost += 50
                    GameData.upgrades.fleetHealth += GameData.upgrades.fleetUpgradeAmount
                    fleetUpgradeCostLabel.text = "Cost: \(GameData.upgrades.fleetUpgradeCost)"
                    creditsLabel.text = "Credits: \(GameData.playerStats.credits)"
                }
            }
            
            // repair ship
            if repairButton.contains(location){
                
                if(GameData.playerStats.credits >= GameData.upgrades.repairCost){
                    GameData.playerStats.credits -= GameData.upgrades.repairCost
                    GameData.upgrades.playerHealth = GameData.upgrades.playerMaxHealth
                    GameData.upgrades.repairCost += 5
                    repairCostLabel.text = "Cost: \(GameData.upgrades.repairCost)"
                    creditsLabel.text = "Credits: \(GameData.playerStats.credits)"
                }
            }
            
            // load gameScene
            if continueButton.contains(location){
                
                sceneManager.loadGameScene(levelNum: results.levelNum + 1, totalScore: results.totalScore)
            }
        }
    }
}
