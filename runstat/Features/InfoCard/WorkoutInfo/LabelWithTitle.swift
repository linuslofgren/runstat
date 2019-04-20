//
//  LabelWithTitle.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-20.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class LabelWithTitle: UIView {
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 34)
//        label.adjustsFontSizeToFitWidth = true
        //        labelView.minimumScaleFactor = 12.0
        label.numberOfLines = 1
        return label
    }()
    
    lazy var topLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor.darkGray
        //        labelView.minimumScaleFactor = 12.0
        label.numberOfLines = 1
        return label
    }()
    
    lazy var suffixLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.boldSystemFont(ofSize: 16)
//        label.adjustsFontSizeToFitWidth = true
        //        labelView.minimumScaleFactor = 12.0
        label.textColor = UIColor.darkGray
        label.numberOfLines = 1
        return label
    }()
    
    var titleText: String? {
        didSet {
            topLabel.text = titleText
        }
    }
    var mainText: String? {
        didSet {
            mainLabel.text = mainText
        }
    }
    var suffixText: String? {
        didSet {
            suffixLabel.text = suffixText
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    func layout() {
        topLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(topLabel)
        topLabel.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainLabel)
        mainLabel.topAnchor.constraint(equalTo: topLabel.bottomAnchor).isActive = true
        mainLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        mainLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        
        suffixLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(suffixLabel)
        suffixLabel.bottomAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: -4.0).isActive = true
        suffixLabel.leadingAnchor.constraint(equalTo: mainLabel.trailingAnchor, constant: 2.0).isActive = true
        suffixLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
