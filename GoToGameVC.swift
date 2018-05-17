//
//  GoToGameVC.swift
//  Blastroid
//
//  Created by Ranjith R D on 11/05/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit

class GoToGameVC: UIViewController {

    var shouldDismiss = false
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.addTarget(self, action: #selector(showGameViewController), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func showGameViewController() {
        if shouldDismiss != true {
            present(gameVC, animated: true, completion: nil)
        } else {
            gameVC.dismiss(animated: true, completion: nil)
            gameVC.viewDidLoad()
            gameVC.gscene.scene?.view?.isPaused = false
            gameVC.gscene.continueGame()
            gameVC.gscene.reset()
            gameVC.dismiss(animated: true, completion: nil)
            endScreenVC.dismiss(animated: true, completion: nil)
            pauseVC.dismiss(animated: true, completion: nil)
        }
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
