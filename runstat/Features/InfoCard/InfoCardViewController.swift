//
//  InfoCardViewController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-02-24.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit
import HealthKit
import MapKit

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
    
    // Track animator progress
    var progressWhenInterrupted: CGFloat = 0
    var runningAnimators = [UIViewPropertyAnimator]()
    private var currentState: State = .closed {
        didSet {
            print("Changed currentState")
        }
    }
    
    let animationDuration = 0.5
    
    lazy var boxView: InfoCardView = {
        let box = InfoCardView()
        return box
    }()
    
    lazy var boxVC: BoxViewController = {
        let box = BoxViewController()
        return box
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = PassthroughView(frame: view.frame)
        add(boxVC, customView: boxView)
        layout()
        boxView.addGestureRecognizer(boxTapRec)
        boxView.addGestureRecognizer(boxPanRec)
//        boxView.clipsToBounds = true
    }
    
    lazy var hide = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1.0, animations: {
        self.bottomConstraint.constant = self.bottomConstantHidden
        self.view.layoutIfNeeded()
    })
    
    lazy var show = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1.0, animations: {
        self.bottomConstraint.constant = self.bottomConstant
        self.view.layoutIfNeeded()
    })
    
    func showInfoFor(run: Run) {
        let workoutController = WorkoutInfoController()
        workoutController.run = run
        self.boxVC.pushViewController(workoutController, animated: false)
        DispatchQueue.main.async {
            if !self.hidden {
                self.hide.addCompletion {
                    [unowned self] _ in
                    self.show.startAnimation()
                }
                self.hide.startAnimation()
            } else {
                self.show.startAnimation()
            }
        }
    }
    let hidden = true
    let bottomConstant: CGFloat = 300
    let bottomConstantHidden: CGFloat = 600
    var target: CGFloat = 300
    
    var bottomConstraint = NSLayoutConstraint()
    func layout() {
        boxView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(boxView)
        boxView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        boxView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = boxView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomConstantHidden)
        bottomConstraint.isActive = true
        boxView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        boxView.setNeedsLayout()
        
        boxVC.view.translatesAutoresizingMaskIntoConstraints = false
        boxVC.view.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        boxVC.view.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        boxVC.view.topAnchor.constraint(equalTo: boxView.topAnchor).isActive = true
        boxVC.view.bottomAnchor.constraint(equalTo: boxView.bottomAnchor).isActive = true
        boxVC.view.setNeedsLayout()
    }
    
    
    private func nextState() -> State {
        switch self.currentState {
        case .closed:
            return .open
        case .open:
            return .closed
        }
    }
    
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
    
    private func animateOrReverseRunningTransition(state: State, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
            runningAnimators.forEach({ $0.startAnimation() })
        } else {
            runningAnimators.forEach({ $0.isReversed = !$0.isReversed })
        }
    }
    
    private func startInteractiveTransition(state: State, duration: TimeInterval) {
        animateTransitionIfNeeded(state: state, duration: duration)
        runningAnimators.forEach({ $0.pauseAnimation() })
        progressWhenInterrupted = runningAnimators.first?.fractionComplete ?? 0
    }
    
    private func addMoveAnimator(state: State, duration: TimeInterval) {
        let moveAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .closed:
                self.bottomConstraint.constant = self.bottomConstant
                self.view.layoutIfNeeded()
            case .open:
                self.bottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
        moveAnimator.addCompletion({ (position) in
            switch position {
            case .end:
                self.currentState = self.nextState()
            case .current:
                break
            case .start:
                // Constraints needs to be set manually because they don't change back when reversed
                self.bottomConstraint.constant = self.currentState == .open ? 0 : self.bottomConstant
                break
            default:
                break
            }
            self.runningAnimators.removeAll()
        })
        runningAnimators.append(moveAnimator)
    }
    
    private func animateTransitionIfNeeded(state: State, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            addMoveAnimator(state: state, duration: duration)
        }
    }
    
    private func updateInteractiveTransition(fractionComplete: CGFloat) {
        runningAnimators.forEach({ $0.fractionComplete = fractionComplete })
    }
    
    private func continueInteractiveTransition(cancle: Bool) {
        if cancle {
            runningAnimators.forEach({
                $0.isReversed = !$0.isReversed
                $0.continueAnimation(withTimingParameters: nil, durationFactor: 0)
            })
            return
        }
        runningAnimators.forEach({ $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) })
    }
    
    private func fractionComplete(state: State, translation: CGPoint) -> CGFloat {
        let fraction = (state == .open ? -translation.y : translation.y) / self.target + progressWhenInterrupted
        return fraction
    }
    
    private func cancleFromVelocity(state: State, velocity: CGPoint) -> Bool {
        let cancle = (state == .open ? velocity.y > 0 : velocity.y < 0)
        return cancle
    }
    
    var animator: UIViewPropertyAnimator!
    @objc func boxViewPanned(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: boxView)
        let velocity = recognizer.velocity(in: boxView)
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState(), duration: animationDuration)
        case .changed:
            updateInteractiveTransition(fractionComplete: fractionComplete(state: nextState(), translation: translation))
        case .ended:
            continueInteractiveTransition(cancle: cancleFromVelocity(state: nextState(), velocity: velocity))
        default:
            ()
        }
    }
    
    @objc func boxViewTapped(recognizer: UITapGestureRecognizer) {
        animateOrReverseRunningTransition(state: nextState(), duration: animationDuration)
    }

}
