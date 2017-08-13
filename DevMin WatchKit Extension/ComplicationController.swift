//
//  ComplicationController.swift
//  DevMin WatchKit Extension
//
//  Created by Justin Domnitz on 9/29/15.
//  Copyright © 2015 Lowyoyo, LLC. All rights reserved.
//

import ClockKit

class ComplicationController: NSObject, CLKComplicationDataSource {
    
    var gaTechFootballSchedule:[Dictionary<String,AnyObject>] =
       [["Game time":"Sat, Oct 10 - 3:30 PM" as AnyObject,
            "Opponent":"Clemson" as AnyObject,
            "Location":"Away" as AnyObject],
        ["Game time":"Sat, Oct 17 - TBD" as AnyObject,
            "Opponent":"Pittsburgh" as AnyObject,
            "Location":"Home" as AnyObject],
        ["Game time":"Sat, Oct 24 - TBD" as AnyObject,
            "Opponent":"Florida State" as AnyObject,
            "Location":"Home" as AnyObject]]
    
    var gaTechFootballWinLikely:[Dictionary<String,AnyObject>] =
    [["Win likely percent":50 as AnyObject],
        ["Win likely percent":80 as AnyObject],
        ["Win likely percent":25 as AnyObject]]

    // MARK: - Timeline Configuration
    
    override init() {
    }
    
    func requestedUpdateDidBegin() {
    }
    
    func requestedUpdateBudgetExhausted() {
    }
    
    func getSupportedTimeTravelDirections(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTimeTravelDirections) -> Void) {
        handler([.forward, .backward])
    }
    
    func getTimelineStartDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow: -(60 * 60 * 24))) // one day in the past
    }
    
    func getTimelineEndDate(for complication: CLKComplication, withHandler handler: @escaping (Date?) -> Void) {
        handler(Date(timeIntervalSinceNow:  (60 * 60 * 24))) // one day in the future
    }
    
    func getPrivacyBehavior(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationPrivacyBehavior) -> Void) {
        handler(.showOnLockScreen)
    }
    
    // MARK: - Timeline Population
    
    func getCurrentTimelineEntry(for complication: CLKComplication, withHandler handler: (@escaping (CLKComplicationTimelineEntry?) -> Void)) {
        switch complication.family {
        case .modularLarge:
            if gaTechFootballSchedule.count > 0 {
                handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getModularLargeTemplate(gaTechFootballSchedule[0])!))
                gaTechFootballSchedule.remove(at: 0)
            }
            else {
                handler(nil)
            }
        case .modularSmall:
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getModularSmallTemplate()!))
        case .utilitarianLarge:
            handler(nil)
        case .utilitarianSmall:
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getUtilitarianSmallTemplate()!))
        case .circularSmall:
            if gaTechFootballWinLikely.count > 0 {
            handler(CLKComplicationTimelineEntry(date: Date(), complicationTemplate: getCircularSmallTemplate(gaTechFootballWinLikely[0])!))
            gaTechFootballWinLikely.remove(at: 0)
            }
            else {
                handler(nil)
            }
        default:
            handler(nil)
        }
    }
    
    //before
    func getTimelineEntries(for complication: CLKComplication, before date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        handler(nil)
    }
    
    //after
    func getTimelineEntries(for complication: CLKComplication, after date: Date, limit: Int, withHandler handler: (@escaping ([CLKComplicationTimelineEntry]?) -> Void)) {
        
        var nowDate = Date()
        if Date(timeInterval: 60*60, since: nowDate) < date {
            nowDate = Date(timeInterval: 60*60, since: date)
        }
        
        switch complication.family {
        case .modularLarge:
            if gaTechFootballSchedule.count > 0 && gaTechFootballSchedule.count <= limit {
                handler([CLKComplicationTimelineEntry(date: nowDate, complicationTemplate: getModularLargeTemplate(gaTechFootballSchedule[0])!)])
                gaTechFootballSchedule.remove(at: 0)
            }
            else {
                handler(nil)
            }
        case .modularSmall:
            if let template = getModularSmallTemplate() {
                handler([CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)])
                return
            }
        case .utilitarianLarge:
            handler(nil)
        case .utilitarianSmall:
            if let template = getUtilitarianSmallTemplate() {
                handler([CLKComplicationTimelineEntry(date: Date(), complicationTemplate: template)])
                return
            }
        case .circularSmall:
            if gaTechFootballWinLikely.count > 0 && gaTechFootballWinLikely.count <= limit {
                handler([CLKComplicationTimelineEntry(date: nowDate, complicationTemplate: getCircularSmallTemplate(gaTechFootballWinLikely[0])!)])
                gaTechFootballWinLikely.remove(at: 0)
            }
            else {
                handler(nil)
            }
        default:
            handler(nil)
        }
    }
    
    func getNextRequestedUpdateDate(handler: @escaping (Date?) -> Void) {
        handler(Date(timeInterval: 60 * 15, since: Date()))
    }
    
    // MARK: - Templates
    
    func getPlaceholderTemplate(for complication: CLKComplication, withHandler handler: @escaping (CLKComplicationTemplate?) -> Void) {
        let schedule:Dictionary<String,AnyObject> = ["Game time":"..." as AnyObject,
            "Opponent":"..." as AnyObject,
            "Location":"..." as AnyObject,
            "Win likely percent":0 as AnyObject]
        switch complication.family {
        case .modularLarge:
            handler(getModularLargeTemplate(schedule)!)
        case .modularSmall:
            handler(getModularSmallTemplate())
        case .utilitarianLarge:
            handler(nil)
        case .utilitarianSmall:
            handler(getUtilitarianSmallTemplate())
        case .circularSmall:
            handler(getCircularSmallTemplate(schedule)!)
        default:
            break
        }
    }
    
    func getModularSmallTemplate() -> CLKComplicationTemplate? {
        let template = CLKComplicationTemplateModularSmallColumnsText()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Go"       , shortText: "Go"  )
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: ""         , shortText: ""    )
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Jackets!" , shortText: "GT!" )
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: ""         , shortText: ""    )
        return template
    }
    
    func getUtilitarianSmallTemplate() -> CLKComplicationTemplate? {
        let template = CLKComplicationTemplateUtilitarianSmallFlat()
        template.textProvider = CLKSimpleTextProvider(text: "GT", shortText: "GT")
        return template
    }
    
    func getModularLargeTemplate(_ schedule: Dictionary<String,AnyObject>) -> CLKComplicationTemplate? {
        let template = CLKComplicationTemplateModularLargeColumns()
        template.row1Column1TextProvider = CLKSimpleTextProvider(text: "Game time", shortText: "Time")
        template.row2Column1TextProvider = CLKSimpleTextProvider(text: "Opponent", shortText: "Opp")
        template.row3Column1TextProvider = CLKSimpleTextProvider(text: "Location", shortText: "Loc")
        template.row1Column2TextProvider = CLKSimpleTextProvider(text: schedule["Game time"] as! String, shortText: schedule["Game time"] as? String)
        template.row2Column2TextProvider = CLKSimpleTextProvider(text: schedule["Opponent"] as! String, shortText: schedule["Opponent"] as? String)
        template.row3Column2TextProvider = CLKSimpleTextProvider(text: schedule["Location"] as! String, shortText: schedule["Location"] as? String)
        template.row1ImageProvider = CLKImageProvider(onePieceImage: UIImage(named: "NCAA-Georgia_Tech-Helmet-732px_apha")!)
        template.column2Alignment = .trailing
        return template
    }
    
    func getCircularSmallTemplate(_ schedule: Dictionary<String,AnyObject>) -> CLKComplicationTemplate? {
        let template = CLKComplicationTemplateCircularSmallRingImage()
        template.imageProvider = CLKImageProvider(onePieceImage: UIImage(named: "NCAA-Georgia_Tech-Helmet-732px_apha")!)
        template.ringStyle = .closed
        template.fillFraction = (schedule["Win likely percent"] as? Float ?? 0) / 100
        return template
    }
}

/*
extension Date: Comparable {}

// operator method names only allowed at global scope
public func < (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedAscending
}

public func > (lhs: Date, rhs: Date) -> Bool {
    return rhs.compare(lhs) == .orderedAscending
}

public func == (lhs: Date, rhs: Date) -> Bool {
    return lhs.compare(rhs) == .orderedSame
}
*/
