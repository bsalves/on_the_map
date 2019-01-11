//
//  ListViewController.swift
//  Ta no mapa
//
//  Created by Bruno Alves on 09/01/19.
//  Copyright © 2019 Bruno Alves. All rights reserved.
//

import UIKit

class ListViewController: BaseViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadUsers()
    }
    
    // MARK: Private functions
    
    private func loadUsers() {
        usersRequest.users(success: { [unowned self] (users) in
            self.users = users
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }) { [unowned self] (error) in
            self.displayError(withAction: {
                self.loadUsers()
            })
        }
    }
    
    private func reloadUsers() {
        self.users = nil
        tableView.reloadData()
        loadUsers()
    }
    
    // MARK: IBActions
    
    @IBAction func refresh(_ sender: Any) {
        self.reloadUsers()
    }
    
}

// MARK: TableView Delegates

extension ListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let object = users?.results![indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(object?.firstName ?? "") \(object?.lastName ?? "")"
        cell.detailTextLabel?.text = object?.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = users?.results![indexPath.row]
        let url = URL(string: (object?.mediaURL)!)
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
}

// MARK: TableView DataSources

extension ListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users?.results?.count ?? 0
    }
}
