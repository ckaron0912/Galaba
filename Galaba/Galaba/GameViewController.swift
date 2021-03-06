//
//  GameViewController.swift
//  Galaba
//
//  Created by student on 9/20/16.
//  Copyright © 2016 student. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    // MARK - ivars -
    var gameScene: GameScene?
    var skView: SKView!
    let showDebugData = true
    let screenSize = CGSize(width: 1080, height: 1920)
    let scaleMode = SKSceneScaleMode.aspectFill
    
    // MARK - Initialization -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.becomeFirstResponder()
        skView = self.view as! SKView
        loadHomeScene()
        
        // debug stuff
        skView.ignoresSiblingOrder = true
        skView.showsFPS = showDebugData
        skView.showsNodeCount = showDebugData
    }
    
    // MARK - Scene Management -
    func loadHomeScene() {
        
        let scene = HomeScene(size: screenSize, scaleMode: scaleMode, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 2)
        skView.presentScene(scene, transition: reveal)
    }
    
    func loadGameScene(levelNum: Int, totalScore: Int) {
        
        gameScene = GameScene(size: screenSize, scaleMode: scaleMode, levelNum: levelNum, totalScore: totalScore, sceneManager: self)
        
        let reveal = SKTransition.crossFade(withDuration: 2)
        skView.presentScene(gameScene!, transition: reveal)
        
        MotionMonitor.sharedMotionMonitor.startUpdates()
    }
    
    func loadLevelFinishScene(results: LevelResults){
        
        gameScene = nil
        let scene = LevelFinishScene(size: screenSize, scaleMode: scaleMode, results: results, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 2)
        skView.presentScene(scene, transition: reveal)
        
        MotionMonitor.sharedMotionMonitor.stopUpdates()
    }
    
    func loadGameOverScene(results: LevelResults){
        
        gameScene = nil
        let scene = GameOverScene(size: screenSize, scaleMode: scaleMode, results: results, sceneManager: self)
        let reveal = SKTransition.crossFade(withDuration: 2)
        skView.presentScene(scene, transition: reveal)
    }
    
    // MARK - Motion Events -
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        
        if motion == .motionShake {
            
            print("detected shake")
            gameScene?.makeSprites(howMany: 10)
        }
    }
    
    // MARK - Lifecycle -
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // release any cached data, images, etc that aren't in use.
    }
    
    override var prefersStatusBarHidden: Bool {
        
        return true
    }
    
    override var canBecomeFirstResponder: Bool{
        
        return true
    }
}
