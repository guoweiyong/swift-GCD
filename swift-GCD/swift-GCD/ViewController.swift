//
//  ViewController.swift
//  swift-GCD
//
//  Created by x on 2017/5/11.
//  Copyright © 2017年 HLB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //串行队列和主队列的比较  (证明主线程也是一个串行队列)
        //simpleSQueue()
        
        //异步线程和主线程队列比较
        //simpleAsQueue()
        
        //GCD两个异步线程执行 attributes参数的不同执行情况不同
        //qosConcurrentQueues()
        //qosConcurrentQueues2()
        
        //GCD比较两个不同优先级的队列执行情况 (优先执行优先级比较高的)
        //qosQueue1()
        
        //GCD延迟执行函数队列
        //delayAction()
        
        //DispatchWorkItem
        workItemtest()
    }
    //1.'serial'(串行) vs 'concurrent'（并行）
    //1.1创建一个DispatchQueue方法
    //let queue = DispatchQueue(label: "com.sys.nd")
}
// DispatchQueue
extension ViewController {
    /// 创建一个普通队列 比较同步(串行队列和主队列的区别)
    func simpleSQueue() -> Void {
        let queue = DispatchQueue(label: "com.syc.nd")
        //同步执行队列
        queue.sync {
            for i in 1...10 {
                print("同步执行队列---😄",i)
            }
        }
        //同步主队列执行
        for j in 100...110 {
            print("同步主队列---😭",j);
        }
    }
    
    /// 异步(并行)队列执行  和主线程的差别
    func simpleAsQueue() -> Void {
        let queue = DispatchQueue(label: "com.syc.nd")
        //异步执行
        queue.async {
            for i in 1...10 {
                print("异步执行队列---👀",i)
            }
        }
        //同步主执行队列
        for j in 100...105 {
            print("同步主线程队列---💰",j)
        }
    }
}

//GCD服务等级
extension ViewController {
    
    //serial(串行) 和 concurrent(并行)  
    //GCD的服务等级(GCD Qos):确定任务的重要和优先级的属性
    //Qos代表优先级  如果没有指定Qos 那么处事方法就会使用队列提供的默认的Qos值
    /*
     QoS等级(QoS classes)，从前到后，优先级从高到低:
     
     userInteractive  用户交互
     
     userInitiated 用户发起的
     
     default  默认
     
     utility 对应oc low 低
     
     background  后台
     
     unspecified 不指定优先级
     
     */
    
    /// 同个队列等级串行执行对比
    func qosConcurrentQueues() -> Void {
        //2.1首先创建一个Qos的队列
        //Qos需要传入一个DispatchQos的枚举类型
        let queue = DispatchQueue(label: "com.syc.nd", qos: DispatchQoS.unspecified, attributes: DispatchQueue.Attributes.init(rawValue: 0), autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none)
        queue.async {
            for i in 1...10 {
                print("GCD----异步线程1111-----",i)
            }
        }
        queue.async {
            for j in 100...110 {
                print("GCD-----异步线程2222-----",j)
            }
        }
    }
    
    /// 设置attributes参数的不同  队列的执行不同情况
    func qosConcurrentQueues2() -> Void {
        let queue = DispatchQueue(label: "com.syc.nd", qos: DispatchQoS.unspecified, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none)
        queue.async {
            for i in 1...10 {
                print("GCD----异步线程1111-----",i)
            }
        }
        queue.async {
            for j in 100...110 {
                print("GCD-----异步线程2222-----",j)
            }
        }
    }
    
    /// qos设置不同优先级队列的执行情况
    func qosQueue1() -> Void {
        let queue1 = DispatchQueue(label: "com.syc.nd1", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none)
        let queue2 = DispatchQueue(label: "com.syc.nd2", qos: DispatchQoS.utility, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none);
        queue1.async {
            for i in 1...10 {
                print("队列queue1-------", i)
            }
        }
        queue2.async {
            for j in 100...110 {
                print("队列queue2--------", j)
            }
        }
    }
    
    /// 延迟执行的函数
    func delayAction() -> Void {
        let delayQueue = DispatchQueue(label: "com.syc.nd", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.init(rawValue: 0), autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none)
        /*
         public enum DispatchTimeInterval {
         
         case seconds(Int) 秒
         
         case milliseconds(Int)毫秒
         
         case microseconds(Int)微秒
         
         case nanoseconds(Int)纳秒
         }

         */
        print("xianzi shijian ",Date());
        delayQueue.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.seconds(5)) {
            print("zhixingshijian,",Date())
        }
    }
    
    /// DispatchWorkItem是一个代码块，它可以被分到任何的队列，包含的代码可以在后台或主线程中被执行，简单来说:它被用于替换我们前面写的代码block来调用。使用起来也很简单
    func workItemtest() -> Void {
        var num = 9
        let workItem: DispatchWorkItem = DispatchWorkItem {
            num = num+5
        }
        //workItem.perform()//激活workItem代码块 会执行一次代码快
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
        //异步队列执行这个代码块
        queue.async(execute: workItem) //放在一步线程中会执行一次代码块
        
        workItem.notify(queue: DispatchQueue.main) { 
            print("workItem代码块已经完成执行的通知",num
            )
        }
    }
}
