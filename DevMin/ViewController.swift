//
//  ViewController.swift
//  DevMin
//
//  Created by Justin Domnitz on 9/29/15.
//  Copyright © 2015 Lowyoyo, LLC. All rights reserved.
//

import UIKit
import WatchConnectivity //WCSession

class ViewController: UIViewController, WCSessionDelegate {
    
    /** Called when all delegate callbacks for the previously selected watch has occurred. The session can be re-activated for the now selected watch using activateSession. */
    @available(iOS 9.3, *)
    func sessionDidDeactivate(_ session: WCSession) {
        //to do
    }
    
    /** Called when the session can no longer be used to modify or add any new transfers and, all interactive messages will be cancelled, but delegate callbacks for background transfers can still occur. This will happen when the selected watch is being changed. */
    @available(iOS 9.3, *)
    func sessionDidBecomeInactive(_ session: WCSession) {
        //to do
    }
    
    /** Called when the session has completed activation. If session state is WCSessionActivationStateNotActivated there will be an error with more details. */
    @available(iOS 9.3, *)
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //to do
    }

    @IBOutlet weak var navyButtony: UIButton!
    @IBOutlet weak var goldButtony: UIButton!
    @IBOutlet weak var watchColorButtony: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        WCSession.default().delegate = self
        WCSession.default().activate()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        WCSession.default().delegate = self
        WCSession.default().activate()
    }
    
    @IBAction func navyButton(_ sender: UIButton) {
        let watchMessage:Dictionary<String,AnyObject> = ["color":"navy" as AnyObject]
        sendMessage(watchMessage)
    }

    @IBAction func goldButton(_ sender: AnyObject) {
        let watchMessage:Dictionary<String,AnyObject> = ["color":"gold" as AnyObject]
        sendMessage(watchMessage)
    }
    
    func navy() {
        DispatchQueue.main.async(execute: {
            print("navy")
            self.watchColorButtony.backgroundColor = UIColor.blue
        })
    }
    
    func gold() {
        DispatchQueue.main.async(execute: {
            print("gold")
            self.watchColorButtony.backgroundColor = UIColor.yellow
        })
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        
        if message["color"] as! String == "navy" {
            navy()
        }
        if message["color"] as! String == "gold" {
            gold()
        }
        
        var replyValues = Dictionary<String, AnyObject>()
        let status = "\(Date()): iPhone message: App received and processed a message."
        print(status)
        replyValues["status"] = status as AnyObject
        
        replyHandler(replyValues)
    }
    
    func sendMessage(_ watchMessage: Dictionary<String, AnyObject>) {
        
        var session: WCSession!
        
        if WCSession.isSupported() {
            session = WCSession.default()
            session.delegate = self
            session.activate()
            
            let watchTotal = watchMessage
            
            session.transferCurrentComplicationUserInfo(watchTotal)
        }
    }
}

