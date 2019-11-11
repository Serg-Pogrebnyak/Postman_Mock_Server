//
//  ViewController.swift
//  ServerMock
//
//  Created by Sergey Pogrebnyak on 28.10.2019.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

import UIKit
import SVProgressHUD

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var loginTextField: UITextField!
    @IBOutlet fileprivate weak var passTextField: UITextField!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.setDefaultStyle(.dark)
        SVProgressHUD.setDefaultMaskType(.clear) //disable user interface
    }

    //MARK: Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        SVProgressHUD.show(withStatus: "Loading")
        APIManager.shared.login(loginLinks: LoginLinks.allCases[segmentControl.selectedSegmentIndex]) { [weak self] (user, error) in
            SVProgressHUD.dismiss()
            if error == nil {
                self?.showAlert(title: "Success authorization", message: user!.getDescriptionForAlert())
            } else {
                self?.showAlert(title: "Error", message: error!.userInfo["error"] as! String)
            }
        }
    }

    //MARK: Private
    fileprivate func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

