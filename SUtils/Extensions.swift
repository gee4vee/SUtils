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
