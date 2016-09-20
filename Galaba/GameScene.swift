//
//  GameScene.swift
//  Galaba
//
//  Created by student on 9/20/16.
//  Copyright © 2016 student. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var levelNum:Int
    var levelScore:Int = 0
    var totalScore:Int
    let sceneManager:GameViewController
    
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
    }
    
    deinit{
        // TODO: Clean up resources, timers, listeners, etc...
    }
    
    //MARK - Helpers -
    private func setupUI(){
        
        backgroundColor = GameData.hud.backgroundColor
    }
    
    //MARK: - Events -
    
    //MARK: - Game Loop -
    override func update(_ currentTime: TimeInterval){
        
    }
}
