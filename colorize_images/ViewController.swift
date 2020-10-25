//
//  ViewController.swift
//  colorize_images
//
//  Created by M'haimdat omar on 04-10-2020.
//

import UIKit

import UIKit
import Vision

let screenWidth = UIScreen.main.bounds.width

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let logo: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "default").resized(newSize: CGSize(width: screenWidth - 20, height: screenWidth - 20)))
        image.translatesAutoresizingMaskIntoConstraints = false
       return image
    }()
    
    lazy var openCameraBtn : CustomButton = {
       let btn = CustomButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Camera", for: .normal)
        let icon = UIImage(named: "camera")?.resized(newSize: CGSize(width: 45, height: 45))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        btn.setImage(tintedImage, for: .normal)
        btn.tintColor = #colorLiteral(red: 0.892498076, green: 0.5087850094, blue: 0.9061965346, alpha: 1)
        btn.addTarget(self, action: #selector(buttonToOpenCamera(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var openToUploadBtn : CustomButton = {
       let btn = CustomButton()
        btn.addTarget(self, action: #selector(buttonToUpload(_:)), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2103202343, green: 0.04934032261, blue: 0.6662924886, alpha: 1)
        addButtonsToSubview()
        setupView()
    }
    
    fileprivate func addButtonsToSubview() {
        view.addSubview(logo)
        view.addSubview(openCameraBtn)
        view.addSubview(openToUploadBtn)
    }
    
    fileprivate func setupView() {
        
        logo.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        openCameraBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openCameraBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        openCameraBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        openCameraBtn.bottomAnchor.constraint(equalTo: openToUploadBtn.topAnchor, constant: -40).isActive = true
        
        openToUploadBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        openToUploadBtn.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        openToUploadBtn.heightAnchor.constraint(equalToConstant: 60).isActive = true
        openToUploadBtn.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -120).isActive = true
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
            
        if let image = info[.originalImage] as? UIImage {
            
            let outputVC = ColorizeViewController()
            outputVC.modalPresentationStyle = .fullScreen
            outputVC.inputImage.image = image
            dismiss(animated: true, completion: nil)
            self.present(outputVC, animated: true, completion: nil)
            
        }
    }
    
    @objc func buttonToUpload(_ sender: CustomButton) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    @objc func buttonToOpenCamera(_ sender: CustomButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }

}


