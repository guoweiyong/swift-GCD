//
//  ViewController.swift
//  swift-GCD
//
//  Created by x on 2017/5/11.
//  Copyright © 2017年 HLB. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var timer: DispatchSourceTimer?

    override func viewDidLoad() {
        super.viewDidLoad()
        //串行队列和主队列的比较  (证明主线程也是一个串行队列)
        //simpleSQueue()
        
        //异步线程和主线程队列比较
        //simpleAsQueue()
        //testSyncInSerialQueue()
        //testAsyncInConcurrent()
        //testSyncInSerialQueue2()
        //testAsyncInConcurrent2()
        //testAsyncInSerial()
        //testAsyncTaskNestedInSameSerialQueue()
        
        //barrir()
        //concurrentPerformTask()
//        dispatch_later(2) {
//            print("dispatch_after 延迟执行任务====",Thread.current,Date())
//        }
        
        //group()
//        group2()
        //group3()
       // dispatchTimer()
        dispatchTimer2()
        
        
        //GCD两个异步线程执行 attributes参数的不同执行情况不同
        //qosConcurrentQueues()
        //qosConcurrentQueues2()
        
        //GCD比较两个不同优先级的队列执行情况 (优先执行优先级比较高的)
        //qosQueue1()
        
        //GCD延迟执行函数队列
        //delayAction()
        
        //DispatchWorkItem
        //workItemtest()
        
    }
    //1.'serial'(串行) vs 'concurrent'（并行）
    //1.1创建一个DispatchQueue方法
    //let queue = DispatchQueue(label: "com.sys.nd")
    
    
    /// 挂起
    /// - Parameter sender: <#sender description#>
    @IBAction func suspendbtnClick(_ sender: UIButton) {
        
        suspendAndResume.suspendQueue()
    }
    
    /// 唤醒
    /// - Parameter sender: <#sender description#>
    @IBAction func resumeBtnClick(_ sender: UIButton) {
        suspendAndResume.resumeQueue()
    }
    //创建队列的挂起和唤醒类
    private lazy var suspendAndResume = SuspendAndResum()
    
    
    
}
extension ViewController {
    
    /// 获取队列
    func getQueue() -> Void {
        //获取主队列
        let mainQueue = DispatchQueue.main
        
        //获取全局并发队列
        let globleQueue = DispatchQueue.global()
        
    }
}

// DispatchQueue
extension ViewController {
    /// 创建一个普通队列 比较同步(串行队列和主队列的区别)
    func simpleSQueue() -> Void {
        let queue = DispatchQueue(label: "com.syc.nd")
        //同步执行队列
        queue.sync {
            for i in 1...3 {
                print("同步执行队列---😄  current Thread====",i,Thread.current)
            }
        }
        //同步主队列执行
        for j in 100...103 {
            print("同步主队列---😭 current Thread======",j,Thread.current);
        }
    }
    
    /// 异步(并行)队列执行  和主线程的差别
    func simpleAsQueue() -> Void {
        let queue = DispatchQueue(label: "com.syc.nd")
        //创建并行队列
        //let concurrentQueue = DispatchQueue(label: "com.xxx.xxx.queueName", attributes: .concurrent)
        
        //异步执行
        queue.async {
            for i in 1...3 {
                print("异步执行队列---👀 current Thread====",i,Thread.current)
            }
        }
        //同步主执行队列
        for j in 100...103 {
            print("同步主线程队列---💰current Thread====",j,Thread.current)
        }
    }
    //创建队列参数解释
    func simpleConcurrentQueue() -> Void {
        
        /**
         创建一个队列
         @param label : 队列名称
         @param qos : (服务质量等级)队列的优先级，如果没有指定值，会使用默认的属性 unspecified (不指定优先级)
            优先级 : userInteractive > userInitiated > default > utility > background > unspecified
         
            public static let userInteractive: DispatchQoS 用户交互
            public static let userInitiated: DispatchQoS 用户发起
            public static let `default`: DispatchQoS 默认优先级
            public static let utility: DispatchQoS 对应oc中的low 低
            public static let background: DispatchQoS  后台
            public static let unspecified: DispatchQoS  不指定优先级
         
         @param attributes: 选项集合 包含两个选项
            concurrent ： 表示队列为并行队列
            initiallyInactive：标识队列中的任务需要手动触发，由队列的activate方法来触发 如果未添加此标识，向队列中添加的任务会自动运行
            如果不设置该值 表示创建的是串行队列， 如果希望创建的是并行队列，并且需要手动触发的话，需要添加值 [.concurrent, .initiallyInactive]  如果不需要的话 直接传[]
         
         @param autoreleaseFrequency: 类型为枚举类型 用来设置管理任务内对象生命周期的 autorelease pool 的自动释放频率 包含三个类型：
            case inherit 集成目标队列的该属性
            case workItem  跟随每个任务的执行周期进行自动创建和是释放
            case never 不会自动创建 autorelease pool 需要自己手动管理
         
            一般采用workItem就可以了，如果任务中需要大量重复创建对象，可以使用never属性，来手动创建 autorelease pool
         
         @param : target 这个参数设置了队列的目标队列，即队列中的任务运行时实际所在的队列。目标队列最终约束了队列的优先级等属性。
            在程序中手动创建的队列最后都指向了系统自带的主队类或全局并发队列
         
         那为什么不直接将任务添加到系统队列中，而是自定义队列呢？这样的好处是可以将任务分组管理。如单独阻塞某个队列中的任务，而不是阻塞系统队列中的全部任务。如果阻塞了系统队列，所有指向它的原队列也就被阻塞。
         
         
         */
        let concurrentQueue = DispatchQueue.init(label: "concurrentQueue", qos: DispatchQoS.default, attributes: [.concurrent, .initiallyInactive], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: DispatchQueue?.none)
        
    }
    
    /// 串行队列中添加本队列的同步任务
    func testSyncInSerialQueue() -> Void {
        let serialQueue = DispatchQueue(label: "com.SerialQueue")
       //异步执行
        serialQueue.async {
            for i in 1...3 {
                print("异步执行队列---👀 current Thread====",i,Thread.current)
            }
            serialQueue.sync {
                print("串行队列中添加本队列的同步任务=====")
            }
        }
        
        print("end test")
    }
    
    /// 并行队列嵌套本队列同步任务
    func testAsyncInConcurrent() -> Void {
        let concurrentQueue = DispatchQueue(label: "com.concurrentQueue", attributes: [.concurrent])
        concurrentQueue.async {
            print("异步执行函数=====")
            
            concurrentQueue.sync {
                print("同步函数执行====")
            }
        }
        
    }
    
    /// 串行队列嵌套其他队列同步任务
    func testSyncInSerialQueue2() -> Void {
        let serialQueue = DispatchQueue(label: "com.SerialQueue")
        let serialQueue2 = DispatchQueue(label: "com.SerialQueue2")
        
        serialQueue.sync {
            print("同步函数执行====")
            serialQueue2.sync {
                print("串行队列中嵌套其他队列的同步任务")
            }
        }
        
    }
    
    /// 并行队列中 增加异步任务
    func testAsyncInConcurrent2() -> Void {
        let concurrentQueue = DispatchQueue(label: "com.concurrentQueue", attributes: [.concurrent])
        concurrentQueue.async {
            print("并行队列中 增加异步任务 ===== ",Thread.current)
        }
    }
    
    /// 串行队列中增加易步任务
    func testAsyncInSerial() -> Void {
        let serialQueue = DispatchQueue(label: "com.serialQueue", attributes: [.concurrent])
        serialQueue.async {
            print("串行队列中 增加异步任务 ===== ",Thread.current)
        }
    }
    
    /// 串行队列嵌套本队列的异步任务
    func testAsyncTaskNestedInSameSerialQueue() -> Void {
        let serialQueue = DispatchQueue(label: "com.serialQueue", attributes: [.concurrent])
        serialQueue.sync {
            print("串行队列中 同步任务 ===== ",Thread.current)
            
            serialQueue.async {
                print("串行队列中嵌套本队列的异步任务 ===== ",Thread.current)
            }
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

// GCD其他服务
extension ViewController {
    //栅栏
    func barrir() -> Void {
        let queue = DispatchQueue(label: "queueBarrir", attributes: [.concurrent])
        /**
         public static let barrier: DispatchWorkItemFlags  //栅栏任务

         
         public static let detached: DispatchWorkItemFlags

         
         public static let assignCurrentContext: DispatchWorkItemFlags

         
         public static let noQoS: DispatchWorkItemFlags

         
         public static let inheritQoS: DispatchWorkItemFlags

         
         public static let enforceQoS: DispatchWorkItemFlags
         */
        let task = DispatchWorkItem(qos: DispatchQoS.default, flags: DispatchWorkItemFlags.barrier) {
            print("实现栅栏任务======",Thread.current)
        }
        
        queue.async {
            print("任务1=======",Thread.current)
        }
        queue.async {
            print("任务2=======",Thread.current)
        }
        
        queue.async(execute: task)
        
        queue.async {
            print("任务3=======",Thread.current)
        }
        queue.async {
            print("任务4=======",Thread.current)
        }
    }
    
    //迭代器
    func concurrentPerformTask() -> Void {
        //1.单独创建 iterations： 为迭代次数 可以修改
//        DispatchQueue.concurrentPerform(iterations: 10) { (index) in
//            print("current thread====== ",Thread.current, index)
//        }
        
        //放在指定的队列中
        DispatchQueue.global().async {
            DispatchQueue.concurrentPerform(iterations: 5) { (index) in
                print("current thread====== ",Thread.current, index)
            }
        }
    }
    
    //延迟执行函数 ()
    func dispatch_later(_ time: TimeInterval, block: @escaping ()-> ()) -> Void {
        print("任务在\(time)秒后执行",Date())
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time, execute: block)
    }
    
    
}

// 任务组
extension ViewController {
    
    func group() -> Void {
        let queueGroup = DispatchGroup()
    
        let queue = DispatchQueue.global()
        
        queue.async(group: queueGroup, execute: DispatchWorkItem(block: {
            print("任务1-----",Thread.current)
        }))
        
        queue.async(group: queueGroup, execute: DispatchWorkItem(block: {
            print("任务2-----",Thread.current)
        }))
        queue.async(group: queueGroup, execute: DispatchWorkItem(block: {
            print("任务3-----",Thread.current)
        }))
        queue.async(group: queueGroup, execute: DispatchWorkItem(block: {
            print("任务4-----",Thread.current)
        }))
        
        queueGroup.notify(queue: DispatchQueue.main) {
            print("任务组中所有的任务都完成了,可以执行下步操作-----")
        }
        
    }
    
    func group2() -> Void {
        let queueGroup = DispatchGroup()
        
        let queue = DispatchQueue.global()
        
        queueGroup.enter()
        queue.async {
            print("任务1-----",Thread.current)
            queueGroup.leave()
        }
        
        queueGroup.enter()
        queue.async {
            print("任务2-----",Thread.current)
            queueGroup.leave()
        }
        
        queueGroup.notify(queue: DispatchQueue.main) {
            print("任务组中所有的任务都完成了,可以执行下步操作-----")
        }
        
    }
    
    func group3() -> Void {
        let queueGroup = DispatchGroup()
        
        let queue = DispatchQueue.global()
        
        queueGroup.enter()
        queue.async {
            print("任务1-----",Thread.current)
            queueGroup.leave()
        }
        
        queueGroup.enter()
        queue.async {
            print("任务2-----",Thread.current)
            queueGroup.leave()
        }
        
        queueGroup.wait()
        
        print("任务组中所有的任务都完成了,可以执行下步操作-----")
        
        queueGroup.wait(timeout: DispatchTime.now() + 2)
        
    }
}

extension ViewController {
    func dispatchTimer() -> Void {
        //GCD定时器
        timer = DispatchSource.makeTimerSource()
        /**
         @param : deadline  延迟时间（多久时间以后开始执行）
         @param : repeating 重复执行时间 DispatchTimeInterval类型时间
         @param ：leeway 误差时间 0： 表示没有误差
         */
        timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(Int(2)), leeway: DispatchTimeInterval.microseconds(0))
        //没有设置重复时间的默认是执行一次
        //timer?.schedule(deadline: DispatchTime.now())
        timer?.setEventHandler {
            print("定时器处理器执行block=====",Thread.current)
            
        }
        timer?.resume()
        
    }
    
    func dispatchTimer2() -> Void {
        //GCD定时器
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        
        timer?.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.seconds(Int(2)), leeway: DispatchTimeInterval.microseconds(0))
        timer?.setEventHandler {
            print("定时器处理器执行block=====",Thread.current)
            
        }
        timer?.resume()
        
    }
    
}
