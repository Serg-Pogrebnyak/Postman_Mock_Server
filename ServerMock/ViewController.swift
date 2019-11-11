//
//  ViewController.swift
//  ServerMock
//
//  Created by Sergey Pogrebnyak on 28.10.2019.
//  Copyright © 2019 Sergey Pogrebnyak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet fileprivate weak var loginTextField: UITextField!
    @IBOutlet fileprivate weak var passTextField: UITextField!
    @IBOutlet fileprivate weak var segmentControl: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        APIManager.shared.login(loginLinks: LoginLinks.allCases[segmentControl.selectedSegmentIndex]) { [weak self] (user, error) in
            if error == nil {
                self?.showUserDetailAlert(user!)
            } else {
                self?.showErrorAlert(error!)
            }
        }
    }

    //MARK: Private
    fileprivate func showUserDetailAlert(_ user: User) {
        let alert = UIAlertController(title: "Done", message: user.getDescriptionForAlert(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    fileprivate func showErrorAlert(_ error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.userInfo["error"] as? String, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

