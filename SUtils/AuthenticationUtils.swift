//
//  AuthenticationUtils.swift
//  SUtils
//
//  Created by Gabriel Valencia on 10/11/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Foundation

/**
 Lock and your Mac without user input using a keychain item containing the user's credentials.
 Special thanks to AirUnlock for Mac for the AppleScript approach (https://github.com/pinetum/AirUnlock-for-Mac).
 
 To use this class, first use KeychainPasswordItem to create and save a keychain item containing the user's credentials. Then instantiate
 this class by passing in the keychain item.
 */
public class LockUnlockMac : NSObject {
    
    /**
     This is only valid on macOS 10.13+ where the new Lock Screen menu item was added to the  menu. It's keyboard shortcut is ^⌘Q.
     */
    static let lockScript = """
    tell application \"System Events\" to keystroke \"q\" using {control down, command down}
    """
    
    /**
     1. Press the right shift key to bring up the login window (in case the screen has locked).
     2. Wait a bit to make sure that the login window appears so that it can receive keyboard input.
     3. Enter the password.
     4. Press return.
     */
    static let unlockScriptBase = """
    tell application \"System Events\" to key code 60\n
    delay 2
    tell application \"System Events\" to keystroke \"%@\"\n
    tell application \"System Events\" to keystroke return
    """
    
    private let credentials: KeychainPasswordItem?
    
    /**
     Initializes with the specified keychain item.
     
     - Parameter creds: The keychain item containing the user's credentials which will be used to unlock the computer.
     */
    init(creds: KeychainPasswordItem) {
        self.credentials = creds
    }
    
    /**
     Lock the computer. This performs the lock screen function.
     
     - Returns: If no error occurred, returns true. Otherwise false is returned. Prior to macOS 10.13, failure to lock might not
     return false.
     */
    public func lock() -> Bool {
        if #available(OSX 10.13, *) {
            // the Lock Screen menu item was removed from Keychain Access app in high sierra. need to use a different approach.
            let lockAS: NSAppleScript = NSAppleScript(source: LockUnlockMac.lockScript)!
            var dict: NSDictionary? = nil
            let result = lockAS.executeAndReturnError(&dict)
            if let errorDict = dict {
                NSLog("LockUnlockMac.lock - Error: \(errorDict.json())")
            }
            return result.aeDesc != nil
            
        } else {
            // prior to high sierra, Keychain Access app has a built-in lock screen function for the Lock Screen menu bar item.
            let keychainB = Bundle(path: "/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu")
            if let principalClass = keychainB?.principalClass {
                let instance = principalClass.alloc()
                // this relies on the menu item's associated action selector name to not change.
                let sel = Selector(("_lockScreenMenuHit:"))
                _ = instance.perform(sel, with: nil)
            }
            //        NSBundle *bundle = [NSBundle bundleWithPath:@"/Applications/Utilities/Keychain Access.app/Contents/Resources/Keychain.menu"];
            //        Class principalClass = [bundle principalClass];
            //
            //        id instance = [[principalClass alloc] init];
            //
            //        [instance performSelector:@selector(_lockScreenMenuHit:) withObject:nil];
            return true
        }
    }
    
    /**
     Unlocks the computer by bringing up the login window and entering the password saved in this instance's keychain item.
     
     - Returns: If no error occurred, returns true. Otherwise returns false.
     */
    public func unlock() throws -> Bool {
        if let key = self.credentials {
            let pass = try key.readPassword()
            let unlockScript = String(format: LockUnlockMac.unlockScriptBase, pass)
            let unlockAS: NSAppleScript = NSAppleScript(source: unlockScript)!
            var dict: NSDictionary? = nil
            let result = unlockAS.executeAndReturnError(&dict)
            if let errorDict = dict {
                NSLog("LockUnlockMac.unlock - Error: \(errorDict.json())")
            }
            return result.aeDesc != nil
        }
        
        return false
    }
}

