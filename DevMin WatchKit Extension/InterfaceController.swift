//
//  InterfaceController.swift
//  DevMin WatchKit Extension
//
//  Created by Justin Domnitz on 9/29/15.
//  Copyright © 2015 Lowyoyo, LLC. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity //WCSession
import ClockKit //CLKComplicationServer

class InterfaceController: WKInterfaceController, WCSessionDelegate {
    
    @IBOutlet var navyButton: WKInterfaceButton!
    @IBOutlet var goldButton: WKInterfaceButton!
    @IBOutlet var iPhoneButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        print("InterfaceController - \(#function)")

        super.awake(withContext: context)
        
        WCSession.default().delegate = self
        WCSession.default().activate()
    }
    
    override func willActivate() {
        print("InterfaceController - \(#function)")

        super.willActivate()

        WCSession.default().delegate = self
        WCSession.default().activate()
    }

    override func didDeactivate() {
        print("InterfaceController - \(#function)")

        super.didDeactivate()
    }
    
    @IBAction func navyButtonAction() {
        print("InterfaceController - \(#function)")

        let watchMessage:Dictionary<String,AnyObject> = ["color":"navy" as AnyObject]
        sendMessage(watchMessage)
    }
    
    @IBAction func goldButtonAction() {
        print("InterfaceController - \(#function)")
        
        let watchMessage:Dictionary<String,AnyObject> = ["color":"gold" as AnyObject]
        sendMessage(watchMessage)
    }
    
    func navy() {
        print("InterfaceController - \(#function)")
        
        iPhoneButton.setBackgroundColor(UIColor.blue)
    }
    
    func gold() {
        print("InterfaceController - \(#function)")
    
        iPhoneButton.setBackgroundColor(UIColor.yellow)
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("InterfaceController - \(#function)")
    }
    
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any]) {
        print("InterfaceController - \(#function)")
        
        print("\(Date()): Watch message: Extension Delegate received and processed userInfo.")
        
        if userInfo["color"] as! String == "navy" {
            navy()
        }
        if userInfo["color"] as! String == "gold" {
            gold()
        }
        
        updateComplicationTimelineData()
    }

    func sendMessage(_ watchMessage: Dictionary<String, AnyObject>) {
        print("InterfaceController - \(#function)")
        
        WCSession.default().sendMessage(watchMessage, replyHandler: { (content) in
            var respStatus = ""
            if  (content as NSDictionary)["status"] != nil {
                respStatus = (content as NSDictionary)["status"] as! String
            }
            print("iPhone response: " + respStatus)
        }) { (error) in
            print("Error encountered sending message from Watch app to iOS app: \(error.localizedDescription)")
        }
    }
    
    func updateComplicationTimelineData() {
        print("InterfaceController - \(#function)")
        
        let complicationServer = CLKComplicationServer.sharedInstance()
        if complicationServer.activeComplications != nil {
            if let activeComplications = complicationServer.activeComplications, activeComplications.count > 0 {
                for complication in activeComplications {
                    //complicationServer.reloadTimelineForComplication(complication)
                    complicationServer.extendTimeline(for: complication)
                }
            }
        }
    }
}
