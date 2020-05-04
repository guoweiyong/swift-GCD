//
//  DispatchSourceTest.swift
//  swift-GCD
//
//  Created by yunyi on 2020/5/4.
//  Copyright © 2020 HLB. All rights reserved.
//

import UIKit

class DispatchSourceTest: NSObject {
    
    var filePath: String = "\(NSTemporaryDirectory)"
    var counter = 0
    let queueGloble = DispatchQueue.global()
    
    
    override init() {
        super.init()
        
    }
    
    func startObserve(closure: @escaping () -> Void) -> Void {
        let fileURL = URL(fileURLWithPath: filePath)
        let monitoredDirectoryFileDescriptor = open(fileURL.path, O_EVTONLY)
        
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: monitoredDirectoryFileDescriptor,
            eventMask: .write, queue: queueGloble)
        source.setEventHandler(handler: closure)
        source.setCancelHandler {
            close(monitoredDirectoryFileDescriptor)
        }
        source.resume()
    }
    
    func changeFile() {
        DispatchSourceTest.createFile(name: "DispatchSourceTest.md", filePath: NSTemporaryDirectory())
        counter += 1
        let text = "\(counter)"
        try! text.write(toFile: "\(filePath)/DispatchSourceTest.md", atomically: true, encoding: String.Encoding.utf8)
        print("file writed.")
    }
    
    static func createFile(name: String, filePath: String){
        let manager = FileManager.default
        let fileBaseUrl = URL(fileURLWithPath: filePath)
        let file = fileBaseUrl.appendingPathComponent(name)
        print("文件: \(file)")
        
        // 写入 "hello world"
        let exist = manager.fileExists(atPath: file.path)
        if !exist {
            let data = Data(base64Encoded:"aGVsbG8gd29ybGQ=" ,options:.ignoreUnknownCharacters)
            let createSuccess = manager.createFile(atPath: file.path,contents:data,attributes:nil)
            print("文件创建结果: \(createSuccess)")
        }
    }
}
