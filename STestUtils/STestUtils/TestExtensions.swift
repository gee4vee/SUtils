//
//  TestExtensions.swift
//  Some useful extensions for test cases.
//
//  Created by Gabriel Valencia on 10/4/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import Cocoa
import XCTest

public class TestExtensions: NSObject {

}

public extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        self.click()
        let deleteString = stringValue.characters.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        self.typeText(deleteString)
        self.typeText(text)
    }
}
