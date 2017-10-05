//
//  UIUtils.swift
//  UI-related utilities.
//
//  Created by Gabriel Valencia on 10/4/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Cocoa

public class UIUtils: NSObject {
    
    // Returns the app's panel window, if any.
    public class func getAppPanelWindow() -> NSPanel? {
        let windows = NSApplication.shared.windows
        for window in windows {
            if let appWindow = window as? NSPanel {
                return appWindow
            }
        }
        
        return nil
    }
    
    // Displays a warning modal dialog with the specified title,text, style, and a button with title "OK".
    public class func dialogOKWarning(title: String, text: String) -> Bool {
        return dialogOK(title: title, text: text, style: .warning)
    }
    
    // Displays a modal dialog with the specified title,text, style, and a button with title "OK".
    public class func dialogOK(title: String, text: String, style: NSAlert.Style) -> Bool {
        return dialog(title: title, text: text, style: style, buttonTitle: "OK")
    }
    
    // Displays a modal dialog with the specified title, text, style, and button title.
    public class func dialog(title: String, text: String, style: NSAlert.Style, buttonTitle: String) -> Bool {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = title
        myPopup.informativeText = text
        myPopup.alertStyle = style
        myPopup.addButton(withTitle: buttonTitle)
        return myPopup.runModal() == NSApplication.ModalResponse.alertFirstButtonReturn
    }
    
    // Displays a sheet modal dialog with OK and Cancel buttons. The specified handler will be called when the sheet is dismissed by the user.
    public class func dialogSheetOKCancel(title: String, text: String, completionHandler handler: ((NSApplication.ModalResponse) -> Void)? = nil) -> Void {
        let myPopup: NSAlert = NSAlert()
        myPopup.messageText = title
        myPopup.informativeText = text
        myPopup.alertStyle = NSAlert.Style.warning
        myPopup.addButton(withTitle: "OK")
        myPopup.addButton(withTitle: "Cancel")
        myPopup.beginSheetModal(for: UIUtils.getAppPanelWindow()!, completionHandler: handler)
    }
    
}

// Used in conjunction with NSWorkspace notification center to track applications as they are opened/activated.

// In your app delegate, register as follows in applicationDidFinishLaunching:
//
// NSWorkspace.shared.notificationCenter.addObserver(self,
//      selector: #selector(someFunctionThatCallsAppTrackerAppActivated(notification:)),
//      name: NSWorkspace.didActivateApplicationNotification,
//      object: nil)
public class AppTracker: NSObject {
    
    public var lastOpenedApp: String? = nil
    // the key to an NSUserDefaults bool preference to check if app switching should be enabled.
    public var preferenceKeyToCheck: String? = nil
    
    // the names of apps to exclude from tracking.
    public var appNameExclusions = [String]()
    
    // register this selector as described above.
    @objc public func appActivated(_ notification: NSNotification) {
        if let info = notification.userInfo,
            let app = info[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
            let name = app.localizedName
        {
            for excludeName in self.appNameExclusions {
                if excludeName == name {
                    return
                }
            }
            self.lastOpenedApp = name
            NSLog("Last opened app: \(name)")
        }
    }
    
    // Swithches to the previously opened/activated app. If a preference key has been set, it will be checked first.
    public func switchToPreviousApp() {
        if let prefKey = self.preferenceKeyToCheck {
            if (PreferencesManager.getPrefs().bool(forKey: prefKey) == false) {
                NSLog("Automatic app switching disabled via key \(prefKey)")
                return
            }
        }
        
        if let appName = self.lastOpenedApp {
            NSLog("Switching to last opened app \(String(describing: appName))")
            NSWorkspace.shared.launchApplication(appName)
        }
    }
}
