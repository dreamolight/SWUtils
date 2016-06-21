//
//  SWToolKit.swift
//  ReservationClient
//
//  Created by Stan Wu on 15/3/29.
//  Copyright (c) 2015 Stan Wu. All rights reserved.
//

import Foundation
import UIKit

struct SWDefinitions {
    static let ScreenWidth = UIScreen.mainScreen().bounds.width
    static let ScreenHeight = UIScreen.mainScreen().bounds.height
    
    static let RETURN_SUCCESS_CODE = 200
}

public func sw_dispatch_on_main_thread(block: dispatch_block_t){
    dispatch_sync(dispatch_get_main_queue(), block)
}

public func sw_dispatch_on_background_thread(block: dispatch_block_t){
    if !NSThread.currentThread().isMainThread{
        block()
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block)
    }
}

class SWUtils{
    class func RunOnMainThread(block: dispatch_block_t){
        if NSThread.isMainThread(){
            block()
        }else{
            dispatch_sync(dispatch_get_main_queue(), block)
        }
    }
    
    class func RunOnBackgroundThread(block: dispatch_block_t){
        if !NSThread.isMainThread(){
            block()
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),block);
        }
    }
    
//    class func is_jailbroken() -> Bool{
//        return UIApplication.sharedApplication().canOpenURL(NSURL(string: "cydia://package/com.example.package")!)
//    }
    
    
}