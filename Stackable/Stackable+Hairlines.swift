//
//  Stackable+Hairlines.swift
//  Stackable
//
//  Created by Jason Clark on 8/3/20.
//

import Foundation

// MARK: - Stackable Hairlines
public enum Hairline {
    case after(UIView?)
    case between(UIView?, UIView?)
    case before(UIView?)
    case around(UIView?)
}

final class HairlineView: UIView {

    let thickness: CGFloat = 1.0
    let color: UIColor = .lightGray

    init(stackAxis axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        NSLayoutConstraint.activate([
            self.dimension(along: axis).constraint(equalToConstant: thickness),
        ])
        backgroundColor = color
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension Hairline: Stackable {

    public func configure(stackView: UIStackView) {
        func makeHairline() -> HairlineView {
            let hairline = HairlineView(stackAxis: stackView.axis)
            hairline.bindVisible(toAllVisible: allViews)
            return hairline
        }

        if let view = hairlineBeforeView {
            stackView.stackable.insertArrangedSubview(makeHairline(), aboveArrangedSubview: view)
        }
        if let view = hairlineAfterView {
            stackView.stackable.insertArrangedSubview(makeHairline(), belowArrangedSubview: view)
        }
        if allViews.isEmpty {
            stackView.addArrangedSubview(makeHairline())
        }
    }

    private var allViews: [UIView] {
        switch self {
        case .after(let view): return [view].compactMap { $0 }
        case .between(let v0, let v1): return [v0, v1].compactMap { $0 }
        case .before(let view): return [view].compactMap { $0 }
        case .around(let view): return [view].compactMap { $0 }
        }
    }

    private var hairlineAfterView: UIView? {
        switch self {
        case .after(let view): return view
        case .between(let v0, _): return v0
        case .before: return nil
        case .around(let view): return view
        }
    }

    private var hairlineBeforeView: UIView? {
        switch self {
        case .after: return nil
        case .between: return nil
        case .before(let view): return view
        case .around(let view): return view
        }
    }
}
