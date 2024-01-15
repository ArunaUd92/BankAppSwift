//
//  NVActivityIndicator.swift
//  NVActivityIndicatorViewDemo
//


import UIKit
//import NVActivityIndicatorView

open class NVActivityIndicator : UIView {
    public static func startActivity (_ inView:UIView, indicatorType:NVActivityIndicatorType){
        let activityIndicator:NVActivityIndicator = NVActivityIndicator(frame: inView.bounds)
        
        let width = inView.frame.size.width/7
        let height = width
        
        let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: width, height: height), type: indicatorType, color: UIColor(hexString: UIConstants.COLOR_APP_BLUE))
        activityIndicatorView.center = activityIndicator.center
        activityIndicatorView.startAnimating()
        activityIndicator.addSubview(activityIndicatorView)
        inView.addSubview(activityIndicator)
    }
    
    public static func stopActivity (_ inView:UIView){
        for case let activityIndicator as NVActivityIndicator in inView.subviews {
            
            UIView.animate(withDuration: 0.5, animations: {
                activityIndicator.alpha = 0
            }, completion: { (finished) in
                activityIndicator.removeFromSuperview()
            })
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    }
}
