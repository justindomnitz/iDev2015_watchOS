//
//  WatchInterface.swift
//  DevMin
//
//  Created by Justin Domnitz on 9/29/15.
//  Copyright © 2015 DevMin. All rights reserved.
//

import UIKit
import WatchConnectivity

class WatchInterface: NSObject, WCSessionDelegate {
    
    override init() {
        super.init()
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject], replyHandler: ([String : AnyObject]) -> Void) {
        print(message)
        var replyValues = Dictionary<String, AnyObject>()
        let status = "\(NSDate()): iPhone message: App received and processed a message."
        print(status)
        replyValues["status"] = status
        replyHandler(replyValues)
    }
    
    func sendMessage(watchMessage: Dictionary<String, AnyObject>) {
        
        var session: WCSession!
    
        if WCSession.isSupported() {
            session = WCSession.defaultSession()
            session.delegate = self
            session.activateSession()
        
            let watchTotal = watchMessage
            
            session.transferCurrentComplicationUserInfo(watchTotal)
        }
    }
    
    func session(session: WCSession, didReceiveMessage message: [String : AnyObject]) {
        let status = "\(NSDate()): iPhone message: Watch Interface received and processed message."
        print(status)
        
        if message["color"] as! String == "navy" {
            delegate.navy()
        }
        if message["color"] as! String == "gold" {
            delegate.gold()
        }
    }
}