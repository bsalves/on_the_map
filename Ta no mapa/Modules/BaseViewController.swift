//
//  BaseViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 09/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var usersRequest = UsersRequest()
    var users: UsersModel?
        
    func displayError(withAction: @escaping () -> ()) {
        let alert = UIAlertController(title: nil, message: "Erro ao carregar as localizações dos alunos.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default, handler: { (_) in
            withAction()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func logoutAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func insertLocation() {
        usersRequest.fetchMe(success: { [unowned self] (hasLocation) in
            if hasLocation {
                let alert = UIAlertController(title: nil, message: "Você já possui uma marcação no mapa. Deseja atualizar sua localização?", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Atualizar", style: .default, handler: { (_) in
                    self.performSegue(withIdentifier: "addPlace", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "addPlace", sender: nil)
                }
            }
        }) { [unowned self] (error) in
            let alert = UIAlertController(title: "Ops!", message: "Ocorreu algum erro ao verificar o histórico de suas localizações.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tentar novamente", style: .default, handler: { (_) in
                self.insertLocation()
            }))
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func addLocation(_ sender: Any) {
        self.insertLocation()
    }
}
