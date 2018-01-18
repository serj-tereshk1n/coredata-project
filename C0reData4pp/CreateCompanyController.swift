//
//  CreateCompanyController.swift
//  C0reData4pp
//
//  Created by sergey.tereshkin on 10/01/2018.
//  Copyright © 2018 sergey.tereshkin. All rights reserved.
//

import UIKit
import CoreData

// Custom Delegation

protocol CreateCompanyControllerDelegate {
    func didAddCompany(company: Company)
    func didEditCompany(company: Company)
}

class CreateCompanyController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var delegate: CreateCompanyControllerDelegate?
    var company: Company? {
        didSet {
            nameTextField.text = company?.name
            datePicker.date = company?.founded ?? Date()
            if let imageData = company?.imageData {
                companyImageView.image = UIImage(data:imageData)
            }
            companyImageView.layer.cornerRadius = companyImageView.frame.width / 2
        }
    }
    
    lazy var companyImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "select_photo_empty"))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto)))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.darkBlue.cgColor
        imageView.layer.borderWidth = 2
        return imageView
    }()
    
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
    
    let datePicker: UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = .date
        dp.translatesAutoresizingMaskIntoConstraints = false
        return dp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        view.backgroundColor = .darkBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = company == nil ? "Create company" : "Edit Company"
    }
    
    private func setupUI() {
        let lightBlueBackgroundView = UIView()
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(lightBlueBackgroundView)
        view.addSubview(companyImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(datePicker)
        
        NSLayoutConstraint.activate([
            
            // background view
            lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 350),
            
            // company image
            companyImageView.topAnchor.constraint(equalTo: view.topAnchor),
            companyImageView.heightAnchor.constraint(equalToConstant: 100),
            companyImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            companyImageView.widthAnchor.constraint(equalToConstant: 100),
            
            // label name
            nameLabel.topAnchor.constraint(equalTo: companyImageView.bottomAnchor),
            nameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            
            // company name
            nameTextField.leftAnchor.constraint(equalTo: nameLabel.rightAnchor),
            nameTextField.rightAnchor.constraint(equalTo: view.rightAnchor),
            nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor),
            
            // setup date picker
            datePicker.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            datePicker.leftAnchor.constraint(equalTo: view.leftAnchor),
            datePicker.rightAnchor.constraint(equalTo: view.rightAnchor),
            datePicker.bottomAnchor.constraint(equalTo: lightBlueBackgroundView.bottomAnchor)
            
            ])
    }
    
    // PRAGMA MARK - action functions
    @objc func handleSelectPhoto() {
        print("Trying to select photo...")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        
        if company == nil{
            createCompany()
        } else {
            saveCompanyChanges()
        }
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // PRAGMA MARK - utility functions
    private func saveCompanyChanges() {
        
        guard let name = self.nameTextField.text else {
            return
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        
        company?.name = name
        company?.founded = datePicker.date
        
        if let coImage = companyImageView.image {
            company?.imageData = UIImageJPEGRepresentation(coImage, 0.8)
        }
        
        do {
            try context.save()
            dismiss(animated: true) {
                self.delegate?.didEditCompany(company: self.company!)
            }
        } catch let saveErr {
            print("failed to save company changes:", saveErr)
        }

    }
    
    private func createCompany() {
        guard let name = self.nameTextField.text else {
            return
        }
        
        let context = CoreDataManager.shared.persistentContainer.viewContext
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)
        
        if let coImage = companyImageView.image {
            let imageData = UIImageJPEGRepresentation(coImage, 0.8)
            company.setValue(imageData, forKey: "imageData")
        }
        
        company.setValue(name, forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")

        do {
            try context.save()
            
            dismiss(animated: true, completion: {
                self.delegate?.didAddCompany(company: company as! Company)
            })
            
        } catch let saveErr {
            print("Failed to save company:", saveErr)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            companyImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            companyImageView.image = originalImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
//    func setupCircularImageStyle() {
//    
//    }
}
