//
//  Extensions.swift
//  Some useful class extensions.
//
//  Created by Gabriel Valencia on 10/2/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Cocoa

public class Extensions: NSObject {

}

public extension String {
    
    /**
     Find the range of a substring within this string.
     
     - Parameter substring: The string to search for in this string.
     
     - Returns: The range of the substring, if found.
     */
    public func indexOf(substring: String) -> NSRange? {
        if let range = self.range(of: substring) {
            let startPos = self.distance(from: self.startIndex, to: range.lowerBound)
            return NSMakeRange(startPos, substring.count)
        }
        
        return nil
    }
    
}

public extension NSDictionary {
    
    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    public func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

public extension Collection {
    
    /// Convert self to JSON String.
    /// - Returns: Returns the JSON as String or empty string if error while parsing.
    public func json() -> String {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted])
            guard let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) else {
                print("Can't create string with data.")
                return "{}"
            }
            return jsonString
        } catch let parseError {
            print("json serialization error: \(parseError)")
            return "{}"
        }
    }
}

public extension Bundle {
    
    /**
     Returns the value of the CFBundleName key.
     */
    var appName: String {
        return infoDictionary?["CFBundleName"] as! String
    }
    
    /**
     Returns the value of the bundle identifier.
     */
    var bundleId: String {
        return bundleIdentifier!
    }
    
    /**
     Returns the value of the CFBundleShortVersionString key.
     */
    var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as! String
    }
    
    /**
     Returns the value of the CFBundleVersion key.
     */
    var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as! String
    }
}

public extension ProcessInfo {
    /**
     Used to recognized that UITestings are running and modify the app behavior accordingly
     
     Set with: XCUIApplication().launchArguments = [ "isUITesting" ]
     */
    public var isUITesting: Bool {
        return arguments.contains("isUITesting")
    }
    
    /**
     Used to recognized that UITestings are taking snapshots and modify the app behavior accordingly
     
     Set with: XCUIApplication().launchArguments = [ "isTakingSnapshots" ]
     */
    public var isTakingSnapshots: Bool {
        return arguments.contains("isTakingSnapshots")
    }
}
