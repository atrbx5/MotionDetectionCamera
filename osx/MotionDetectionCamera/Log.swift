//
//  Log.swift
//
//  Created by Andrey Pervushin on 12/7/16.
//
//  Add ability to make console out more readable and informative

import Foundation
class Log: NSObject {
    
    /**
     * Print execution place with timestamp
     */
    class func t(function: String = #function, file: String = #file, line: Int = #line){
        print("📄 \(makeTag(function: function, file: file, line: line)) 🕒 \(time()) ")
    }
    
    /**
     * Print execution place with timestamp and message
     */
    class func t(msg:String, function: String = #function, file: String = #file, line: Int = #line){
        print("📄 \(makeTag(function: function, file: file, line: line)) 🕒 \(time()) 💡 \(msg)")
    }
    
    /**
     * Print execution place
     */
    class func d(function: String = #function, file: String = #file, line: Int = #line){
        print("📄 \(makeTag(function: function, file: file, line: line))")
    }
    
    /**
     * Print execution place with message
     */
    class func d(msg:String, function: String = #function, file: String = #file, line: Int = #line){
        print("📄 \(makeTag(function: function, file: file, line: line)) 💡 \(msg)")
    }
    
    class func timeInterval(since: Date, function: String = #function, file: String = #file, line: Int = #line) {
        print("📄 \(makeTag(function: function, file: file, line: line)) 💡 \(Date().timeIntervalSince(since))")
    }
    
    
    
    private class func makeTag(function: String, file: String, line: Int) -> String{
        let className = NSURL(fileURLWithPath: file).lastPathComponent ?? file
        return "\(className) 👉 \(function) ➡ \(line)"
    }
    
    
    
    private class func time() -> String {
        let d = Date()
        let df = DateFormatter()
        df.dateFormat = "H:m:ss+SSSS"
        
        return df.string(from: d)
    }
    
}

