//
//  SmartCheckViewController.swift
//  FaceRecognition
//
//  Created by Aejaz Ahmed KI on 6/29/18.
//  Copyright © 2018 Lets Build That App. All rights reserved.
//

import UIKit
import Vision

class SmartCheckViewController: UIViewController
{
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        guard let image = UIImage(named: "sample2") else { return }
        
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "loginBg")!)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        let scaledHeight = view.frame.width / image.size.width * image.size.height
        
        imageView.frame = CGRect(x: 0, y:44 , width: view.frame.width, height: scaledHeight)
        imageView.backgroundColor = .blue
        
        view.addSubview(imageView)
        
        guard let imageSample2 = UIImage(named: "sample3") else { return }
        
        let imageView2 = UIImageView(image: imageSample2)
        
        imageView2.contentMode = .scaleAspectFit
        
        let scaledHeightForImage2 = view.frame.width / imageSample2.size.width * imageSample2.size.height
        
        imageView2.frame = CGRect(x: 0, y:44+imageView.frame.size.height, width: view.frame.width, height: scaledHeightForImage2)
        imageView2.backgroundColor = .blue
        
        view.addSubview(imageView2)
        
        let registerBtn = UIButton.init(frame: CGRect.init(x: 180, y: imageView2.frame.origin.y + imageView2.frame.size.height, width:100 , height: 50))
        
        registerBtn.setTitle("Close", for: .normal)
        registerBtn.setTitleColor(UIColor.blue, for: .normal)
        registerBtn.addTarget(self, action: #selector(self.closed), for: .touchUpInside)
       
        self.view.addSubview(registerBtn)
        
        let request = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            if(req.results?.count==0 || !(req.results != nil))
            {
                print("Failed to detect faces:")
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeight * faceObservation.boundingBox.height
                    
                    let y = 44+scaledHeight * (1 -  faceObservation.boundingBox.origin.y) - height
                    
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
                
                let alert = UIAlertController(title: "Success", message: "Failed to detect faces: Please scan anything else", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.dismiss(animated: true, completion: nil)
                    case .cancel:
                         self.dismiss(animated: true, completion: nil)
                    case .destructive:
                         self.dismiss(animated: true, completion: nil)
                    }}))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            if(req.results?.count==0 || !(req.results != nil))
            {
                print("Failed to detect faces:")
                
                let alert = UIAlertController(title: "Error", message: "We can play hide and seek after your picture is taken", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style{
                    case .default:
                        print("default")
                        self.dismiss(animated: true, completion: nil)
                    case .cancel:
                        self.dismiss(animated: true, completion: nil)
                    case .destructive:
                        self.dismiss(animated: true, completion: nil)
                    }}))
                
                self.present(alert, animated: true, completion: nil)
                
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeightForImage2 * faceObservation.boundingBox.height
                    
                    let y = 44+scaledHeight + scaledHeightForImage2 * (1 -  faceObservation.boundingBox.origin.y) - height
                    
                    let width = self.view.frame.width * faceObservation.boundingBox.width
                    
                    
                    let redView = UIView()
                    redView.backgroundColor = .red
                    redView.alpha = 0.4
                    redView.frame = CGRect(x: x, y: y, width: width, height: height)
                    self.view.addSubview(redView)
                    
                    print(faceObservation.boundingBox)
                    
                    let alert = UIAlertController(title: "Success", message: "We are able to recognize your face", preferredStyle: UIAlertControllerStyle.alert)
                    
                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                        switch action.style{
                        case .default:
                            print("default")
                            
                        case .cancel:
                            print("cancel")
                            
                        case .destructive:
                            print("destructive")
                        }}))
                    
                    self.present(alert, animated: true, completion: nil)
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
        
        let closeBtn = UIBarButtonItem.init(title: "Close", style: .done, target:self, action: #selector(self.closed))
        
        self.navigationController?.navigationItem.leftBarButtonItem = closeBtn
    
        
    }
    
    @objc func closed()
    {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}










