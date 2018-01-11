//
//  CreateCompanyController.swift
//  C0reData4pp
//
//  Created by sergey.tereshkin on 10/01/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit

// Custom Delegation

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
}

class CreateCompanyController: UIViewController {
    
    var delegate: CreateCompanyControllerDelegate?
    
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
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .darkBlue
    }
    
    private func setupUI() {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        
        NSLayoutConstraint.activate([
            
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 50),
            
            nameLabel.topAnchor.constraint(equalTo: view.topAnchor),
//            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
//            nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor)
            
            ])
    }
    
    @objc func handleSave() {
        
        dismiss(animated: true) {
            guard let name = self.nameTextField.text else {
                return
            }
            
            let company = Company(name: name, founded: Date())
            
            self.delegate?.didAddCompany(company: company)
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
}
