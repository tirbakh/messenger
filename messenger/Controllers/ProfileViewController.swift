//
//  ProfileViewController.swift
//  messenger
//
//  Created by Лада Тирбах on 15.05.2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let data = ["Выход"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "",
                                            message: "Вы уверены, что хотите выйти?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Отмена", style: .default, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Да", style: .destructive, handler: {[weak self] _ in
            guard let strongSelf = self else  {
                return
            }
    
            do {
                try Firebase.Auth.auth().signOut()
                let nav = UINavigationController(rootViewController: LoginViewController())
                
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: true)
            } catch {
                
            }
        }))
        
        present(actionSheet, animated: true, completion: nil)
    }
}
