//
//  SUtilsTests.swift
//  SUtilsTests
//
//  Created by Gabriel Valencia on 10/2/17.
//  Copyright © 2017 Gabriel Valencia. All rights reserved.
//

import XCTest
@testable import SUtils

class SUtilsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /**
     This test case requries user input at the console in order to get your credentials so that they don't have to be hard-coded.
     The credentials will be temporarily stored in a keychain item and then deleted at the end of the test.
     */
    func testLockUnlockMac() {
        print("Enter your user account name: ")
        let username = readLine()
        if let user = username {
            print("Enter your password: ")
            let password = readLine()
            if let pass = password {
                let testKeychainItem = KeychainPasswordItem(service: "SUtilsTests.testLockUnlockMac", account: user)
                do {
                    try testKeychainItem.savePassword(pass)
                } catch {
                    XCTFail(error.localizedDescription)
                    return
                }
                
                let lum = LockUnlockMac(creds: testKeychainItem)
                let result = lum.lock()
                XCTAssert(result == true, "Error during locking")
                do {
                    let unlockResult = try lum.unlock()
                    XCTAssert(unlockResult == true, "Error during unlocking")
                } catch {
                    XCTFail(error.localizedDescription)
                }
                defer { // ensure the keychain item is always deleted.
                    do {
                        try testKeychainItem.deleteItem()
                    } catch {
                        XCTFail(error.localizedDescription)
                    }
                }
                
            } else {
                XCTFail("Must enter password")
            }
        } else {
            XCTFail("Must enter username")
        }
    }
    
}
