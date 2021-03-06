//
//  ExampleMenuViewController.swift
//  Stackable
//
//  Created by Jay Clark on 07/30/2020.
//  Copyright © 2020 Rightpoint. All rights reserved.
//

import UIKit
import Stackable

class ExampleMenuViewController: UIViewController {

    enum ExampleCell: String, CaseIterable {
        case signIn = "Sign In"
        case onboarding = "Onboarding"
        case settings  = "Settings"
        case contentList = "Content List"
        case contentDetail = "Content Detail"
        case logo = "Logo"
    }
    
    let contentView: ScrollingStackView = {
        let view = ScrollingStackView()
        view.layoutMargins = Constant.margins
        return view
    }()
    
    let logo: LogoView = {
        let logo = LogoView()
        logo.layer.borderColor = UIColor.black.withAlphaComponent(0.1).cgColor
        logo.layer.borderWidth = 2.0
        logo.backgroundColor = .white
        return logo
    }()
    
    lazy var cells: [UIView] = ExampleCell.allCases.map(cell(for:))
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        view.addSubview(contentView)
        contentView.pinToSuperview(view)
        
        title = "Stackable"
        
        contentView.backgroundColor = .groupTableViewBackground
                
        contentView.add([
            logo,
            30,
            "Example Views:",
            10,
            cells
                .outset(to: view)
                .margins(alignedWith: contentView),
            UIStackView.stackable.hairlines(around: cells)
                .outset(to: view),
            20...,
            "Copyright Rightpoint",
        ])
    }
        
}

extension ExampleMenuViewController  {
    
    func cell(for example: ExampleCell) -> UIView {
        let cell = MenuCell()
        cell.title = example.rawValue
        cell.onSelect = { [weak self] in
            self?.exampleSelected(example: example)
        }
        return cell
    }
    
    func exampleSelected(example: ExampleCell) {
        switch example {
        case .logo:
            let logoVC = LogoViewController()
            navigationController?.pushViewController(logoVC, animated: true)
            
        default:
            debugPrint("Example pressed: \(example)")
        }
    }
    
    enum Constant  {
        static let margins = UIEdgeInsets(
            top: 20,
            left: 20,
            bottom: 20,
            right: 20
        )
    }

}
