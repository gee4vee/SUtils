//
//  PreferencesManager.swift
//  A class for managing preferences defined via NSUserDefaultsController.
//
//  Created by Gabriel Valencia on 4/17/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Cocoa

public class PreferencesManager: NSObject {
    
    public class func getPrefs() -> UserDefaults {
        return NSUserDefaultsController.shared.defaults
    }
    
    public class func loadDefaults() -> [String: AnyObject]? {
        if let path = Bundle.main.path(forResource: "Defaults", ofType: "plist"),
            let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
            return dict
        }
        
        return nil
    }
    
    public class func sync() {
        getPrefs().synchronize()
    }
}
