//
//  SWDataToolKit.swift
//  ReservationClient
//
//  Created by Stan Wu on 15/3/29.
//  Copyright (c) 2015 Stan Wu. All rights reserved.
//

import Foundation
import UIKit
import AdSupport

extension String{
    static func UUIDString() -> String{
        var UUID : String?

        let device = UIDevice.currentDevice()
        if device.respondsToSelector("identifierForVendor") {
            UUID = ASIdentifierManager.sharedManager().advertisingIdentifier.UUIDString
        }else{
            UUID = NSUserDefaults.standardUserDefaults().objectForKey("UUID") as! String?
            if UUID == nil{
                let uuidref:CFUUIDRef = CFUUIDCreate(nil);
                let uuidstr:CFStringRef = CFUUIDCreateString(nil, uuidref);
                UUID = uuidstr as String;
                
                NSUserDefaults.standardUserDefaults().setObject(UUID!, forKey: "UUID")
            }
        }

        
        return UUID!;
    }
        
    
    
    func bundlePath() -> String{
        return NSBundle.mainBundle().pathForResource(self, ofType: nil)!
    }
    
    func imageCachePath() -> String{
    
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        
        let imagesPath = (paths[0] as NSString).stringByAppendingPathComponent("images")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(imagesPath){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(imagesPath, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("ImageDirectoryExcluded"){
            let url = NSURL.fileURLWithPath(imagesPath)
            
//            var error:NSError?
            var success: Bool
            do {
                try url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
                success = true
            } catch _ as NSError {
//                error = error1
                success = false
            }
            
            if success{
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ImageDirectoryExcluded")
            }
        }
        
        let path = (imagesPath as NSString).stringByAppendingPathComponent(self)
        
        return path;
    }
    
    func documentPath() -> String{
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        
        let path = (paths[0] as NSString).stringByAppendingPathComponent(self)
        
        return path
    }
    
    func temporaryPath() -> String{
        
        var paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true);
        
        let imagesPath = (paths[0] as NSString).stringByAppendingPathComponent("tmp")
        
        if !NSFileManager.defaultManager().fileExistsAtPath(imagesPath){
            do {
                try NSFileManager.defaultManager().createDirectoryAtPath(imagesPath, withIntermediateDirectories: false, attributes: nil)
            } catch _ {
            }
        }
        
        if !NSUserDefaults.standardUserDefaults().boolForKey("TmpDirectoryExcluded"){
            let url = NSURL.fileURLWithPath(imagesPath)
            
//            var error:NSError?
            var success: Bool
            do {
                try url.setResourceValue(NSNumber(bool: true), forKey: NSURLIsExcludedFromBackupKey)
                success = true
            } catch _ as NSError {
//                error = error1
                success = false
            }
            
            if success{
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "TmpDirectoryExcluded")
            }
        }
        
        let path = (imagesPath as NSString).stringByAppendingPathComponent(self)
        
        return path;
    }

    func isValidPhone() -> Bool{
        let phoneRegex = "^1\\d{10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        
        
        return phoneTest.evaluateWithObject(self)
    }
    
    var length: Int{
        return self.characters.count
    }
    
    func drawInRect(rect: CGRect, withAttributes attrs: [String : AnyObject]?){
        (self as NSString).drawInRect(rect, withAttributes: attrs)
    }
    
}



extension NSDate{
    func dateString() -> String{
        let formatter = NSDateFormatter()
        formatter.timeZone = NSTimeZone.localTimeZone()
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        var strDate = formatter.stringFromDate(self)
        
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date1 = formatter.stringFromDate(self)
        let date2 = formatter.stringFromDate(NSDate())
        
        if date1==date2{
            formatter.dateFormat = "HH:mm"
            
            var timeInterval = NSDate().timeIntervalSinceDate(self)
            if timeInterval < 0{
                timeInterval = 0
            }
            
            if timeInterval > 3600{
                strDate = "今天\(formatter.stringFromDate(self))"
            }else{
                let min = Int(timeInterval/60)
                strDate = "\(min)分钟前"
            }
        }else{
            formatter.dateFormat = "yyyy-MM-dd 00:00"
            let tempdate = formatter.dateFromString(formatter.stringFromDate(NSDate()))
            if tempdate?.timeIntervalSinceDate(self) < 3600*24{
                formatter.dateFormat = "HH:mm"
                
                strDate = "昨天\(formatter.stringFromDate(self))"
            }else{
                formatter.dateFormat = "yyyy"
                let date1 = formatter.stringFromDate(self)
                let date2 = formatter.stringFromDate(NSDate())
                
                if date1==date2{
                    formatter.dateFormat = "MM-dd HH:mm"
                    strDate = formatter.stringFromDate(self)
                }
            }
        }

        return strDate;
    }
}