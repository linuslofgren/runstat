//
//  InfoCardView.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class InfoCardView: UIView {
    
    lazy var handle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()
    
    lazy var stats: StatsView = {
        let view = StatsView()
        return view
    }()
    
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
    
    lazy var paceLabel: UILabel = {
        let labelView = UILabel(frame: CGRect.zero)
        labelView.font = UIFont.boldSystemFont(ofSize: 20)
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
    var paceList: [(dist: String, pace: String)]? {
        didSet {
            stats.splits = paceList
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0.97, alpha: 1.0)
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 20
//        let shadowLayer
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: 0, height: -3)
        
        layout()
    }
    func layout() {
        print("layout")
//
//        handle.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(handle)
//        handle.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        handle.heightAnchor.constraint(equalToConstant: 5).isActive = true
//        handle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
//        handle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
//
//        distLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(distLabel)
//        //distLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        distLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
//        distLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0.5).isActive = true
//        distLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        distLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 30).isActive = true
//        distLabel.textAlignment = .right
//
//        nameLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(nameLabel)
//        nameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        nameLabel.trailingAnchor.constraint(equalToSystemSpacingAfter: self.trailingAnchor, multiplier: 0.5).isActive = true
////        nameLabel.widthAnchor.constraint(equalTo: distLabel.widthAnchor).isActive = true
//        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        nameLabel.topAnchor.constraint(equalTo: distLabel.topAnchor, constant: 0).isActive = true
//
//        dateLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(dateLabel)
//        dateLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor).isActive = true
//        dateLabel.trailingAnchor.constraint(equalTo: nameLabel.trailingAnchor, constant: 0).isActive = true
//        dateLabel.heightAnchor.constraint(equalToConstant: 14).isActive = true
//        dateLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
//
//
//        timeLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(timeLabel)
////        timeLabel.leadingAnchor.constraint(equalTo: distLabel.leadingAnchor, constant: 20).isActive = true
//        timeLabel.trailingAnchor.constraint(equalTo: distLabel.trailingAnchor).isActive = true
//        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        timeLabel.widthAnchor.constraint(equalTo: distLabel.widthAnchor).isActive = true
//        timeLabel.topAnchor.constraint(equalTo: distLabel.bottomAnchor, constant: 0).isActive = true
//        timeLabel.textAlignment = .right
//
//        paceLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(paceLabel)
//        paceLabel.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor).isActive = true
//        paceLabel.widthAnchor.constraint(equalTo: timeLabel.widthAnchor).isActive = true
//        paceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 0).isActive = true
//        paceLabel.textAlignment = .right
//
        scroll.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)
        scroll.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        scroll.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        scroll.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        scroll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
        
//        stats.translatesAutoresizingMaskIntoConstraints = false
//        scroll.addSubview(stats)
//        stats.topAnchor.constraint(equalTo: scroll.topAnchor, constant: 10).isActive = true
//        stats.bottomAnchor.constraint(equalTo: scroll.bottomAnchor, constant: -10).isActive = true
//        stats.leadingAnchor.constraint(equalTo: scroll.leadingAnchor, constant: 10).isActive = true
//        stats.trailingAnchor.constraint(equalTo: scroll.trailingAnchor, constant: -10).isActive = true
//
////        speedLabel.translatesAutoresizingMaskIntoConstraints = false
//        addSubview(speedLabel)
//       // speedLabel.widthAnchor.constraint(equalToConstant: 60.0)
//        speedLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
//        speedLabel.trailingAnchor.constraint(equalTo: distLabel.leadingAnchor, constant: 20).isActive = true
//        speedLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        speedLabel.topAnchor.constraint(equalTo: distLabel.topAnchor, constant: 0).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
