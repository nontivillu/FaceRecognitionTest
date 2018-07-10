//
//  ExtractViewController.swift
//  FaceRecognition
//
//  Created by Aejaz Ahmed KI on 6/29/18.
//  Copyright © 2018 Lets Build That App. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ExtractViewController: UIViewController {
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //LETS LOAD AN IMAGE FROM RESOURCE
     //   let loadedImage:UIImage = UIImage(named: "sample4.png")! //TRY Sample2, Sample3 too
        
        //WE NEED A CIIMAGE - NOT NEEDED TO SCALE
    //    inputImage = CIImage(image:loadedImage)
        
        //LET'S DO IT
    //    self.doOCR(ciImage: inputImage!)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
