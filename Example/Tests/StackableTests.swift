//
//  StackableTests.swift
//  
//
//  Created by Jonathan Cole on 12/1/21.
//

@testable import Stackable
import XCTest

class StackableTests: XCTestCase {

    func testHairlineConfigLogic() {
        // Test Global config
        UIStackView.stackable.hairlineColor = .blue
        let stack1 = UIStackView()
        stack1.stackable.add([
            UIStackView.stackable.hairline,
        ])
        let hairline1 =  stack1.arrangedSubviews.first as! StackableHairlineView
        XCTAssert(hairline1.backgroundColor == .blue)

        // Test instance config
        let stack2 = UIStackView()
        stack2.stackable.hairlineColor = .brown
        stack2.stackable.add([
            UIStackView.stackable.hairline,
        ])
        let hairline2 =  stack2.arrangedSubviews.first as! StackableHairlineView
        XCTAssert(hairline2.backgroundColor == .brown)

        // Test per-hairline Config
        let stack3 = UIStackView()
        stack3.stackable.hairlineColor = .brown
        stack3.stackable.add([
            UIStackView.stackable.hairline,
            UIStackView.stackable.hairline
                .color(.yellow),
        ])
        let hairline3 = stack3.arrangedSubviews.first as! StackableHairlineView
        XCTAssert(hairline3.backgroundColor == .brown)

        let hairline4 = stack3.arrangedSubviews.last as! StackableHairlineView
        XCTAssert(hairline4.backgroundColor == .yellow)

    }

}
