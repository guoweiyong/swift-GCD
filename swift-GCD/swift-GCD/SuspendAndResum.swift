//
//  SuspendAndResum.swift
//  swift-GCD
//
//  Created by yunyi on 2020/5/4.
//  Copyright © 2020 HLB. All rights reserved.
//

import UIKit

class SuspendAndResum: NSObject {
    
    /// 创建一个并发队列
    let concurrentQueue = DispatchQueue(label: "com.concurrentQeueu", attributes: [.concurrent])
    
    /// 挂起的次数
    var suspendCount = 0
    
    
    //MARK: --  队列方法
    
    /// 挂起队列测试方法
    func suspendQueue() -> Void {
        print("suspend queue start test")
        concurrentQueue.async {
            print("任务1concurrentQueue.async   ======",Thread.current)
        }
        concurrentQueue.async {
            print("任务2concurrentQueue.async   ======",Thread.current)
        }
        
        //添加栅栏任务
        let workeitem = DispatchWorkItem(qos: DispatchQoS.unspecified, flags: DispatchWorkItemFlags.barrier) {
            print("add barrire =======",Thread.current)
            self.safeSuspend(self.concurrentQueue)
        }
        concurrentQueue.async(execute: workeitem)
        
        concurrentQueue.async {
            print("任务3concurrentQueue.async   ======",Thread.current)
        }
        
        concurrentQueue.async {
            print("任务4concurrentQueue.async   ======",Thread.current)
        }
        
        print("suspend queue end test")
    }
    
    
    /// 唤醒队列测试方法
    func resumeQueue() -> Void {
        safeResume(concurrentQueue)
    }
    
    /// 安全挂起
    /// - Parameter queue: <#queue description#>
    func safeSuspend(_ queue: DispatchQueue) -> Void {
        //记录挂起次数
        suspendCount += 1
        queue.suspend()
        print("任务挂起了")
    }
    
    
    /// 安全唤醒
    /// - Parameter queue: <#queue description#>
    func safeResume(_ queue: DispatchQueue) -> Void {
        if suspendCount == 1 {
            queue.resume()
            suspendCount = 0
            print("任务唤醒了")
        } else if suspendCount < 1 {
            print("唤醒任务次数过多-----")
            
        } else {
            queue.resume()
            suspendCount -= 1
            print("唤醒次数不够，还需要\(suspendCount)次唤醒")
        }
    }
    
}
