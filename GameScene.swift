//
//  GameScene.swift
//  Blastroid
//
//  Created by Ranjith R D on 18/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import PopupDialog
import VCBoss

class GameScene: SKScene {
    
    //MARK: Properties
    var viewController = UIViewController()
    var pauseButton = SKSpriteNode(imageNamed: "pauseButtonImg")
    var monster = SKSpriteNode(imageNamed: "asteroid-1")
    var backgroundNode = SKSpriteNode(imageNamed: "background")
    var score = 0
    var scoreLabel = SKLabelNode()
    var countdownLabel = SKLabelNode()
    var asteroids = 0
    var count: Int = 25 {
        didSet {
            countdownLabel.text = "\(count)"
        }
    }
    var misses = 0
    
    //MARK: Overrides
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        backgroundNode.removeFromParent()
        reset()
        continueGame()
        addChild(backgroundNode)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let touchedNode = self.atPoint(positionInScene)
            if let name = touchedNode.name {
                guard let tn = touchedNode as? SKSpriteNode else {return}
                if name == "monster" {
                    tn.alpha = 0.5
                    tn.name = nil
                    self.score += 1
                    self.scoreLabel.text = "Score: \(self.score)"
                    let inj = SKSpriteNode(imageNamed: "explosion")
                    inj.position = tn.position
                    self.addChild(inj)
                    inj.zPosition = 1000000000000
                    inj.name = "explosion"
                    self.run(SKAction.wait(forDuration: 0.5)) {
                        inj.removeFromParent()
                    }
                    self.addMonster()
                } else if name == "pauseButton" {
                    pause()
                }
            }
    }
    }
    override func update(_ currentTime: TimeInterval) {
        for x in children {
            if x.name == nil {
                x.removeFromParent()
                asteroids -= 1
                print("asteroids -= 1")
            }
        }
        if monster.position.y <= (frame.size.height / 4) * 1 {
            monster.texture = SKTexture(imageNamed: "injured")
            misses = misses + 1
            print("misses += 1")
            scoreLabel.text = "Score: \(self.score)"
            let inj = SKSpriteNode(imageNamed: "touch_earth_img")
            inj.position = monster.position
            self.addChild(inj)
            inj.zPosition = 1000000000000
            inj.name = "touch_earth"
            self.run(SKAction.wait(forDuration: 0.5)) {
                inj.removeFromParent()
            }
            monster.removeFromParent()
            monster.isHidden = false
            addMonster()
        }
    }
    //MARK: Countdown Functions
    func countdown(count: Int) {
        countdownLabel.position = CGPoint(x: ((self.size.width / 100) * 6.5), y: self.size.height - (self.size.height / 100) * 7.5)
        countdownLabel.fontName = "AdamGorry-Inline"
        countdownLabel.fontColor = SKColor.white
        countdownLabel.fontSize = (frame.size.height/100)*5
        countdownLabel.zPosition = 100
        countdownLabel.text = "\(count)"
        let counterDecrement = SKAction.sequence([SKAction.wait(forDuration: 1.0),
                                                  SKAction.run(countdownAction)])
        run(SKAction.sequence([SKAction.repeat(counterDecrement, count: count),
                               SKAction.run(endCountdown)]), withKey: "counterDecrement")
    }
    func countdownAction() {
        count -= 1
        countdownLabel.text = "\(count)"
    }
    func endCountdown() {
        countdownLabel.removeFromParent()
        scoreLabel.removeFromParent()
        monster.removeFromParent()
        pauseButton.removeFromParent()
        createLeader(l: Leader(n: Game.name, s: self.score))
        let anotherEndVC = endScreenVC
        let gamescoresx = GameScores(h: self.score, m: self.misses)
        anotherEndVC.setScore(sc: gamescoresx)
        rootVC!.vcboss.present(anotherEndVC, animated: true, completion: nil)
    }
    //MARK: Other Functions
    func presentLeaderboard() {
        rootVC!.present(lboardVC, animated: true, completion: {
        })
    }
    func reset() {
        if let v = UIApplication.shared.keyWindow?.rootViewController {
            viewController = v as! GameViewController
        } else {
            viewController = gameVC
        }
        countdownLabel.removeFromParent()
        scoreLabel.removeFromParent()
        monster.removeFromParent()
        pauseButton.removeFromParent()
        backgroundNode.name = "backgroundNode"
        backgroundNode.size = frame.size
        count = 25
        if isX() == true {
            countdownLabel.position = CGPoint(x: ((self.size.width / 100) * 6.5), y: (self.size.height - ((self.size.height / 100) * 6)))
            scoreLabel.position = CGPoint(x: 0.0 + (self.size.width / 100) * 10, y: (self.size.height - ((self.size.height / 100) * 8)))
        } else {
            scoreLabel.position = CGPoint(x: frame.size.width / 2, y: (self.size.height - ((self.size.height / 100) * 8)))
        }
        countdown(count: 25)
        pauseButton.name = "pauseButton"
        pauseButton.position = CGPoint(x:self.size.width - (self.size.width / 100) * 10, y:self.size.height - (self.size.height / 100) * 5)
        pauseButton.zPosition = 11
        scoreLabel.fontName = "AdamGorry-Inline"
        score = 0
        misses = 0
        scoreLabel.text = "Score:" + String(score)
        scoreLabel.color = UIColor.white
        scoreLabel.fontSize = (frame.size.height/100) * 4
        scoreLabel.zPosition = 10
        backgroundNode.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        backgroundNode.zPosition = 0
        backgroundColor = SKColor.white
        scoreLabel.name = "scoreLabel"
        countdownLabel.name = "countdownLabel"
        addMonster()
        addChild(scoreLabel)
        addChild(countdownLabel)
        addChild(pauseButton)
//        if FileManager.default.fileExists(atPath: "back_sound.mp3") {
//            let back_music = SKAction.playSoundFileNamed("back_sound.mp3", waitForCompletion: false)
//            run(back_music, withKey: "back_music")
//        } else {
//        }
    }
    func addMonster() {
        monster.removeFromParent()
        let another = SKSpriteNode(texture: SKTexture(image: asteroidImage()))
        let randompos = random(v: self)
        another.position = CGPoint(x: randompos.x, y: self.size.height - (self.size.height / 100) * 5)
        another.isUserInteractionEnabled = false
        another.name = "monster"
        another.zPosition = 2
        monster = another
        self.addChild(another)
        var duration: TimeInterval = 3.0
        if score <= 5 {
            duration = 2.75
        } else if score <= 10 {
            duration = 2.50
        } else if score <= 20 {
            duration = 2.25
        } else if score <= 30 {
            duration = 2.00
        } else if score <= 40 {
            duration = 1.75
        } else if score <= 50 {
            duration = 1.50
        }
        another.run(SKAction.move(to: CGPoint(x: randompos.x, y: self.size.height - self.size.height/100 * 98), duration: duration), withKey: "moveAction")
        self.asteroids = self.score + self.misses
    }
    func continueGame() {
        if let skaction = self.action(forKey: "counterDecrement") {
            skaction.speed = 1
        } else {
            print("counterDecrement is not available")
        }
        if let moveAction = self.monster.action(forKey: "moveAction") {
            moveAction.speed = 1
        } else {
            print("moveAction is not available")
        }
    }
    func pause() {
        print("paused")
        gameVC.vcboss.present(pauseVC, animated: true, completion: {
            self.scene?.view?.isPaused = true
            if let skaction = self.action(forKey: "counterDecrement") {
                skaction.speed = 0
            } else {
                print("counterDecrement is not available")
            }
//            if let back_music = self.action(forKey: "back_music") {
//                back_music.speed = 0
//            } else {
//                print("back_music is not available")
//            }
            if let moveAction = self.monster.action(forKey: "moveAction") {
                moveAction.speed = 0
            } else {
                print("moveAction is not available")
            }
        })
    }
}
