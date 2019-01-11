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
    
    private func success() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
        
        self.resetLoginForm()
    }
    
    private func resetLoginForm() {
        DispatchQueue.main.async {
            self.loading.stopAnimating()
            self.loading.isHidden = true
            self.connectButton.isEnabled = true
            self.username.text = ""
            self.password.text = ""
        }
    }
    
    @IBAction func login(_ sender: Any) {
        self.view.endEditing(true)
        loading.isHidden = false
        loading.startAnimating()
        connectButton.setTitle("Conectando...", for: .disabled)
        connectButton.isEnabled = false
        
        loginRequest.login(username: username.text ?? "", password: password.text ?? "", success: { [unowned self] (response) in
            self.success()
        }, errorResponse: { (error) in
            let alert = UIAlertController(title: nil, message: "Login inválido", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: {
                self.resetLoginForm()
            })
            
        })
    }
}

