//
//  SmartEnrollViewController.swift
//  FaceRecognition
//
//  Created by Aejaz Ahmed KI on 6/29/18.
//  Copyright © 2018 Lets Build That App. All rights reserved.
//

import UIKit
import Vision
import CoreML

class SmartEnrollViewController: UIViewController {

    //Text Extraction
    @IBOutlet weak var extractedContentLabel: UILabel!
    
    //Text Extraction
    @IBOutlet weak var registerBtn: UIButton!
    
    //HOLDS OUR INPUT
    var  inputImage:CIImage?
    
    //RESULT FROM OVERALL RECOGNITION
    var  recognizedWords:[String] = [String]()
    
    //RESULT FROM RECOGNITION
    var recognizedRegion:String = String()
    
    
    //OCR-REQUEST
    lazy var ocrRequest: VNCoreMLRequest = {
        do {
            //THIS MODEL IS TRAINED BY ME FOR FONT "Inconsolata" (Numbers 0...9 and UpperCase Characters A..Z)
            let model = try VNCoreMLModel(for:OCR().model)
            return VNCoreMLRequest(model: model, completionHandler: self.handleClassification)
        } catch {
            fatalError("cannot load model")
        }
    }()
    
    //OCR-HANDLER
    func handleClassification(request: VNRequest, error: Error?)
    {
        guard let observations = request.results as? [VNClassificationObservation]
            else {fatalError("unexpected result") }
        guard let best = observations.first
            else { fatalError("cant get best result")}
        
        self.recognizedRegion = self.recognizedRegion.appending(best.identifier)
    }
    
    //TEXT-DETECTION-REQUEST
    lazy var textDetectionRequest: VNDetectTextRectanglesRequest = {
        return VNDetectTextRectanglesRequest(completionHandler: self.handleDetection)
    }()
    
    //TEXT-DETECTION-HANDLER
    func handleDetection(request:VNRequest, error: Error?)
    {
        guard let observations = request.results as? [VNTextObservation]
            else {fatalError("unexpected result") }
        
        // EMPTY THE RESULTS
        self.recognizedWords = [String]()
        
        //NEEDED BECAUSE OF DIFFERENT SCALES
        let  transform = CGAffineTransform.identity.scaledBy(x: (self.inputImage?.extent.size.width)!, y:  (self.inputImage?.extent.size.height)!)
        
        //A REGION IS LIKE A "WORD"
        for region:VNTextObservation in observations
        {
            guard let boxesIn = region.characterBoxes else {
                continue
            }
            
            //EMPTY THE RESULT FOR REGION
            self.recognizedRegion = ""
            
            //A "BOX" IS THE POSITION IN THE ORIGINAL IMAGE (SCALED FROM 0... 1.0)
            for box in boxesIn
            {
                //SCALE THE BOUNDING BOX TO PIXELS
                let realBoundingBox = box.boundingBox.applying(transform)
                
                //TO BE SURE
                guard (inputImage?.extent.contains(realBoundingBox))!
                    else { print("invalid detected rectangle"); return}
                
                //SCALE THE POINTS TO PIXELS
                let topleft = box.topLeft.applying(transform)
                let topright = box.topRight.applying(transform)
                let bottomleft = box.bottomLeft.applying(transform)
                let bottomright = box.bottomRight.applying(transform)
                
                //LET'S CROP AND RECTIFY
                let charImage = inputImage?
                    .cropped(to: realBoundingBox)
                    .applyingFilter("CIPerspectiveCorrection", parameters: [
                        "inputTopLeft" : CIVector(cgPoint: topleft),
                        "inputTopRight" : CIVector(cgPoint: topright),
                        "inputBottomLeft" : CIVector(cgPoint: bottomleft),
                        "inputBottomRight" : CIVector(cgPoint: bottomright)
                        ])
                
                //PREPARE THE HANDLER
                let handler = VNImageRequestHandler(ciImage: charImage!, options: [:])
                
                //SOME OPTIONS (TO PLAY WITH..)
                self.ocrRequest.imageCropAndScaleOption = VNImageCropAndScaleOption.scaleFill
                
                //FEED THE CHAR-IMAGE TO OUR OCR-REQUEST - NO NEED TO SCALE IT - VISION WILL DO IT FOR US !!
                do {
                    try handler.perform([self.ocrRequest])
                }  catch { print("Error")}
                
            }
            
            //APPEND RECOGNIZED CHARS FOR THAT REGION
            self.recognizedWords.append(recognizedRegion)
        }
        
        //THATS WHAT WE WANT - PRINT WORDS TO CONSOLE
        DispatchQueue.main.async {
            self.PrintWords(words: self.recognizedWords)

        }
    }
    
    func PrintWords(words:[String])
    {
        // VOILA'
        print(recognizedWords)
        extractedContentLabel.numberOfLines = 0;
        extractedContentLabel.text = self.recognizedWords.joined(separator: ":");
        extractedContentLabel.sizeToFit()
        
    }
    
    func doOCR(ciImage:CIImage)
    {
        //PREPARE THE HANDLER
        let handler = VNImageRequestHandler(ciImage: ciImage, options:[:])
        
        //WE NEED A BOX FOR EACH DETECTED CHARACTER
        self.textDetectionRequest.reportCharacterBoxes = true
        self.textDetectionRequest.preferBackgroundProcessing = false
        
        //FEED IT TO THE QUEUE FOR TEXT-DETECTION
        DispatchQueue.global(qos: .userInteractive).async {
            do {
                try  handler.perform([self.textDetectionRequest])
            } catch {
                print ("Error")
            }
        }
        
    }
    
    //Text Extraction
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.init(patternImage: UIImage(named: "loginBg")!)
        
        self.navigationController?.title = "Scan"
        
        guard let imageSample2 = UIImage(named: "sample4") else { return }
        
        let imageView2 = UIImageView(image: imageSample2)
        imageView2.contentMode = .scaleAspectFit
        
        let scaledHeightForImage2 = view.frame.width / imageSample2.size.width * imageSample2.size.height
        
        imageView2.frame = CGRect(x: 0, y:44 , width: view.frame.width, height: scaledHeightForImage2)
        
        imageView2.backgroundColor = .blue
        
        view.addSubview(imageView2)
        
      //  let registerBtn = UIButton.init(frame: CGRect.init(x: 180, y: imageView2.frame.origin.y + imageView2.frame.size.height, width:100 , height: 50))
        
        registerBtn.setTitle("Register Me", for: .normal)
        registerBtn.setTitleColor(UIColor.blue, for: .normal)
        registerBtn.addTarget(self, action: #selector(self.close), for: .touchUpInside)
        
        self.view.addSubview(registerBtn)
        
        
        let requestForImage2 = VNDetectTextRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNTextObservation else { return }
                    
                    print(faceObservation)
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeightForImage2 * faceObservation.boundingBox.height
                    
                    let y = 44 + scaledHeightForImage2 * (1 -  faceObservation.boundingBox.origin.y) - height
                    
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
        
        let requestForImage3 = VNDetectFaceRectanglesRequest { (req, err) in
            
            if let err = err {
                print("Failed to detect faces:", err)
                return
            }
            
            if(req.results?.count==0 || !(req.results != nil))
            {
                print("Failed to detect faces:")
                
                let alert = UIAlertController(title: "Success", message: "Seems you like to play hide & seek", preferredStyle: UIAlertControllerStyle.alert)
                
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
                
                return
            }
            
            req.results?.forEach({ (res) in
                
                DispatchQueue.main.async {
                    
                    guard let faceObservation = res as? VNFaceObservation else { return }
                    
                    print(faceObservation)
                    
                    let x = self.view.frame.width * faceObservation.boundingBox.origin.x
                    
                    let height = scaledHeightForImage2 * faceObservation.boundingBox.height
                    
                    let y = 44 + scaledHeightForImage2 * (1 -  faceObservation.boundingBox.origin.y) - height
                    
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
        
        
        
        guard let cgImage2 = imageSample2.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            
            
            let handler = VNImageRequestHandler(cgImage: cgImage2, options: [:])
            do {
                try handler.perform([requestForImage2])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
        
        guard let cgImage3 = imageSample2.cgImage else { return }
        
        DispatchQueue.global(qos: .background).async {
            
            
            let handler = VNImageRequestHandler(cgImage: cgImage3, options: [:])
            do {
                try handler.perform([requestForImage3])
            } catch let reqErr {
                print("Failed to perform request:", reqErr)
            }
        }
        
        //LETS LOAD AN IMAGE FROM RESOURCE
        let loadedImage:UIImage = UIImage(named: "sample4.png")! //TRY Sample2, Sample3 too
        
        //WE NEED A CIIMAGE - NOT NEEDED TO SCALE
        inputImage = CIImage(image:loadedImage)
        
        //LET'S DO IT
        self.doOCR(ciImage: inputImage!)
        
    }
    
    @objc func close() {
        
        let alert = UIAlertController(title: "Success", message: "You are Registered Successfully", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Close & Login", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                 self.dismiss(animated: true, completion: nil)
                
            case .cancel:
                print("cancel")
                 self.dismiss(animated: true, completion: nil)
                
            case .destructive:
                print("destructive")
                 self.dismiss(animated: true, completion: nil)
            }}))
        self.present(alert, animated: true, completion: nil)
        
        
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
