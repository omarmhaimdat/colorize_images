//
//  ColorizeViewController.swift
//  colorize_images
//
//  Created by M'haimdat omar on 04-10-2020.
//

import UIKit
import Alamofire

class ColorizeViewController: UIViewController {
    
    var apiEntryPoint = "http://6ce351dc1d61.ngrok.io/deoldify"
    
    var colorizedImage: UIImage?
    var originalImage: UIImage?
    
    lazy var inputImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.layer.masksToBounds = true
        image.clipsToBounds = false
        return image
    }()
    
    lazy var saveImage: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToSaveImage(_:)), for: .touchUpInside)
        button.setTitle("Download", for: .normal)
        let icon = UIImage(systemName: "square.and.arrow.down")?.resized(newSize: CGSize(width: 35, height: 35))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        return button
    }()
    
    lazy var dissmissButton: CustomButton = {
        let button = CustomButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonToDissmiss(_:)), for: .touchUpInside)
        button.setTitle("Dismiss", for: .normal)
        let icon = UIImage(systemName: "xmark.circle")?.resized(newSize: CGSize(width: 35, height: 35))
        let tintedImage = icon?.withRenderingMode(.alwaysTemplate)
        button.setImage(tintedImage, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.2103202343, green: 0.04934032261, blue: 0.6662924886, alpha: 1)
        addSubviews()
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorizeImages()
    }
    
    func addSubviews() {
        view.addSubview(inputImage)
        view.addSubview(saveImage)
        view.addSubview(dissmissButton)
    }
    
    func setupLayout() {
        inputImage.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        inputImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputImage.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        inputImage.heightAnchor.constraint(equalToConstant: (inputImage.image?.size.height)!*view.frame.width/(inputImage.image?.size.width)!).isActive = true
        inputImage.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        inputImage.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        saveImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        saveImage.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        saveImage.bottomAnchor.constraint(equalTo: dissmissButton.topAnchor, constant: -40).isActive = true
        
        dissmissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dissmissButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dissmissButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40).isActive = true
        dissmissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100).isActive = true
    }
    
    func colorizeImages() {
        let imageDataBase64 = inputImage.image!.jpegData(compressionQuality: 1)!.base64EncodedString(options: .lineLength64Characters)
        
        let parameters: Parameters = ["image": imageDataBase64]
        
        AF.request(URL.init(string: self.apiEntryPoint)!, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: .none).responseJSON { (response) in
            
        switch response.result {

            case .success(let value):
                    if let JSON = value as? [String: Any] {
                        let base64StringOutput = JSON["output_image"] as! String
                        let newImageData = Data(base64Encoded: base64StringOutput)
                        if let newImageData = newImageData {
                           let outputImage = UIImage(data: newImageData)
                            let finalOutputImage = outputImage
                            self.inputImage.image = finalOutputImage
                            self.colorizedImage = finalOutputImage
                        }
                    }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    @objc func buttonToDissmiss(_ sender: CustomButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func buttonToSaveImage(_ sender: CustomButton) {
        UIImageWriteToSavedPhotosAlbum(self.colorizedImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            triggerAlert(title: "Error while saving", message: error.localizedDescription)
        } else {
            triggerAlert(title: "Saved", message: "You can find your image in the photo library")
        }
    }
    
    func triggerAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

