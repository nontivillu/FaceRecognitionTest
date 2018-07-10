//
//  ViewController.swift
//  FaceRecognition
//
//  Created by Aejaz Iqbal on 6/29/18.
//  Copyright © 2017 Lets Build That App. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.lightGray
        
       // let rect = UIScreen.main.bounds
        
        self.view.backgroundColor = UIColor.lightGray
        
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "loginBg")!)
        
        
        let appName = UILabel.init(frame: CGRect.init(x: 200, y: 100, width:100 , height: 200))
        appName.text = "Slfin"
        appName.font = UIFont.italicSystemFont(ofSize: 40)
        appName.textColor = UIColor.white
        self.view.addSubview(appName)
        
        let login = UIButton.init(frame: CGRect.init(x: 180, y: 100+appName.frame.size.height, width:100 , height: 50))
        
        login.setTitle("Login", for: .normal)
        
        let logImage = UIImage(named: "checkInBtn") as UIImage?
        
        login.setImage(logImage, for:.normal)
        
        login.setTitleColor(UIColor.blue, for: .normal)
        
        login.addTarget(self, action: #selector(self.pressed), for: .touchUpInside)
        
        self.view.addSubview(login)
        
        
        let registerBtn = UIButton.init(frame: CGRect.init(x: 180, y: login.frame.origin.y + login.frame.size.height, width:100 , height: 50))
        
        registerBtn.setTitle("Sign Up", for: .normal)
        registerBtn.setTitleColor(UIColor.blue, for: .normal)
        registerBtn.addTarget(self, action: #selector(self.register), for: .touchUpInside)
        self.view.addSubview(registerBtn)
        
    }
    
    @objc func pressed() {
        
        let nextVC = SmartCheckViewController()
        let navcontroller = UINavigationController.init(rootViewController: nextVC)
        self.present(navcontroller, animated: true, completion: nil)
        
        
    }
    
    @objc func register() {
        
        let nextVC = SmartEnrollViewController()
        let navcontroller = UINavigationController.init(rootViewController: nextVC)
        self.present(navcontroller, animated: true, completion: nil)
        print("register button pressed, start scanning the photo");
       
    }

    
}
/*
 
 {
 super.viewDidLoad()
 
 guard let image = UIImage(named: "sample2") else { return }
 
 let imageView = UIImageView(image: image)
 imageView.contentMode = .scaleAspectFit
 
 let scaledHeight = view.frame.width / image.size.width * image.size.height
 
 imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scaledHeight)
 imageView.backgroundColor = .blue
 
 view.addSubview(imageView)
 
 guard let imageSample2 = UIImage(named: "sample3") else { return }
 
 let imageView2 = UIImageView(image: imageSample2)
 imageView2.contentMode = .scaleAspectFit
 
 let scaledHeightForImage2 = view.frame.width / imageSample2.size.width * imageSample2.size.height
 
 imageView2.frame = CGRect(x: 0, y: imageView.frame.size.height, width: view.frame.width, height: scaledHeightForImage2)
 imageView2.backgroundColor = .blue
 
 view.addSubview(imageView2)
 
 let request = VNDetectFaceRectanglesRequest { (req, err) in
 
 if let err = err {
 print("Failed to detect faces:", err)
 return
 }
 
 req.results?.forEach({ (res) in
 
 DispatchQueue.main.async {
 guard let faceObservation = res as? VNFaceObservation else { return }
 
 let x = self.view.frame.width * faceObservation.boundingBox.origin.x
 
 let height = scaledHeight * faceObservation.boundingBox.height
 
 let y = scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
 
 let width = self.view.frame.width * faceObservation.boundingBox.width
 
 
 let redView = UIView()
 redView.backgroundColor = .red
 redView.alpha = 0.4
 redView.frame = CGRect(x: x, y: y, width: width, height: height)
 self.view.addSubview(redView)
 
 print(faceObservation.boundingBox)
 }
 })
 }
 
 let requestForImage2 = VNDetectFaceRectanglesRequest { (req, err) in
 
 if let err = err {
 print("Failed to detect faces:", err)
 return
 }
 
 req.results?.forEach({ (res) in
 
 DispatchQueue.main.async {
 guard let faceObservation = res as? VNFaceObservation else { return }
 
 let x = self.view.frame.width * faceObservation.boundingBox.origin.x
 
 let height = scaledHeightForImage2 * faceObservation.boundingBox.height
 
 let y = scaledHeight + scaledHeightForImage2 * (1 -  faceObservation.boundingBox.origin.y) - height
 
 let width = self.view.frame.width * faceObservation.boundingBox.width
 
 
 let redView = UIView()
 redView.backgroundColor = .red
 redView.alpha = 0.4
 redView.frame = CGRect(x: x, y: y, width: width, height: height)
 self.view.addSubview(redView)
 
 print(faceObservation.boundingBox)
 }
 })
 }
 
 guard let cgImage = image.cgImage else { return }
 
 DispatchQueue.global(qos: .background).async {
 let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
 do {
 try handler.perform([request])
 } catch let reqErr {
 print("Failed to perform request:", reqErr)
 }
 }
 
 guard let cgImage2 = imageSample2.cgImage else { return }
 
 DispatchQueue.global(qos: .background).async {
 let handler = VNImageRequestHandler(cgImage: cgImage2, options: [:])
 do {
 try handler.perform([requestForImage2])
 } catch let reqErr {
 print("Failed to perform request:", reqErr)
 }
 }
 
 }
 
 */










