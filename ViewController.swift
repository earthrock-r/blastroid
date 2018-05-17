//
//  ViewController.swift
//  Blastroid
//
//  Created by Ranjith R D on 04/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

import UIKit
import PopupDialog

class ViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func go(_ sender: Any) {
        play(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc func play(_ sender: Any?) {
        Game.name = nameTextField.text ?? UIDevice.current.name
        if nameTextField.text == "" {
            Game.name = UIDevice.current.name
        }
        let palert = PopupDialog(title: "iCloud Usage", message: "This app uses iCloud for the leaderboard. To use this, you should be signed into iCloud. Please do if you currently have not.", image: nil)
        palert.addButton(PopupDialogButton(title: "Done", action: {
            self.present(gameVC, animated: true, completion: nil)
        }))
        palert.addButton(PopupDialogButton(title: "iCloud", action: {
            let settingsCloudKitURL = URL(string: "App-Prefs:root=CASTLE")
            if let url = settingsCloudKitURL, UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }))
        UserDefaults.standard.set(Game.name, forKey: "name")
        let spacebg = UIImage(named: "space_bg_img")!
        palert.background_image = spacebg
        palert.background_view?.contentMode = .scaleAspectFill
        present(palert, animated: true, completion: nil)
    }
}

