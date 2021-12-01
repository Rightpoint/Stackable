//
//  InheritanceTests.swift
//  
//
//  Created by Jonathan Cole on 11/30/21.
//

import Stackable
import XCTest

class InheritingStackView: UIStackView {}

/**
 In these tests, we make sure that classes inheriting from
 UIStackView also have full Stackable capabilities applied.
 */
class InheritanceTests: XCTestCase {

    func testDerivingClassHasStackableAddMethod() {
        let stack = InheritingStackView()
        stack.stackable.add([
            CGFloat(0),
        ])

        XCTAssert(true, "Passes if it compiles.")
    }

}
