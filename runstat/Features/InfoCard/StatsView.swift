//
//  StatsView.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-14.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class StatsView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    var splitViews: [UIView] = []
    var splits: [(dist: String, pace: String)]? {
        didSet {
            for view in splitViews {
                view.removeFromSuperview()
            }
            for split in splits! {
                addSplitView(split)
            }
        }
    }
    
    func addSplitView(_ split: (dist: String, pace: String)) {
        let view = UIView()
        let left = UILabel()
        left.text = split.dist
        let right = UILabel()
        right.text = split.pace
        view.translatesAutoresizingMaskIntoConstraints = false
        left.translatesAutoresizingMaskIntoConstraints = false
        right.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(left)
        view.addSubview(right)
        stackView.addArrangedSubview(view)
        view.heightAnchor.constraint(equalToConstant: 36.0).isActive = true
        view.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
        left.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        right.heightAnchor.constraint(equalToConstant: 26.0).isActive = true
        left.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        left.widthAnchor.constraint(equalToConstant: 150.0).isActive = true
        left.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        right.centerYAnchor.constraint(equalTo: left.centerYAnchor).isActive = true
        right.widthAnchor.constraint(equalToConstant: 200.0).isActive = true
        right.leadingAnchor.constraint(equalTo: left.trailingAnchor).isActive = true
//        right.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        splitViews.append(view)
    }
    
    func commonInit() {
        Bundle.main.loadNibNamed("StatsView", owner: self, options: nil)
        addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
//        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
}
