//
//  File.swift
//  Blastroid
//
//  Created by Ranjith R D on 19/04/18.
//  Copyright © 2018 Ranjith R Dixit. All rights reserved.
//

//MARK: Imports
import Foundation
import UIKit
import SpriteKit
import CloudKit
import PopupDialog
//MARK: Models
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
extension NSMutableAttributedString {
    public func setAsLink(textToFind:String, linkURL:String) -> Bool {
        let foundRange = self.mutableString.range(of: textToFind)
        if foundRange.location != NSNotFound {
            self.addAttribute(NSAttributedStringKey.link, value: linkURL, range: foundRange)
            return true
        }
        return false
    }
}
public extension Float {
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: Float {
        return Float(arc4random()) / 0xFFFFFFFF
    }
    /// Random float between 0 and n-1.
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    public static func random(min: Float, max: Float) -> Float {
        return Float.random * (max - min) + min
    }
}
public extension CGFloat {
    /// Randomly returns either 1.0 or -1.0.
    public static var randomSign: CGFloat {
        return (arc4random_uniform(2) == 0) ? 1.0 : -1.0
    }
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    public static var random: CGFloat {
        return CGFloat(Float.random)
    }
    /// Random CGFloat between 0 and n-1.
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random CGFloat point number between 0 and n max
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat.random * (max - min) + min
    }
}
struct Game {
    static var name = ""
    static var leaderboardEnabled = true
    static var launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    static var highestScore = 0
    static var scoreRecordID: CKRecordID?
}
class Leader {
    var name = String()
    var score = Int()
    init(){}
    init(n: String, s: Int) {
        self.name = n
        self.score = s
    }
}
class GameScores {
    var hits: Int?
    var misses: Int?
    var leader: Leader?
    var asteroids: Int?
    init(){}
    init(h: Int, m: Int) {
        asteroids = h + m
        hits = h
        misses = m
        leader = Leader(n: Game.name, s: h)
    }
}
//MARK: Variables
var rootVC = UIApplication.shared.keyWindow?.rootViewController!
var leaderboard = [Leader]()
var publicDB = CKContainer.default().publicCloudDatabase
var startVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ViewController") as! ViewController
var lboardVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LeaderBoardVC") as! LeaderBoardVC
var gameVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "GameViewController") as! GameViewController
var pauseVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "pauseScreen") as! PauseScreen
var endScreenVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "EndScreen") as! EndScreen
var goToGameVC = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "goToGameVC") as! GoToGameVC
//MARK: Functions
func vw(_ i: CGFloat, _ v: UIView) -> CGFloat {
    return i * v.bounds.width/100
}
func vh(_ i: CGFloat, _ v: UIView) -> CGFloat {
    return 1 * v.bounds.height/100
}
func random(v: SKScene) -> CGPoint {
    return CGPoint(x: v.size.width * CGFloat.random(min: 0.1, max: 0.9), y: v.size.height * CGFloat.random(min: 0.1, max: 0.9))
}
func getDataFromUserDefaults(l: Leader? = nil) {
    if Game.launchedBefore == true {
        if let x = UserDefaults.standard.string(forKey: "udrecid") {
            getHighestScore(x: x)
        }
        Game.leaderboardEnabled = true
    }
}
func sortedLeaders() -> [Leader] {
    return leaderboard.sorted(by: { $0.score > $1.score })
}
func asteroid_name() -> String {
    var imageNames = ["asteroid-1", "asteroid-2", "asteroid-3", "asteroid-4"]
    let randomNumber = Int(arc4random_uniform(UInt32(imageNames.count)))
    return imageNames[randomNumber]
}
func asteroidImage() -> UIImage {
    return UIImage(named: "asteroid-1")!
}
func isX() -> Bool {
    var returnValue = false
    if UIDevice().userInterfaceIdiom == .phone {
        if UIScreen.main.nativeBounds.height == 2436 {
            returnValue = true
        } else {
            returnValue = false
        }
    }
    return returnValue
}
func customizePopup() {
    let appearance = PopupDialogDefaultView.appearance()
    appearance.backgroundColor = UIColor.blue
    appearance.messageColor = UIColor.black
    appearance.titleColor = UIColor.white
    appearance.messageFont = UIFont(name: "Avenir-Heavy", size: 18.0)!
    appearance.titleFont = UIFont(name: "Avenir-Black", size: 24.0)!
    let buttonAppearance = DefaultButton.appearance()
    buttonAppearance.backgroundColor = UIColor.black
    buttonAppearance.titleColor = UIColor.blue
    buttonAppearance.titleFont = UIFont(name: "Avenir-Black", size: 24.0)!
    let overlayAppearance = PopupDialogOverlayView.appearance()
    overlayAppearance.color = UIColor.darkGray
    overlayAppearance.blurRadius      = 20
    overlayAppearance.blurEnabled     = true
    overlayAppearance.liveBlurEnabled = false
    overlayAppearance.opacity         = 0.7
}
//MARK: CloudKit Functions
func iCloudLogin() -> Bool {
    var s = true
    CKContainer.default().accountStatus { (accountStatus, error) in
        if case .available = accountStatus {
            s = true
        } else {
            s = false
        }
    }
    return s
}
func getHighestScore(x: String) {
    Game.scoreRecordID = CKRecordID(recordName: x)
    publicDB.fetch(withRecordID: Game.scoreRecordID!) { (recopr, err) in
        if let error = err {
            print(error)
            Game.scoreRecordID = nil
        } else {
            if let record = recopr {
                Game.highestScore = record["score"] as? Int ?? {
                    print("the score is not available!!")
                    return 0
                    }()
                print("game record value is \(record["score"] as! Int)")
            } else {
                Game.scoreRecordID = nil
            }
        }
    }
}
func getData(_ tv: LeaderBoardVC?, _ force: Bool){
    if force == true {
        leaderboard = [Leader]()
    }
    var number = 0
    let query = CKQuery(recordType: "Leader", predicate: NSPredicate(value: true))
    publicDB.perform(query, inZoneWith: nil) { (recs, error) in
        if error != nil {
            print(error?.localizedDescription as Any)
        } else {
        if let records = recs {
            leaderboard = [Leader]()
            for record in records {
                let lead = Leader(n: (record["name"] as! String), s: (record["score"] as! Int))
                if leaderboard.count == number {
                    let serialQueue = DispatchQueue(label: "myqueue")
                    serialQueue.sync {
                        leaderboard.append(lead)
                    }
                    number += 1
                } else {
                    leaderboard = [Leader]()
                    print("hasvalues")
                }
            }
            print(leaderboard.count)
        } else {
            print("no records?????")
        }
    }
        if let table = tv {
            DispatchQueue.main.async {
                table.tableView.reloadData()
            }
        }
    }
}
func updateScore(l: Leader, rcid: CKRecordID) {
    publicDB.fetch(withRecordID: rcid) { (record, error) in
        if error != nil {
            print(error?.localizedDescription as Any)
        }
        record?.setObject(l.score as CKRecordValue, forKey: "score")
        if record != nil {
            publicDB.save(record!, completionHandler: { (rec, err) in
                if err != nil {
                    print(err!.localizedDescription as Any)
                }
            })
        }
        print("updated record")
    }
}
func createLeader(l: Leader) {
    getDataFromUserDefaults()
    print("highest score is \(Game.highestScore)")
    print("score is \(l.score)")
    getDataFromUserDefaults(l: l)
    if Game.leaderboardEnabled == true {
        getDataFromUserDefaults(l: l)
        if let recordID = Game.scoreRecordID {
            print("recordID is available with name as \(recordID.recordName)")
            getDataFromUserDefaults()
            print("game.highestScore is \(Game.highestScore)")
            print("score is \(l.score)")
            if l.score > Game.highestScore {
                print("score is higher than \(Game.highestScore)")
                updateScore(l: l, rcid: recordID)
                UserDefaults.standard.set(l.score, forKey: "highestScore")
            } else {
                print("scorelowerthanlasttime: lastScore = \(Game.highestScore)")
            }
        } else {
            print("record id is not available")
            let record = CKRecord(recordType: "Leader")
            record.setValue((l.name as CKRecordValue), forKey: "name")
            record.setValue((l.score as CKRecordValue), forKey: "score")
            publicDB.save(record) { (rec, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    print("addedRecord")
                    Game.scoreRecordID = rec?.recordID
                    UserDefaults.standard.set(rec?.recordID.recordName, forKey: "udrecid")
                }
            }
            getData(nil, false)
        }
    } else {
        print("notenabled")
    }
}
