//
//  RadialGradientView.swift
//  themustang
//
//  Created by Ashik Chalise on 8/22/19.
//  Copyright © 2019 Ashik Chalise. All rights reserved.
//

import UIKit

@IBDesignable
class RadialGradientView: UIView {
    
    @IBInspectable var InsideColor : UIColor = UIColor.clear
    @IBInspectable var OutsideColor : UIColor = UIColor.clear
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    
    override func draw(_ rect: CGRect) {
        let color  = [InsideColor.cgColor,OutsideColor.cgColor] as CFArray
        let endRadius = min(frame.width, frame.height)*1.2
        let location = [ 0.1, 1.0 ] as [CGFloat]
        let gradient = CGGradient(colorsSpace: nil, colors: color, locations: location)
        UIGraphicsGetCurrentContext()!.drawRadialGradient(gradient!, startCenter: center, startRadius: 0.0, endCenter: center, endRadius: endRadius, options: CGGradientDrawingOptions.drawsAfterEndLocation)
        
        
    }


}
