//
//  Random.swift
//  Utilities for generating random data.
//
//  Created by Gabriel Valencia on 10/2/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Cocoa

public class Random: NSObject {
    
    public static func randomInt(max: Int) -> Int {
        let randomNum:UInt32 = arc4random_uniform(UInt32(max))
        return Int(randomNum)
    }

}
