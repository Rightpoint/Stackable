//
//  UIImage+ExampleAssets.swift
//  Stackable_Example
//
//  Created by Jason Clark on 8/10/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

extension UIImage {
    
    enum Asset: String {
        case chevron = "Chevron"
        case example = "Example"
    }
    
    convenience init(asset: Asset) {
        self.init(named: asset.rawValue)!
    }

}
