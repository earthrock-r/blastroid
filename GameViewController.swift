//
//  GameViewController.swift
//  Blastroid
//
//  Created by Ranjith R D on 04/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet var gameView: SKView!
    var gscene = GameScene()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = gameVC
        do {
            try goToGameVC.vcboss.dismiss(animated: true, completion: nil)
        } catch let error {
            print(error.localizedDescription)
        }
        gameView.bounds = view.bounds
        view.tag = 111
        let scene = GameScene(size: gameView.bounds.size)
        gscene = scene
        gscene.reset()
        gameView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        gameView.presentScene(scene)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
