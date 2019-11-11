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

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: Actions
    @IBAction func didTapSignInButton(_ sender: Any) {
        APIManager.shared.login()
    }
}

