//
//  MemoryTests.swift
//  Stackable_Tests
//
//  Created by Jason Clark on 8/17/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Stackable
import XCTest

class MemoryTests: XCTestCase {
    
    func testExampleViewControllers() {
        let createVC: () -> UIViewController = {
            let vc = StackableViewController()
            
            let viewA = UIView()
            let viewB = UIView()
            let viewC = UIView()
            
            vc.contentView.stackView.stackable.hairlineProvider = { _ in
                return UIView()
            }
            
            vc.contentView.add([
                "String",
                NSAttributedString(string: "Attributed String"),
                UIImage(),
                UIImageView(),
                UIButton(),
                UIView()
                    .inset(by: .init(top: 10, left: 10, bottom: 10, right: 10)),
                UIView()
                    .inset(by: .init(top: 10, left: 10, bottom: 10, right: 10))
                    .aligned(.centerX),
                UIView()
                    .outset(to: vc.view)
                    .margins(alignedWith: vc.contentView),
                10,
                10...20,
                10.0...20,
                ...20,
                10...,
                UIStackView.stackable.hairline,
                viewA,
                UIStackView.stackable.space(after: viewA, 10),
                UIStackView.stackable.space(before: viewB, 10),
                viewB,
                viewC,
                UIStackView.stackable.hairlines(around: [viewA, viewB, viewC])
                    .inset(by: .init(top: 20, left: 20, bottom: 20, right: 20))
                    .color(.red)
                    .thickness(3),
                UIStackView.stackable.space(afterGroup: [viewA, viewB, viewC], 20),
                UIStackView.stackable.flexibleSpace,
            ])
            
            return vc
        }
        
        XCTAssertNil(autorelease(createVC))
    }
    
    func testMemoryTest() {
        XCTAssertNotNil(autorelease { RetainCycleViewController() })
        XCTAssertNil(autorelease { UIViewController() })
    }
    
    func autorelease<T: AnyObject>(_ create: () -> T?) -> T? {
        weak var obj: T?
        autoreleasepool {
            obj = create()
        }
        return obj
    }

}

private class StackableViewController: UIViewController {
    
    let contentView = ScrollingStackView()
    
    override func viewDidLoad() {
        view.addSubview(contentView)
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
        ])
    }
    
}


/// Intentional Retain Cycle to test that this test suite is working
private class RetainCycleViewController: UIViewController {
    
    let button = Button()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        button.callback = {
            //Intentional Retain Cycle
            self.buttonPressed()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func buttonPressed() {
        print("Button Pressed!")
    }
    
    class Button: UIButton {
        
        var callback: (() -> Void)?
        
        init() {
            super.init(frame: .zero)
            addTarget(self, action: #selector(pressed), for: .touchUpInside)
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        @objc func pressed() {
            callback?()
        }
        
    }
    
}
