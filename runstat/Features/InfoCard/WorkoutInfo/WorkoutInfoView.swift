//
//  WorkoutInfoView.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-20.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class WorkoutInfoView: UIView {
    
    lazy var stats: StatsView = {
        let view = StatsView()
        return view
    }()
    
    lazy var handle: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.3)
        view.layer.cornerRadius = 2.5
        return view
    }()
    
    lazy var distLabel: LabelWithTitle = {
        let view = LabelWithTitle()
        view.titleText = "Distance"
        return view
    }()
    lazy var timeLabel: LabelWithTitle = {
        let view = LabelWithTitle()
        view.titleText = "Duration"
        return view
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
    
    lazy var paceLabel: LabelWithTitle = {
        let view = LabelWithTitle()
        view.titleText = "Average Pace"
        return view
    }()
    
    var distText: workoutMetric? {
        didSet {
            distLabel.mainText = distText?.value
            distLabel.suffixText = distText?.unit
        }
    }
    var timeText: String? {
        didSet {
            timeLabel.mainText = timeText
            timeLabel.suffixText = "min"
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
    var paceText: workoutMetric? {
        didSet {
            paceLabel.mainText = paceText?.value
            paceLabel.suffixText = paceText?.unit
        }
    }
    var paceList: [(dist: String, pace: String)]? {
        didSet {
            stats.splits = paceList
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .yellow
        layout()
    }
    func layout() {
        handle.translatesAutoresizingMaskIntoConstraints = false
        addSubview(handle)
        handle.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handle.heightAnchor.constraint(equalToConstant: 5).isActive = true
        handle.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        handle.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(dateLabel)
        dateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        
        distLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(distLabel)
        //distLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20).isActive = true
        distLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        //        distLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0.5).isActive = true
        distLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
        distLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
        distLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16).isActive = true
//        distLabel.textAlignment = .left


        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(timeLabel)
//        timeLabel.leadingAnchor.constraint(equalTo: distLabel.leadingAnchor, constant: 20).isActive = true
//        timeLabel.trailingAnchor.constraint(equalTo: distLabel.trailingAnchor).isActive = true
        timeLabel.leadingAnchor.constraint(equalTo: self.centerXAnchor, constant: 30).isActive = true
        timeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
//        timeLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        timeLabel.widthAnchor.constraint(equalTo: distLabel.widthAnchor).isActive = true
        timeLabel.topAnchor.constraint(equalTo: distLabel.topAnchor, constant: 0).isActive = true
        timeLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
//        timeLabel.textAlignment = .right

        paceLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(paceLabel)
        paceLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
        //        distLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: self.leadingAnchor, multiplier: 0.5).isActive = true
        paceLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30).isActive = true
//        paceLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
        paceLabel.topAnchor.constraint(equalTo: distLabel.bottomAnchor, constant: 28).isActive = true
        paceLabel.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
