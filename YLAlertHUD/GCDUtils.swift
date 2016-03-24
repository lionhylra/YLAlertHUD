//
//  GCDUtils.swift
//
//
//  Created by HeYilei on 28/02/2016.
//  Copyright © 2016 Omni Market Tide. All rights reserved.
//

import Foundation

// MARK: - GCD
struct GCD {
    /**
     Equal to dispatch_get_main_queue()
     */
    static var MainQueue: dispatch_queue_t {
        return dispatch_get_main_queue()
    }
    
    /**
     Equal to dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.value), 0)
     */
    static var UserInteractiveQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INTERACTIVE.rawValue), 0)
    }
    
    /**
     Equal to dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
     */
    static var UserInitiatedQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.rawValue), 0)
    }
    
    /**
     Equal to dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.value), 0)
     */
    static var UtilityQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_UTILITY.rawValue), 0)
    }
    
    /**
     Equal to dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.value), 0)
     */
    static var BackgroundQueue: dispatch_queue_t {
        return dispatch_get_global_queue(Int(QOS_CLASS_BACKGROUND.rawValue), 0)
    }
    
    /**
     Equal to dispatch_get_global_queue(Int(QOS_CLASS_USER_INITIATED.value), 0)
     */
    static var GlobalQueue: dispatch_queue_t {
        return UserInitiatedQueue
    }
}

/**
Run closure on UserInitiatdQueue
*/
func runOnGlobalQueue(task:()->Void){
    dispatch_async(GCD.GlobalQueue, task)
}

func runOnMainQueue(task:()->Void){
    dispatch_async(GCD.MainQueue, task)
}
/**
 Run closure on MainQueue after given seconds
 */
func runTaskAfter(delayInSeconds:NSTimeInterval, task:()->Void){
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delayInSeconds * Double(NSEC_PER_SEC))),
        dispatch_get_main_queue(),
        task
    )
}
/**
 Run closure on a concurrentQueue
 */
func runBarrierTask(concurrentQueue:dispatch_queue_t, task:()->Void){
    dispatch_barrier_async(concurrentQueue, task)
}
/**
 Create a concurrent queue
 */
func createConcurrentQueue(queueIdentifier identifier:String)->dispatch_queue_t!{
    return dispatch_queue_create(identifier, DISPATCH_QUEUE_CONCURRENT)
}