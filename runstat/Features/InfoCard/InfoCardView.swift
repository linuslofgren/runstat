//
//  InfoCardView.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-21.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class InfoCardView: UIView {
    lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.clipsToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addShadow()
        addBlur()
        layout()
    }
    func addShadow() {
        self.layer.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.15).cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowRadius = 2
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
    }
    func addBlur() {
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(blurEffectView)
        
    }
    func layout() {
        scroll.translatesAutoresizingMaskIntoConstraints = false
        addSubview(scroll)
        scroll.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        scroll.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10).isActive = true
        scroll.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
        scroll.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
