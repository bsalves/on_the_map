//
//  LoginViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 07/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    @IBOutlet weak var connectButton: UIButton!
    
    lazy var loginRequest = LoginRequest()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        username.text = "brusznah@live.com"
        password.text = "bruS2nah."
        #endif
    }
    
    private func success() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
        loading.stopAnimating()
        loading.isHidden = false
        connectButton.isEnabled = true
    }
    
    @IBAction func login(_ sender: Any) {
        loading.isHidden = false
        loading.startAnimating()
        connectButton.setTitle("Conectando...", for: .disabled)
        connectButton.isEnabled = false
        
        loginRequest.login(username: username.text ?? "", password: password.text ?? "", success: { [unowned self] (response) in
            self.success()
        }, errorResponse: { (error) in
            print(error)
        })
    }
}

