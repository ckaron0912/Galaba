//
//  GameData
//  Shooter
//
//  Created by jefferson on 9/15/16.
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
    }
    
    struct upgrades{
        static var playerFireRate = 2;
        static var playerMaxHealth = 100;
        static var playerSplitFiring = false
    }
    
    struct playerStats{
        static var credits = 0;
    }
}

