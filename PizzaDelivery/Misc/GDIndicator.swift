//
//  GDIndicator.swift
//  PizzaDelivery
//
//  Created by Amir Daliri on 23.03.2019.
//  Copyright © 2019 Mozio. All rights reserved.
//

import UIKit

fileprivate func setupIndicatorConstraints(parentView: UIView, childView: UIView){
    let centerX = NSLayoutConstraint(item: childView, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    let centerY = NSLayoutConstraint(item: childView, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    
    let height = NSLayoutConstraint(item: childView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100)
    
    parentView.addConstraints([centerX, centerY, height])
}

fileprivate func setupIndicatorConstraints(contView: UIView, indicatorView: UIView, lbl: UILabel? = nil){
    let centerX = NSLayoutConstraint(item: indicatorView, attribute: .centerX, relatedBy: .equal, toItem: contView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
    let centerY = NSLayoutConstraint(item: indicatorView, attribute: .centerY, relatedBy: .equal, toItem: contView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
    
    let height = NSLayoutConstraint(item: indicatorView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
    let width = NSLayoutConstraint(item: indicatorView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50.0)
    
    if let lbl = lbl{
        let centerX = NSLayoutConstraint(item: lbl, attribute: .centerX, relatedBy: .equal, toItem: contView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
        let left = NSLayoutConstraint(item: lbl, attribute: .left, relatedBy: .equal, toItem: contView, attribute: .left, multiplier: 1.0, constant: 8.0)
        let right = NSLayoutConstraint(item: lbl, attribute: .right, relatedBy: .equal, toItem: contView, attribute: .right, multiplier: 1.0, constant: -8.0)
        let bottom = NSLayoutConstraint(item: lbl, attribute: .bottom, relatedBy: .equal, toItem: contView, attribute: .bottom, multiplier: 1.0, constant: -3.0)
        
        let desireWidth: CGFloat = lbl.frame.width < 100.0 ? 100.0 : lbl.frame.width + 16
        let width = NSLayoutConstraint(item: contView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: desireWidth)
        
        contView.addConstraints([centerX, left, right, bottom, width])
    }else{
        let width = NSLayoutConstraint(item: contView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 100.0)
        
        contView.addConstraint(width)
    }
    
    contView.addConstraints([centerX, centerY, height, width])
}

extension UIView{
    enum Indicator{
        case normal
        case blink
        case rotate
        case chain
        case chase
        case circle
    }
    
    enum BackgroundType{
        case dimmedWithBox
        case clearWithBox
        case dimmed
        case clear
    }
    
    /**
     Adds a loading to current window.
     
     - parameters:
     - onView: set a view to place indicator view on it, nil for active window
     - indicatorType: main animating indicator for indicator view
     - msg: indicator view message, nil for none
     - backgroundType: different types for background and indicator view background view
     */
    func showLoadSpin(onView: UIView? = nil, indicatorType: Indicator = .normal ,msg: String? = nil, backgroundType: BackgroundType = .dimmed){
        
        var targetView: UIView!
        if let target = onView{
            targetView = target
        }else{
            targetView = UIApplication.shared.delegate!.window!
        }
        
        if let _ = targetView.viewWithTag(10000){
            return
        }
        
        let bigView: UIView = UIView()
        bigView.tag = 10000
        bigView.frame = targetView.bounds
        targetView.addSubview(bigView)
        
        var indicatorView: UIView!
        switch indicatorType{
        case .normal:
            let activity = UIActivityIndicatorView(style: .whiteLarge)
            activity.translatesAutoresizingMaskIntoConstraints = false
            activity.startAnimating()
            
            indicatorView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            indicatorView.backgroundColor = UIColor.clear
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            
            indicatorView.addSubview(activity)
            
            let centerX = NSLayoutConstraint(item: activity, attribute: .centerX, relatedBy: .equal, toItem: indicatorView, attribute: .centerX, multiplier: 1.0, constant: 0.0)
            let centerY = NSLayoutConstraint(item: activity, attribute: .centerY, relatedBy: .equal, toItem: indicatorView, attribute: .centerY, multiplier: 1.0, constant: 0.0)
            
            indicatorView.addConstraints([centerX, centerY])
            break
        case .blink:
            indicatorView = GDCircularDotsBlinking()
            break
        case .chain:
            indicatorView = GDCircularDotsChain()
            break
        case .chase:
            indicatorView = GDHalfCircleRotating()
            break
        case .rotate:
            indicatorView = GDCircularDotsRotating()
            break
        case .circle:
            indicatorView = GDCircle()
        }
        
        let containerView: UIView = UIView()
        containerView.layer.cornerRadius = 10
        
        bigView.addSubview(containerView)
        containerView.addSubview(indicatorView)
        
        indicatorView.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        setupIndicatorConstraints(parentView: bigView, childView: containerView)
        
        if let msg = msg{
            let lbl: UILabel = UILabel()
            lbl.textColor = UIColor.white
            lbl.font = UIFont.systemFont(ofSize: 13)
            lbl.text = msg
            lbl.textAlignment = .center
            lbl.translatesAutoresizingMaskIntoConstraints = false
            lbl.sizeToFit()
            
            containerView.addSubview(lbl)
            setupIndicatorConstraints(contView: containerView, indicatorView: indicatorView, lbl: lbl)
        }else{
            setupIndicatorConstraints(contView: containerView, indicatorView: indicatorView)
        }
        
        switch backgroundType{
        case .clear:
            bigView.backgroundColor = UIColor.clear
            break
        case .dimmed:
            bigView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            break
        case .clearWithBox:
            bigView.backgroundColor = UIColor.clear
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            break
        case .dimmedWithBox:
            bigView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            containerView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            break
        }
    }
    
    func hideLoadingSpin() {
        guard let v = UIApplication.shared.delegate!.window!!.viewWithTag(10000) else{ return }
        v.removeFromSuperview()
    }
}

class GDCircle: UIView{
    fileprivate var progressShape: CAShapeLayer = CAShapeLayer()
    fileprivate var routeShape: CAShapeLayer? = nil
    fileprivate var progressLabel: UILabel? = nil
    fileprivate var detailsLabel: UILabel? = nil
    fileprivate var progressPath: UIBezierPath!
    
    var animationTime: CGFloat = 3.0
    var animationDelay: CGFloat = 2.0
    var lineWidth: CGFloat = 8.0
    var shouldRotate: Bool = true
    var shouldGradiant: Bool = false
    var progressColor: UIColor = UIColor.white
    var grad1Color: UIColor = UIColor.white
    var grad2Color: UIColor = UIColor.black
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
    }
    
    /**
     - parameters:
     - animationTime: duration of animation
     - animationDelay:  delay between start and end of animation
     - lineWidth: width of circle
     - shouldRotate: rotate animating circle
     - shouldGradiant: set a gradiant on circle
     - progressColor: color of circle
     - grad1Color: first grad color of circle - only if shouldGradiant is set to true
     - grad2Color: second grad color of circle - only if shouldGradiant is set to true
     */
    init(frame: CGRect, animationTime: CGFloat, animationDelay: CGFloat, lineWidth: CGFloat, shouldRotate: Bool, shouldGradiant: Bool, progressColor: UIColor, grad1Color: UIColor = UIColor.white, grad2Color: UIColor = UIColor.black) {
        super.init(frame: frame)
        
        self.animationTime = animationTime
        self.animationDelay = animationDelay
        self.lineWidth = lineWidth
        self.shouldRotate = shouldRotate
        self.shouldGradiant = shouldGradiant
        self.progressColor = progressColor
        self.grad1Color = grad1Color
        self.grad2Color = grad2Color
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.createMainLayer()
    }
    
    //MARK: - Layers
    //Create custom shape layers
    fileprivate func createMainPath() -> UIBezierPath{
        let circleRaduis = (min(self.bounds.width, self.bounds.height) / 2 - progressShape.lineWidth) / 2
        let circleCenter = CGPoint(x: bounds.midX , y: bounds.midY)
        let startAngle = CGFloat(Double.pi / 2)
        let endAngle = startAngle + CGFloat(Double.pi * 2)
        
        let progressBezier = UIBezierPath(arcCenter: circleCenter, radius: circleRaduis, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        return progressBezier
    }
    
    fileprivate func createMainLayer(){
        progressShape.path = createMainPath().cgPath
        progressShape.backgroundColor = UIColor.clear.cgColor
        progressShape.fillColor = nil
        progressShape.strokeColor = progressColor.cgColor
        progressShape.lineWidth = self.lineWidth
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd = 0.0
        progressShape.lineJoin = CAShapeLayerLineJoin(rawValue: "round")
        
        if shouldGradiant{
            let gradiantLayer = createGradiantLayer(grad1Color, g2: grad2Color)
            gradiantLayer.mask = progressShape
            layer.addSublayer(gradiantLayer)
        }else{
            let maskLayer = CAShapeLayer()
            maskLayer.strokeColor = progressColor.cgColor
            maskLayer.lineWidth = self.lineWidth
            maskLayer.strokeStart = 0.0
            maskLayer.strokeEnd = 1.0
            maskLayer.lineJoin = CAShapeLayerLineJoin(rawValue: "round")
            maskLayer.path = progressShape.path
            
            maskLayer.mask = progressShape
            layer.addSublayer(maskLayer)
        }
        self.startProgress()
    }
    
    fileprivate func createGradiantLayer(_ g1: UIColor, g2: UIColor) -> CAGradientLayer{
        let gLayer = CAGradientLayer()
        gLayer.frame = self.bounds
        gLayer.locations = [0.0, 1.0]
        
        let top = grad1Color.cgColor
        let bot = grad2Color.cgColor
        gLayer.colors = [top, bot]
        
        return gLayer
    }
    
    fileprivate func startProgress(){
        let startAnimation = CABasicAnimation(keyPath: "strokeEnd")
        startAnimation.fromValue = 0.0
        startAnimation.toValue = 1.0
        startAnimation.duration = CFTimeInterval(self.animationTime)
        
        startAnimation.setValue("animation", forKey: "strokeEnd")
        startAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        let endAnimation = CABasicAnimation(keyPath: "strokeStart")
        endAnimation.beginTime = CFTimeInterval(animationDelay)
        endAnimation.fromValue = 0.0
        endAnimation.toValue = 1.0
        endAnimation.duration = CFTimeInterval(self.animationTime - animationDelay)
        
        endAnimation.setValue("animation", forKey: "strokeStart")
        endAnimation.fillMode = CAMediaTimingFillMode.forwards
        
        // if it's a circular path, it can have a rotation animation
        //shouldRotate var indicate if progressbar should rotate
        if shouldRotate{
            rotate()
        }
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [startAnimation, endAnimation]
        groupAnim.duration = CFTimeInterval(self.animationTime)
        groupAnim.repeatCount = HUGE
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        
        progressShape.add(groupAnim, forKey: "gruoupAnim")
    }
    
    func rotate(){
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = Double.pi * 2// rotate 360 degrees
        rotateAnimation.duration = CFTimeInterval(self.animationTime * 1.2)
        rotateAnimation.repeatCount = HUGE
        self.layer.add(rotateAnimation, forKey: nil)
    }
}

class GDCircularDotsBlinking: UIView{
    var circleRadius: CGFloat = 5.0
    var circleSpace: CGFloat = 7
    var animDuration: CFTimeInterval = 0.7
    var shapeCol: UIColor = UIColor.black
    var circleCount: Int = 5
    var colCount: Int = 0
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
    }
    
    /**
     - parameters:
     - cRadius: radius of circles
     - cSpace:  space between each circle
     - aDuration: animation duration
     - shapeColor: color of circles
     - cCount: number of circles in a row
     - colCount: number of columns
     */
    init(frame: CGRect, cRadius: CGFloat, cSpace: CGFloat, aDuration: CFTimeInterval, shapeColor: UIColor, cCount: Int, colCount: Int) {
        super.init(frame: frame)
        
        self.circleRadius = cRadius
        self.circleSpace = cSpace
        self.animDuration = aDuration
        self.shapeCol = shapeColor
        self.circleCount = cCount
        self.colCount = colCount
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.circularDotsIndicator()
    }
    
    func circularDotsIndicator(){
        //Setting properties
        let circleStart: CGFloat = 0.0
        let circleEnd: CGFloat = CGFloat(Double.pi * 2)
        let animTime = CACurrentMediaTime()
        let animTimes = [0.0, 0.5, 0.8, 1, 1.2, 1.26, 1.4, 1.6, 1.9, 2.1, 2.4, 2.8]
        
        //Create Circle bezier path
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: circleRadius, startAngle: circleStart, endAngle: circleEnd, clockwise: true)
        
        //Calculate position of circles
        let size = (2 * circleRadius) * CGFloat(circleCount / 2)
        let x = (frame.width) / 2 - size
        let y = frame.height / 2
        
        //Add animations
        //Fade animation
        let fadeAnim = CABasicAnimation(keyPath: "opacity")
        fadeAnim.fromValue = 0.5
        fadeAnim.toValue = 1.0
        fadeAnim.duration = animDuration
        
        //X animation scale
        let xAnim = CAKeyframeAnimation(keyPath: "transform.scale.x")
        xAnim.values = [0.7, 1, 0.7]
        xAnim.keyTimes = [0.3, 0.6, 1]
        
        //Y animation scale
        let yAnim = CAKeyframeAnimation(keyPath: "transform.scale.y")
        yAnim.values = [0.7, 1, 0.7]
        yAnim.keyTimes = [0.3, 0.6, 1]
        
        let groupAnim = CAAnimationGroup()
        groupAnim.duration = animDuration
        groupAnim.isRemovedOnCompletion = false
        groupAnim.repeatCount = HUGE
        groupAnim.animations = [fadeAnim, xAnim, yAnim]
        
        //Create n shapes with animations
        if colCount != 0{
            for i in 0..<circleCount{
                for j in 0..<colCount{
                    //Create Shape for path
                    let shapeToAdd = CAShapeLayer()
                    shapeToAdd.fillColor = shapeCol.cgColor
                    shapeToAdd.strokeColor = nil
                    shapeToAdd.path = path.cgPath
                    
                    let frame = CGRect(
                        x: (x + circleRadius * CGFloat(i) + circleSpace * CGFloat(i)),
                        y: (y + circleRadius * CGFloat(j) + circleSpace * CGFloat(j)),
                        width: circleRadius,
                        height: circleRadius)
                    shapeToAdd.frame = frame
                    
                    groupAnim.beginTime = animTime + animTimes[i]
                    
                    layer.addSublayer(shapeToAdd)
                    shapeToAdd.add(groupAnim, forKey: "circularDotsIndicator")
                }
            }
        }else{
            for i in 0..<circleCount{
                //Create Shape for path
                let shapeToAdd = CAShapeLayer()
                shapeToAdd.fillColor = shapeCol.cgColor
                shapeToAdd.strokeColor = nil
                shapeToAdd.path = path.cgPath
                
                let frame = CGRect(
                    x: (x + circleRadius * CGFloat(i) + circleSpace * CGFloat(i)),
                    y: y,
                    width: circleRadius,
                    height: circleRadius)
                shapeToAdd.frame = frame
                
                groupAnim.beginTime = animTime + animTimes[i]
                
                layer.addSublayer(shapeToAdd)
                shapeToAdd.add(groupAnim, forKey: "circularDotsIndicator")
            }
        }
    }
}

class GDCircularDotsRotating: UIView{
    var circleRadius: CGFloat = 8.0
    var circleSpace: CGFloat = 30
    var animDuration: CFTimeInterval = 3
    var topLeftCircleColor: UIColor = UIColor.white
    var topRightCircleColor: UIColor = UIColor.black
    var bottomLeftCircleColor: UIColor = UIColor.black
    var bottomRightCircleColor: UIColor = UIColor.white
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    /**
     - parameters:
     - parameter cRadius: radius of circles
     - parameter cSpace: space between circles
     - parameter aDuration: duration of each interval of animation
     - parameter topLeftColor: top-left circle color
     - parameter topRightColor: top-right circle color
     - parameter bottomLeftColor: bottom-left circle color
     - parameter bottomRightColor: bottom-right circle color
     */
    init(frame: CGRect, cRadius: CGFloat, cSpace: CGFloat, aDuration: CFTimeInterval, topLeftColor: UIColor, topRightColor: UIColor, bottomLeftColor: UIColor, bottomRightColor: UIColor){
        super.init(frame: frame)
        
        self.circleRadius = cRadius
        self.circleSpace = cSpace
        self.animDuration = aDuration
        self.topLeftCircleColor = topLeftColor
        self.topRightCircleColor = topRightColor
        self.bottomLeftCircleColor = bottomLeftColor
        self.bottomRightCircleColor = bottomRightColor
        
        self.setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.circularDotsRotatingIndicator()
    }
    
    func circularDotsRotatingIndicator(){
        //Setting properties
        let circleStart: CGFloat = 0.0
        let circleEnd: CGFloat = CGFloat(Double.pi * 2)
        let animTime = CACurrentMediaTime()
        
        //Calculate possition for each circle in different directions
        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let topLeft = CGPoint(x: center.x - circleSpace, y: center.y - circleSpace)
        let topRight = CGPoint(x: center.x + circleSpace, y: center.y - circleSpace)
        let bottomLeft = CGPoint(x: center.x - circleSpace , y: center.y + circleSpace)
        let bottomRight = CGPoint(x: center.x + circleSpace , y: center.y + circleSpace)
        let circleSize = CGSize(width: circleRadius, height: circleRadius)
        
        let lineWidth: CGFloat = 3.0
        let timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        
        //Create Circle bezier path
        let path = UIBezierPath(arcCenter: CGPoint.zero, radius: circleRadius, startAngle: circleStart, endAngle: circleEnd, clockwise: true)
        
        //Top Left circle shape
        let topLeftCircle = CAShapeLayer()
        topLeftCircle.fillColor = topLeftCircleColor.cgColor
        topLeftCircle.strokeColor = topLeftCircleColor.cgColor
        topLeftCircle.strokeStart = 0.0
        topLeftCircle.strokeEnd = 1.0
        topLeftCircle.lineWidth = lineWidth
        topLeftCircle.path = path.cgPath
        topLeftCircle.frame = CGRect(origin: topLeft, size: circleSize)
        
        layer.addSublayer(topLeftCircle)
        
        //Top right circle shape
        let topRightCircle = CAShapeLayer()
        topRightCircle.fillColor = topRightCircleColor.cgColor
        topRightCircle.strokeColor = topRightCircleColor.cgColor
        topRightCircle.strokeStart = 0.0
        topRightCircle.strokeEnd = 1.0
        topRightCircle.lineWidth = lineWidth
        topRightCircle.path = path.cgPath
        topRightCircle.frame = CGRect(origin: topRight, size: circleSize)
        
        layer.addSublayer(topRightCircle)
        
        //bottom Left circle shape
        let bottomLeftCircle = CAShapeLayer()
        bottomLeftCircle.fillColor = bottomLeftCircleColor.cgColor
        bottomLeftCircle.strokeColor = bottomLeftCircleColor.cgColor
        bottomLeftCircle.strokeStart = 0.0
        bottomLeftCircle.strokeEnd = 1.0
        bottomLeftCircle.lineWidth = lineWidth
        bottomLeftCircle.path = path.cgPath
        bottomLeftCircle.frame = CGRect(origin: bottomLeft, size: circleSize)
        
        layer.addSublayer(bottomLeftCircle)
        
        //bottom right circle shape
        let bottomRightCircle = CAShapeLayer()
        bottomRightCircle.fillColor = bottomRightCircleColor.cgColor
        bottomRightCircle.strokeColor = bottomRightCircleColor.cgColor
        bottomRightCircle.strokeStart = 0.0
        bottomRightCircle.strokeEnd = 1.0
        bottomRightCircle.lineWidth = lineWidth
        bottomRightCircle.path = path.cgPath
        bottomRightCircle.frame = CGRect(origin: bottomRight, size: circleSize)
        
        layer.addSublayer(bottomRightCircle)
        
        //Rotate animation
        let rotateAnim = CAKeyframeAnimation(keyPath: "transform.rotation.z")
        rotateAnim.values = [0, Double.pi , Double.pi * 2]
        rotateAnim.keyTimes = [0.0, 0.4, 1]
        rotateAnim.repeatCount = HUGE
        rotateAnim.duration = animDuration / 2
        rotateAnim.isRemovedOnCompletion = false
        rotateAnim.timingFunctions = [timingFunction, timingFunction, timingFunction]
        
        layer.add(rotateAnim, forKey: nil)
        
        //Translate position animation
        let transAnim = CAKeyframeAnimation(keyPath: "position")
        transAnim.duration = animDuration
        transAnim.keyTimes = [0.0, 0.3, 0.5, 0.7, 1]
        transAnim.isRemovedOnCompletion = false
        transAnim.timingFunctions = [timingFunction, timingFunction, timingFunction, timingFunction]
        transAnim.repeatCount = HUGE
        
        func setTransisionValues(_ shapeToAdd: CAShapeLayer, values: [CGPoint]){
            transAnim.values = [NSValue(cgPoint: values[0]), NSValue(cgPoint: values[1]), NSValue(cgPoint: values[2]), NSValue(cgPoint: values[3]), NSValue(cgPoint: values[4])]
            shapeToAdd.add(transAnim, forKey: "circularDotsRotatingIndicator")
        }
        
        setTransisionValues(topLeftCircle, values: [topLeft, center, bottomRight, center, topLeft])
        setTransisionValues(topRightCircle, values: [topRight, center, bottomLeft, center, topRight])
        setTransisionValues(bottomLeftCircle, values: [bottomLeft, center, topRight, center, bottomLeft])
        setTransisionValues(bottomRightCircle, values: [bottomRight, center, topLeft, center, bottomRight])
    }
}

class GDCircularDotsChain: UIView{
    //MARK: - default variables
    var circleRadius: CGFloat = 5.0
    var radiusMultiplier: CGFloat = 5
    var animDuration: CFTimeInterval = 2.0
    var isRotating: Bool = true
    
    
    override init(frame: CGRect){
        super.init(frame: frame)
        
        setupView()
    }
    
    /**
     - parameters:
     - cRadius: circle radius and circles size
     - rMultiplier: radius of the rotation path. bigger values means bigger rotation area
     - aDuration: duration of a full rotation
     - isRotateOn: should the loading bar roate itself
     */
    init(frame: CGRect, cRadius: CGFloat, rMultiplier: CGFloat, aDuration: CFTimeInterval, isRotateOn: Bool){
        super.init(frame: frame)
        
        self.isRotating = isRotateOn
        self.circleRadius = cRadius
        self.radiusMultiplier = rMultiplier
        self.animDuration = aDuration
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.circularDotsRotatingChain()
    }
    
    func circularDotsRotatingChain(){
        var circleShape: CAShapeLayer!
        let circleStart: CGFloat = 0.0
        let circleEnd: CGFloat = CGFloat(Double.pi * 2)
        var animRate: Float = 0.0
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.duration = animDuration * 2.3
        rotateAnim.fromValue = circleStart
        rotateAnim.toValue = circleEnd
        rotateAnim.repeatCount = HUGE
        layer.add(rotateAnim, forKey: nil)
        
        for i in 0...4{
            animRate = Float(i) * 1.7 / 8
            
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: self.frame.width / 2, y: self.frame.height / 2), radius: circleRadius * 0.4 + CGFloat(i), startAngle: circleStart, endAngle: circleEnd, clockwise: true).cgPath
            
            circleShape = CAShapeLayer()
            circleShape.path = circlePath
            circleShape.fillColor = UIColor.white.cgColor
            
            let posAnim = CAKeyframeAnimation(keyPath: "position")
            posAnim.path = UIBezierPath(arcCenter: CGPoint(x: 0, y: 0), radius: circleRadius * radiusMultiplier, startAngle: circleStart - CGFloat(Double.pi), endAngle: circleEnd + circleStart - CGFloat(Double.pi), clockwise: true).cgPath
            
            
            posAnim.repeatCount = HUGE
            posAnim.duration = animDuration
            posAnim.timingFunction = CAMediaTimingFunction(controlPoints: 0.5, 0.15 + animRate, 0.05, 1.0)
            posAnim.isRemovedOnCompletion = true
            
            circleShape.add(posAnim, forKey: nil)
            layer.addSublayer(circleShape)
        }
    }
}

class GDHalfCircleRotating: UIView{
    //MARK: - default variables
    var circleRadius: CGFloat = 20.0
    var animDuration: CFTimeInterval = 3
    var animDelay: CFTimeInterval = 1.6
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    /**
     - parameters:
     - cRadius: circle radius and circles size
     - aDuration: duration of a full rotation
     - aDelay: delay between rotating the outer circles
     */
    init(frame: CGRect, cRadius: CGFloat, aDuration: CFTimeInterval, aDelay: CFTimeInterval){
        super.init(frame: frame)
        
        self.circleRadius = cRadius
        self.animDuration = aDuration
        self.animDelay = aDelay
        
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupView()
    }
    
    func setupView(){
        self.backgroundColor = UIColor.clear
    }
    
    override func draw(_ rect: CGRect) {
        self.halfCircleRotating()
    }
    
    func halfCircleRotating(){
        //Setting properties
        let circleStart: CGFloat = 0.0
        let circleEnd: CGFloat = CGFloat(Double.pi * 2)
        
        //Calculate possition for each circle in different directions
        let center = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        
        let circlePath = UIBezierPath()
        circlePath.addArc(withCenter: center, radius: circleRadius, startAngle: circleStart, endAngle: circleEnd, clockwise: true)
        let circlePath1 = UIBezierPath()
        circlePath1.addArc(withCenter: center, radius: circleRadius - 3.0, startAngle: circleStart, endAngle: circleEnd, clockwise: false)
        let circlePathCenter = UIBezierPath()
        circlePathCenter.addArc(withCenter: center, radius: circleRadius - 8.0, startAngle: circleStart, endAngle: circleEnd, clockwise: true)
        
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = nil
        circleShape.strokeColor = UIColor.white.cgColor
        circleShape.lineWidth = 2.0
        circleShape.strokeStart = 0.0
        circleShape.strokeEnd = 0.0
        
        let circleShape1 = CAShapeLayer()
        circleShape1.path = circlePath1.cgPath
        circleShape1.fillColor = nil
        circleShape1.strokeColor = UIColor.white.cgColor
        circleShape1.lineWidth = 2.0
        circleShape1.strokeStart = 0.0
        circleShape1.strokeEnd = 0.0
        
        let circleShapeCenter = CAShapeLayer()
        circleShapeCenter.path = circlePathCenter.cgPath
        circleShapeCenter.fillColor = UIColor.white.cgColor
        
        let rotateAnim = CABasicAnimation(keyPath: "transform.rotation.z")
        rotateAnim.duration = animDuration * 2.3
        rotateAnim.fromValue = circleStart
        rotateAnim.toValue = circleEnd
        rotateAnim.repeatCount = HUGE
        layer.add(rotateAnim, forKey: nil)
        
        let drawAnim = CABasicAnimation(keyPath: "strokeEnd")
        drawAnim.fromValue = 0.0
        drawAnim.toValue = 1.0
        drawAnim.duration = animDuration
        
        let eraseAnim = CABasicAnimation(keyPath: "strokeStart")
        eraseAnim.fromValue = 0.0
        eraseAnim.toValue = 1.0
        eraseAnim.beginTime = animDelay
        eraseAnim.duration = animDuration - animDelay
        
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [drawAnim, eraseAnim]
        groupAnim.repeatCount = HUGE
        groupAnim.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        groupAnim.isRemovedOnCompletion = false
        groupAnim.duration = animDuration
        
        let drawAnim1 = CABasicAnimation(keyPath: "strokeEnd")
        drawAnim1.fromValue = 0.0
        drawAnim1.toValue = 1.0
        drawAnim1.duration = animDuration
        
        let eraseAnim1 = CABasicAnimation(keyPath: "strokeStart")
        eraseAnim1.fromValue = 0.0
        eraseAnim1.toValue = 1.0
        eraseAnim1.beginTime = animDelay
        eraseAnim1.duration = animDuration - animDelay
        
        let groupAnim1 = CAAnimationGroup()
        groupAnim1.animations = [drawAnim1, eraseAnim1]
        groupAnim1.repeatCount = HUGE
        groupAnim1.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        groupAnim1.isRemovedOnCompletion = false
        groupAnim1.duration = animDuration
        
        circleShape.add(groupAnim, forKey: nil)
        layer.addSublayer(circleShape)
        circleShape1.add(groupAnim1, forKey: nil)
        layer.addSublayer(circleShape1)
        layer.addSublayer(circleShapeCenter)
    }
}






