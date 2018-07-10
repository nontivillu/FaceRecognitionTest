//
//  WLoadingIndicator.swift
//  Weather
//
//  Created by Iqbal, Aejaz on 12/11/17.
//  Copyright © 2017 kiafire. All rights reserved.
//

import Foundation

import UIKit
 
final class WLoadingIndicator {
    
    // Add a container on top of the actual view, we can disable the interaction when loading view is dispayed.
    var container: UIView = UIView()
    
    // Customizing a background for the Loading Indicator
    var loadingView: UIView = UIView()
    
    //Actual Loading Indicator displayed to the user on Loading view
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    ///MARK: - Initializer : Singleton
    static let sharedInstance = WLoadingIndicator()
    
    private init() {
        ///Singleton Initializer must be private
    }
    
    /*
     Show customized activity indicator,
     actually add activity indicator to passing view
     
     @param uiView - add activity indicator to this view
     */
    func showActivityIndicator(uiView: UIView)
    {
        container.frame = uiView.frame
        container.center = uiView.center
        
        container.backgroundColor = UIColorFromHex(rgbValue: 0xffffff, alpha: 0.3)
        
        loadingView.frame = CGRect.init(x: 0, y: 0, width: 80, height: 80)
        
        loadingView.center = uiView.center
        
        loadingView.backgroundColor = UIColorFromHex(rgbValue:0x444444, alpha: 0.7)
        
        loadingView.clipsToBounds = true
        
        loadingView.layer.cornerRadius = 10
        
        activityIndicator.frame = CGRect.init(x: 0, y: 0, width: 40, height: 40)
        
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        
        activityIndicator.center = CGPoint.init(x:loadingView.frame.size.width / 2 , y: loadingView.frame.size.height / 2)
        
        loadingView.addSubview(activityIndicator)
        
        container.addSubview(loadingView)
        
        uiView.addSubview(container)
        
        activityIndicator.startAnimating()
    }
    
    /*
     Hide activity indicator
     Actually remove activity indicator from its super view
     
     @param uiView - remove activity indicator from this view
     */
    func hideActivityIndicator(uiView: UIView) {
        activityIndicator.stopAnimating()
        container.removeFromSuperview()
    }
    
    /*
     Define UIColor from hex value
     
     @param rgbValue - hex color value
     @param alpha - transparency level
     */
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
}
