//
//  BoxViewController.swift
//  runstat
//
//  Created by Linus Löfgren on 2019-03-19.
//  Copyright © 2019 Linus Löfgren. All rights reserved.
//

import UIKit

class BoxViewController: UINavigationController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .yellow
        self.title = "WORKOUT"
        self.navigationBar.isHidden = true
        self.delegate = self
        //self.setNavigationBarHidden(true, animated: false)
        let d = DetailsViewController()
        self.viewControllers = [d]
        // Do any additional setup after loading the view.
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController is DetailsViewController {
            self.setNavigationBarHidden(true, animated: true)
        } else {
//            self.setNavigationBarHidden(false, animated: true)
        }
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
