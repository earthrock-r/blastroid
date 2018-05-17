//
//  PauseScreen.swift
//  Blastroid
//
//  Created by Ranjith R D on 09/05/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit

class PauseScreen: UIViewController {

    @IBOutlet var play: UIButton!
    @IBOutlet var restart: UIButton!
    @IBOutlet var leaderboardButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        play.addTarget(self, action: #selector(didTouchPlay), for: .touchUpInside)
        restart.addTarget(self, action: #selector(didRestartGame), for: .touchUpInside)
        leaderboardButton.addTarget(self, action: #selector(didTouchLeaderboard), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didTouchPlay() {
        gameVC.gscene.scene?.view?.isPaused = false
        gameVC.gscene.continueGame()
        self.dismiss(animated: true, completion: nil)
    }
    @objc func didRestartGame() {
        goToGameVC.shouldDismiss = true
        gameVC.dismiss(animated: true, completion: nil)
        rootVC!.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
        rootVC!.present(goToGameVC, animated: true, completion: nil)
        goToGameVC.dismiss(animated: true, completion: nil)
    }
    @objc func didTouchLeaderboard() {
        self.dismiss(animated: true, completion: nil)
        rootVC!.present(lboardVC, animated: true, completion: {
        })
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
