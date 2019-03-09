//
//  InfoCardViewController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-24.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import HealthKit

private enum State {
    case closed
    case open
}
extension State {
    var otherDir: State {
        switch self {
        case .open:
            return .closed
        case .closed:
            return .open
        }
    }
}

protocol InfoCardControllerDelegate: class {
}

class InfoCardViewController: UIViewController {
    
    weak var delegate: InfoCardControllerDelegate?
    
    lazy var boxView: InfoCardView = {
        let box = InfoCardView()
        return box
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = PassthroughView(frame: view.frame)
        layout()
        boxView.addGestureRecognizer(boxTapRec)
        boxView.addGestureRecognizer(boxPanRec)
    }
    
    func showInfoFor(workout: HKWorkout?, date: Date?, name: String?) {
        let dist = 13.0 //workout.totalDistance!.doubleValue(for: HKUnit.meterUnit(with: HKMetricPrefix.kilo))
        let time = 10.0 //workout.duration
        let spkm = time/dist
        self.boxView.distText = String(format: "%.1f km ", dist)
        self.boxView.nameText = name ?? "---"
        self.boxView.timeText = String(format: "%.1f min", time/60) + " • " + String(format: "%.0f:%02.0f min/km", floor(spkm/60), ((spkm/60)-floor(spkm/60))*60)
        guard date != nil else {print("no date"); return}
        let df = DateFormatter()
        df.dateFormat = "dd MMM yy HH:mm"
        self.boxView.dateText = df.string(from: date!)
    }
    
    let bottomConstant: CGFloat = 400
    var bottomConstraint = NSLayoutConstraint()
    func layout() {
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)
        boxView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        boxView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = boxView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstant)
        bottomConstraint.isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        boxView.setNeedsLayout()
    }
    private var animationProg: CGFloat = 0
    private var currentState: State = .closed
    
    lazy var boxTapRec: UITapGestureRecognizer = {
        let rec = UITapGestureRecognizer()
        rec.addTarget(self, action: #selector(boxViewTapped(recognizer:)))
        return rec
    }()
    lazy var boxPanRec: UIPanGestureRecognizer = {
        let rec = UIPanGestureRecognizer()
        rec.addTarget(self, action: #selector(boxViewPanned(recognizer:)))
        return rec
    }()
    var transitionAnimator: UIViewPropertyAnimator!
    private func animateTransitionIfNeeded(to: State, duration: Double) {
        let state = to
        transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.bottomConstant
            }
            self.view.layoutIfNeeded()
        })
        transitionAnimator.addCompletion {
            (position) in
            switch position {
            case .start:
                self.currentState = state.otherDir
            case .end:
                self.currentState = state
            case .current:
                ()
            }
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = 0
            case .closed:
                self.bottomConstraint.constant = self.bottomConstant
            }
        }
        transitionAnimator.startAnimation()
    }
    @objc func boxViewTapped(recognizer: UITapGestureRecognizer) {
        let state = currentState.otherDir
        animateTransitionIfNeeded(to: state, duration: 0.8)
    }
    
    var animator: UIViewPropertyAnimator!
    @objc func boxViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            animateTransitionIfNeeded(to: currentState.otherDir, duration: 0.8)
            transitionAnimator.pauseAnimation()
            animationProg = transitionAnimator.fractionComplete
        case .changed:
            let translation = recognizer.translation(in: boxView)
            var frac = -translation.y / bottomConstant
            if currentState == .open { frac *= -1 }
            transitionAnimator.fractionComplete = frac + animationProg
        case .ended:
            transitionAnimator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        default:
            ()
        }
    }

}
