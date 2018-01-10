//
//  CreateCompanyController.swift
//  C0reData4pp
//
//  Created by sergey.tereshkin on 10/01/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

class CreateCompanyController: UIViewController {
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationItem.title = "Create company"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        view.backgroundColor = .darkBlue
    }
    
    private func setupUI() {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        nameLabel.backgroundColor = .yellow
        
        NSLayoutConstraint.activate([
            
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 50)
            
            ])
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
