//
//  InfoCardView.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class InfoCardView: UIView {
    lazy var distLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 60)
        labelView.adjustsFontSizeToFitWidth = true
//        labelView.minimumScaleFactor = 12.0
        labelView.numberOfLines = 0
        return labelView
    }()
    lazy var timeLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 60)
        labelView.adjustsFontSizeToFitWidth = true
//        labelView.minimumScaleFactor = 12.0
        labelView.numberOfLines = 0
        return labelView
    }()
    lazy var speedLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 60)
        labelView.adjustsFontSizeToFitWidth = true
        //labelView.minimumScaleFactor = 12.0
        labelView.numberOfLines = 0
        return labelView
    }()
    lazy var dateLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 60)
        labelView.adjustsFontSizeToFitWidth = true
        //labelView.minimumScaleFactor = 12.0
        labelView.numberOfLines = 0
        return labelView
    }()
    lazy var nameLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 60)
        labelView.adjustsFontSizeToFitWidth = true
        //labelView.minimumScaleFactor = 12.0
        labelView.numberOfLines = 0
        return labelView
    }()
    
    var distText: String? {
        didSet {
            distLabel.text = distText
        }
    }
    var timeText: String? {
        didSet {
            timeLabel.text = timeText
        }
    }
    var speedText: String? {
        didSet {
            speedLabel.text = speedText
        }
    }
    var dateText: String? {
        didSet {
            dateLabel.text = dateText
        }
    }
    var nameText: String? {
        didSet {
            nameLabel.text = nameText
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.alpha = 0.95
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.cornerRadius = 20
        layout()
    }
    func layout() {
        distLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(distLabel)
        //distLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        distLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        distLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        distLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
        distLabel.textAlignment = .right
        
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 140).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: distLabel.topAnchor, constant: 0).isActive = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(nameLabel)
        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: distLabel.leadingAnchor, constant: 10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        nameLabel.topAnchor.constraint(equalTo: dateLabel.topAnchor, constant: 20).isActive = true
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
        timeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        timeLabel.topAnchor.constraint(equalTo: distLabel.bottomAnchor, constant: 20).isActive = true
        
        speedLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(speedLabel)
        speedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        speedLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 20).isActive = true
        speedLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        speedLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 20).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}