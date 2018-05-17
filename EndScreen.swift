//
//  EndScreen.swift
//  Blastroid
//
//  Created by Ranjith R D on 10/05/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit

class EndScreen: UIViewController {

    var score = GameScores()
    var img = UIImage()
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var restart: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var leaderboardBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "You have hit \(score.hits ?? 24) asteroids and missed \(score.misses ?? 1) asteroids out of a total of \(score.asteroids ?? 25) asteroids."
        shareButton.addTarget(self, action: #selector(share), for: .touchUpInside)
        restart.addTarget(self, action: #selector(restartFunction), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIGraphicsBeginImageContextWithOptions(view.frame.size, true, 0)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        view.layer.render(in: context)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return }
        UIGraphicsEndImageContext()
        self.img = image
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @objc func restartFunction() {
        goToGameVC.shouldDismiss = true
        gameVC.dismiss(animated: true, completion: nil)
        rootVC!.present(goToGameVC, animated: true, completion: nil)
    }
    @objc func share() {
        let activityString = NSMutableAttributedString(string: """
            I have hit \(score.hits ?? 0) asteroids and missed \(score.misses ?? 0) asteroids out of a total of \(score.asteroids ?? 0) asteroids.
            Download Blastroid here to play this game!
            """
        )
        let anotheractivityString = activityString.setAsLink(textToFind: "here", linkURL: "https://itunes.apple.com/us/app/blastroid/id1385355247?ls=1&mt=8")
        let sharevc = UIActivityViewController(activityItems: [activityString, img], applicationActivities: nil)
        DispatchQueue.main.async {
            sharevc.popoverPresentationController?.sourceView = self.view
            sharevc.popoverPresentationController?.sourceRect = self.shareButton.frame
            self.present(sharevc, animated: true, completion: nil)
        }
    }
    
    func setScore(sc: GameScores) {
        self.score = sc
        if viewIfLoaded == nil {
            
        } else {
            viewDidLoad()
        }
    }
    convenience init(score: GameScores) {
        self.init()
        self.score = score
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
