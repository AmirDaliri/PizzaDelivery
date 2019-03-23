//
//  CurverdView.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 22.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

class CurverdView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        // Drawing code
        
        let path = UIBezierPath()
        
        let arcHeight = self.frame.size.height * 0.3
        let viewWidth = self.frame.size.width
        
        path.move(to: CGPoint(x: viewWidth, y: self.frame.size.height - arcHeight))
        path.addLine(to: CGPoint(x: self.frame.size.width, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: self.frame.size.height - arcHeight))
        path.addQuadCurve(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height - arcHeight), controlPoint: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height + arcHeight))
        
        path.move(to: CGPoint(x: self.frame.size.width/2, y: self.frame.size.height))
        path.close()
        UIColor.clear.setStroke()
        UIColor.red.setFill()
        path.stroke()
        path.reversing()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.red.cgColor
        self.layer.mask = shapeLayer;
        self.layer.masksToBounds = true;
    }
}
