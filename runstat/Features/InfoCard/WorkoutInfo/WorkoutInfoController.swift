//
//  WorkoutInfoController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-19.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class WorkoutInfoController: UIViewController {
    
    var run: Run! {
        didSet {
            let runExtr = RunInfoExtractor()
            let strings = runExtr.from(run)
            self.infoView.distText = strings.distance
            self.infoView.timeText = strings.time
            self.infoView.paceText = strings.rawPace
            self.infoView.dateText = strings.date
            self.infoView.paceList = strings.splits
        }
    }
    
    lazy var infoView: WorkoutInfoView = {
        let view = WorkoutInfoView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(infoView)
        layout()
    }
    
    func layout() {
        infoView.translatesAutoresizingMaskIntoConstraints = false
        infoView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        infoView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        infoView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        infoView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        print(run.distance)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
