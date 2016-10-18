//
//  GameData
//  Shooter
//
//  Created by jefferson on 9/15/16. Edited by Chad Karon and Zach Cupec
//  Copyright © 2016 tony. All rights reserved.
//

import SpriteKit

struct GameData{
    init(){
        fatalError("The GameData struct is a singleton")
    }
    static let maxLevel = 3
    struct font{
        static let mainFont = "Futura"
    }
    
    struct hud{
        static let backgroundColor = SKColor.black
        static let fontSize = CGFloat(44.0)
        static let fontColorWhite = SKColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.0)
        static let marginV = CGFloat(20.0)
        static let marginH = CGFloat(20.0)
        static let shipMaxSpeedPerSecond = CGFloat(800.0)
    }
    
    struct image{
        static let startScreenLogo = "alien_top_01"
        static let background = "background"
        static let player_A = "spaceflier_01_a"
        static let player_B = "spaceflier_01_b"
        static let arrow = "arrow"
    }
    
    struct scene {
        static let backgroundColor = SKColor.black
        static let backgroundImage = SKSpriteNode(imageNamed: "space_background")
        static var backgroundPosition = CGPoint(x: 0, y: 0)
        static var numEnemiesToSpawn = 10
        static let numEnemiesToIncrease = 3
        static var enemySpeed = CGFloat(100.0)
        static var enemySpeedIncrease = CGFloat(0.0)
    }
    
    struct upgrades{
        static var fleetUpgradeAmount = 50
        static var healthUpgradeAmount = 10
        static var firRateUpgradeCost = 50
        static var fleetUpgradeCost = 50
        static var healthUpgradeCost = 50
        static var repairCost = 5
        
        static var fleetHealth = 200{
            didSet{
                if fleetHealth < 0{
                    fleetHealth = 0
                }
            }
        }
        static var defaultMaxProj = 0
        static var rapidMaxProj = 3
        static var defaultFireRate = 0.0
        static var rapidFireRate = 0.2
        static var playerMaxHealth = 100
        static var playerSplitFiring = false
        static var playerHealth = 100
        
        struct type{
            static var none = 0
            static var rapid = 1
        }
    }
    
    struct playerStats{
        static var credits = 0{
            didSet{
                if credits < 0{
                    credits = 0
                }
            }
        }
        static var score = 0
    }
}

