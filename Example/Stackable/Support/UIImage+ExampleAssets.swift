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
        
        //Logo
        case add = "Add"
        case appStore = "AppStore"
        case back = "Back"
        case bluetooth = "Bluetooth"
        case list = "List"
        case location = "Location"
        case progressRings = "Progress-Rings"
        case sText = "S-Text"
        case numberOne = "NumberOne"
    }

    convenience init(asset: Asset) {
        self.init(named: asset.rawValue)!
    }

}
