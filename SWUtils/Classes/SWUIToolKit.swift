//
//  SWUIToolKit.swift
//  ReservationClient
//
//  Created by Stan Wu on 15/3/28.
//  Copyright (c) 2015 Stan Wu. All rights reserved.
//

import Foundation
import UIKit
import CoreImage
import CoreGraphics

@objc enum NaviButtonPosition:Int{
    case Left,Right
}

enum ConstraintFillMode: Int{
    case Both,Width,Height
}

class SWLineSpacingLabel: UILabel{
    var lineSpacing:CGFloat = 0
    
    override var text: String?{
        didSet{
            self.attributedText = nil
            
            if let str = text{
                if 0 == lineSpacing{
                    return
                }else{
//                    newValue = nil
                    super.text = nil
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = lineSpacing;
                    paragraphStyle.alignment = .Left;
                    let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
                    let attributedText = NSAttributedString(string: str, attributes: attributes)
                    self.attributedText = attributedText;
                }
            }
        }



    }
}

extension UIAlertView{
    class func show(title:String?,message:String?,cancelButton:String?){
        var cancel = cancelButton;
        if  cancel==nil {
            cancel = "确定"
        }
        UIAlertView.show(title, message: message, cancelButton: cancel, delegate: nil)
    }
    
    class func show(title:String?,message:String?,cancelButton:String?,delegate:UIAlertViewDelegate?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title:cancelButton ?? "确定", style: UIAlertActionStyle.Cancel, handler: nil))

        
//        alert.show()
        
    }
}

extension UIBarButtonItem{
    class func navBackItem(target: UIViewController) -> [UIBarButtonItem]{
        return UIBarButtonItem.navButtonItem(nil, image: UIImage(named: "MNavBack"), action: "navBack", target: target)
    }
    
    @objc class func navButtonItem(title: String?,action: Selector,target: AnyObject?) -> UIBarButtonItem{
        let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: target, action: action)
        item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(17),NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        return item
    }
    
    @objc class func navButtonItem(title: String?,color: UIColor?,action: Selector,target: AnyObject?) -> UIBarButtonItem{
        let btn = UIButton.customButton()
        btn.frame = CGRectMake(0, 0, 56, 22)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 2
        btn.titleLabel?.font = UIFont.systemFontOfSize(11)
        
        let bgColor = color ?? UIColor(red: 0.32, green: 0.31, blue: 0.39, alpha: 1)
        
        btn.setBackgroundImage(UIImage.colorImage(bgColor, size: CGSizeMake(1, 1)), forState: .Normal)
        
        btn.setTitle(title, forState: .Normal)
        
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        
        return UIBarButtonItem(customView: btn)
    }
    
    class func navButtonItem(title: String?,image: UIImage?,action: Selector,target: AnyObject?) -> [UIBarButtonItem]{
        return UIBarButtonItem.navButtonItem(title, image: image, action: action, position: NaviButtonPosition.Left,target: target)
    }
    
    class func navButtonItem(title: String?,image: UIImage?,action: Selector,position: NaviButtonPosition,target: AnyObject?) -> [UIBarButtonItem]{
        let btn = UIButton(type: .Custom)
        btn.frame = CGRectMake(0, 0, 80, 44)
        btn.setTitle(title, forState: .Normal)
        btn.setImage(image, forState: .Normal)
        let font = image==nil ? UIFont.systemFontOfSize(14) : UIFont.systemFontOfSize(12)
        btn.titleLabel?.font = font
        
        let size = (title ?? "").sizeWithAttributes([NSFontAttributeName:font])
        
        if image != nil && title != nil{
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -image!.size.width-8, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, image!.size.width*2+size.width, 0, 0);
        }else if image != nil{
            btn.imageEdgeInsets = position == .Left ? UIEdgeInsetsMake(0, -image!.size.width, 0, 0) : UIEdgeInsetsMake(0, 0, 0, -image!.size.width);
        }
        
        
        btn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        let item = UIBarButtonItem(customView: btn)
        let fixspace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixspace.width = -20
        
        return [fixspace,item]
    }
}

extension UIViewController{
    
    
    @objc func addNavButton(title: String,action: Selector,target: AnyObject?,position:NaviButtonPosition){
        let item = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Plain, target: target, action: action)
        item.setTitleTextAttributes([NSFontAttributeName:UIFont.systemFontOfSize(17),NSForegroundColorAttributeName:UIColor.whiteColor()], forState: .Normal)
        switch position{
        case .Left:
            self.navigationItem.leftBarButtonItem = item
        case .Right:
            self.navigationItem.rightBarButtonItem = item
        }
    }
    
    @objc func addNavButton(title: String,color: UIColor?,action: Selector,position:NaviButtonPosition){
        let btn = UIButton.customButton()
        btn.frame = CGRectMake(0, 0, 56, 22)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 2
        btn.titleLabel?.font = UIFont.systemFontOfSize(11)
        
        let bgColor = color ?? UIColor(red: 0.32, green: 0.31, blue: 0.39, alpha: 1)
        
        btn.setBackgroundImage(UIImage.colorImage(bgColor, size: CGSizeMake(1, 1)), forState: .Normal)
        
        btn.setTitle(title, forState: .Normal)
        
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        
        
        let item = UIBarButtonItem(customView: btn)
        
        if .Left==position{
            self.navigationItem.leftBarButtonItem = item
        }else{
            self.navigationItem.rightBarButtonItem = item
        }
    }
    
    @objc func addNavButton(title: String?,image: UIImage?,position: NaviButtonPosition,action: Selector){
        let btn = UIButton(type: .Custom)
        btn.frame = CGRectMake(0, 0, 80, 44)
        btn.setTitle(title, forState: .Normal)
        btn.setImage(image, forState: .Normal)
        let font = image==nil ? UIFont.systemFontOfSize(14) : UIFont.systemFontOfSize(12)
        btn.titleLabel?.font = font
        
        let size = (title ?? "").sizeWithAttributes([NSFontAttributeName:font])
        
        if image != nil && title != nil{
            btn.titleEdgeInsets = UIEdgeInsetsMake(0, -image!.size.width-8, 0, 0);
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, image!.size.width*2+size.width, 0, 0);
        }else if image != nil{
            btn.imageEdgeInsets = position == .Left ? UIEdgeInsetsMake(0, -image!.size.width, 0, 0) : UIEdgeInsetsMake(0, 0, 0, -image!.size.width);
        }
        
        
        btn.addTarget(self, action: action, forControlEvents: .TouchUpInside)
        
        let item = UIBarButtonItem(customView: btn)
        let fixspace = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
        fixspace.width = -20
        
        if .Left==position{
            self.navigationItem.leftBarButtonItems = [item]
        }else{
            self.navigationItem.rightBarButtonItems = [fixspace,item]
        }
    }
    
    @objc func addBGColor(){
        self.view.backgroundColor = UIColor(white: 0.94, alpha: 1)
    }
    
    @objc func addBGColor(color: UIColor?){
        if let c = color{
            self.view.backgroundColor = c
        }else{
            self.addBGColor()
        }
    }
    
    @objc func setNavTitle(title:String?){
        self.setNavTitle(title, image: nil)
    }
    
    @objc func setNavTitle(title:String?,gender: Int){
        let img = 2==gender ? UIImage(named: "MSmallFemaleIcon") : (1==gender ? UIImage(named: "MSmallMaleIcon") : nil)
        
        self.setNavTitle(title, image: img)
    }
    
    @objc func setNavTitle(title: String?,image: UIImage?){
        var lbl = self.navigationItem.titleView as? UILabel
        
        if nil == lbl{
            lbl = UILabel.create(CGRectZero, font: UIFont.systemFontOfSize(14), textColor: UIColor.whiteColor())
            self.navigationItem.titleView = lbl
        }
        
        if let img = image{
            
            
            
            let str = NSMutableAttributedString()
            str.appendAttributedString(NSAttributedString(string: title ?? ""))
            
            str.appendAttributedString(NSAttributedString(string: " "))
            
            let attachment = NSTextAttachment()
            attachment.image = img
            str.appendAttributedString(NSAttributedString(attachment: attachment))
            
            lbl?.attributedText = str
            lbl?.sizeToFit()
            

            
            
            
            
        }else{
            lbl?.attributedText = nil
            lbl?.text = title
            lbl?.sizeToFit()
        }
    }
    
    @objc func addNavBack(){
        self.addNavButton(nil, image: UIImage(named: "MNavBack"), position: .Left, action: "navBack")
    }
    
    @objc func navBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @objc func footerViewForLoadMore() -> UIView{
        let v = UIView(frame: CGRectMake(0, 0, SWDefinitions.ScreenWidth, 50))
        v.backgroundColor = UIColor.clearColor()
        
        let btn = UIButton.customButton()
        btn.backgroundColor = UIColor.clearColor()
        btn.setTitleColor(UIColor(white: 0.62, alpha: 1), forState: .Normal)
        btn.frame = v.bounds
        btn.titleLabel?.font = UIFont.systemFontOfSize(15)
        btn.setTitle("点击加载更多", forState: .Normal)
        v.addSubview(btn)
        btn.addTarget(self, action: "moreClicked:", forControlEvents: .TouchUpInside)
        btn.tag = 100
        
        let lbl = UILabel.create(v.bounds, font: UIFont.systemFontOfSize(15), textColor: btn.titleColorForState(.Normal)!)
        lbl.textAlignment = .Center
        v.insertSubview(lbl, belowSubview: btn)
        lbl.text = "正在载入"
        lbl.tag = 102
        lbl.hidden = true
        
        let size = lbl.text!.sizeWithAttributes([NSFontAttributeName:lbl.font])
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.center = CGPointMake(SWDefinitions.ScreenWidth/2+size.width/2+10.0, lbl.center.y)
        v.insertSubview(indicator, belowSubview: btn)
        indicator.tag = 101

        return v
    }
    
    @objc func moreClicked(btn:UIButton){
        btn.hidden = true
        
        let lbl = btn.superview?.viewWithTag(102) as? UILabel
        lbl?.hidden = false
        
        let indicator = btn.superview?.viewWithTag(101) as? UIActivityIndicatorView
        indicator?.startAnimating()
        
        NSThread.detachNewThreadSelector("loadMoreData", toTarget: self, withObject: nil)
    }
}

extension UILabel{
    class func create(frame:CGRect,font:UIFont,textColor:UIColor) -> UILabel{
        let lbl = self.init(frame: frame)
        lbl.font = font
        lbl.textColor = textColor
        lbl.backgroundColor = UIColor.clearColor()
        lbl.userInteractionEnabled = false
        
        return lbl
    }
}

extension UIImage{
    class func colorImage(color:UIColor,size:CGSize) -> UIImage{
        var cicolor = CIColor(CGColor: color.CGColor)

        cicolor = CIColor(red: cicolor.red, green: cicolor.green, blue: cicolor.blue, alpha: cicolor.alpha)
        

        typealias MYImage = CoreImage.CIImage
        let ciimg:MYImage = MYImage(color:cicolor)
        
        let ctx = CIContext(options: nil)
        let imgref = ctx.createCGImage(ciimg, fromRect: CGRectMake(0, 0, size.width, size.height))
        let img = UIImage(CGImage: imgref)

    
        return img;
    }
    
    func resizedImage(size: CGSize) -> UIImage{
        let img = self.fixOrientation()
        
        var newSize = size
        
        if (img.size.width-img.size.height)*(newSize.width-newSize.height)<0{
            newSize = CGSizeMake(newSize.height, newSize.width)
        }
        
        
        let mysize = img.size
        
        var w = newSize.width
        var h = newSize.height
        let W = mysize.width
        let H = mysize.height
        
        let fw = w/W
        let fh = h/H
        
        if (w>=W && h>=H){
            return self;
        }else{
            if (fw>fh){
                w = h/H*W;
            }else{
                h = w/W*H;
            }
        }
        
        w = CGFloat(Int(w))
        h = CGFloat(Int(h))
        
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h),true,0.0);
        let ctx = UIGraphicsGetCurrentContext();
        CGContextTranslateCTM(ctx, 0, h);
        CGContextScaleCTM(ctx, 1.0, -1.0);
        CGContextDrawImage(ctx, CGRectMake(0, 0, w, h), img.CGImage);
        let imgC = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        return imgC;
    }
    
    func coloredImage(color: UIColor) -> UIImage{
        
        // lets tint the icon - assumes your icons are black
        UIGraphicsBeginImageContext(self.size);
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        
        CGContextTranslateCTM(context, 0, self.size.height);
        CGContextScaleCTM(context, 1.0, -1.0);
        
        let rect = CGRectMake(0, 0, self.size.width, self.size.height);
        
        // draw alpha-mask
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        CGContextDrawImage(context, rect, self.CGImage);
        
        // draw tint color, preserving alpha values of original image
        CGContextSetBlendMode(context, .SourceIn);
        color.setFill()
        CGContextFillRect(context, rect);
        
        let coloredImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return coloredImage;
    }
    
    func fixOrientation() -> UIImage{
        if self.imageOrientation == UIImageOrientation.Up{
            return self
        }
        
        
        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransformIdentity
        
        switch (self.imageOrientation) {
        case UIImageOrientation.Down,UIImageOrientation.DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI))
            break;
            
        case UIImageOrientation.Left,UIImageOrientation.LeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, CGFloat(M_PI_2));
            break;
            
        case UIImageOrientation.Right,UIImageOrientation.RightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, CGFloat(-M_PI_2));
            break;
        default:
            break;
        }
        
        switch (self.imageOrientation) {
        case UIImageOrientation.UpMirrored,UIImageOrientation.DownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientation.LeftMirrored,UIImageOrientation.RightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
        }
        
        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        
        let ctx = CGBitmapContextCreate(nil, Int(self.size.width), Int(self.size.height),
            CGImageGetBitsPerComponent(self.CGImage), 0,
            CGImageGetColorSpace(self.CGImage),
            CGImageGetBitmapInfo(self.CGImage).rawValue);
        CGContextConcatCTM(ctx, transform);

        switch (self.imageOrientation) {
        case .Left,.LeftMirrored,.Right,.RightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
        }
        
        // And now we just create a new UIImage from the drawing context
        let cgimg = CGBitmapContextCreateImage(ctx);
        let img = UIImage(CGImage: cgimg!)
        
        return img;
    }
}

@objc protocol SWImageViewDelegate{
    func swImageViewLoadFinished(imgv:SWImageView)
}

class SWImageView: UIImageView{
    weak var delegate:SWImageViewDelegate?
    lazy var indicator:UIActivityIndicatorView = {
       var indi = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indi.hidesWhenStopped = true
        indi.adoptAutoLayout()
        self.addSubview(indi)
        
        self.addConstraint(NSLayoutConstraint.equalConstraint(indi, attribute1: .CenterX, view2: self, attribute2: .CenterX))
        self.addConstraint(NSLayoutConstraint.equalConstraint(indi, attribute1: .CenterY, view2: self, attribute2: .CenterY))
        
        
        
        return indi
    }()
    
    func loadURL(str: String?){
        if let url = str{
            var ary = url.componentsSeparatedByString("/")
            let fileName = NSMutableString()
            
        

            for i in 0 ..< ary.count{
                fileName.appendString(ary[i])
            }
            
            let path = (fileName as String).imageCachePath()

            if NSFileManager.defaultManager().fileExistsAtPath(path){
                indicator.stopAnimating()
                self.image = UIImage(contentsOfFile: path)
                
                self.delegate?.swImageViewLoadFinished(self)
            }else{
                indicator.startAnimating()
                indicator.hidden = false
                
                self.image = nil
                NSThread.detachNewThreadSelector("loadImage:", toTarget: self, withObject: str)
            }
        }
    }
    
    func loadImage(str: String){
        autoreleasepool { () -> () in
            let url = NSURL(string: str)
            let data = NSData(contentsOfURL: url!)
            
            if let d = data{
                let img = UIImage(data: d)
                
                
                if let image = img{
                    sw_dispatch_on_main_thread({ () -> Void in
                        self.image = image
                        
                        var ary = str.componentsSeparatedByString("/")
                        let fileName = NSMutableString()
                        
                        
                        
                        for i in 0 ..< ary.count{
                            fileName.appendString(ary[i])
                        }
                        
                        let path = (fileName as String).imageCachePath()
                        
                        data?.writeToFile(path, atomically: false)
                        
                        self.delegate?.swImageViewLoadFinished(self)
                        
                        self.indicator.stopAnimating()
                    })
                }else{
                    self.indicator.stopAnimating()
                }
            }
            
        }
    }
    
    func loadURL(str: String?,defaultImg img:UIImage?){
        self.image = img
        if let url = str{
            self.loadImage(url)
        }
    }
}

class SWButton: UIButton{
//    weak var delegate:SWImageViewDelegate?
    lazy var indicator:UIActivityIndicatorView = {
        var indi = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
        indi.hidesWhenStopped = true
        indi.adoptAutoLayout()
        self.addSubview(indi)
        
        self.addConstraint(NSLayoutConstraint.equalConstraint(indi, attribute1: .CenterX, view2: self, attribute2: .CenterX))
        self.addConstraint(NSLayoutConstraint.equalConstraint(indi, attribute1: .CenterY, view2: self, attribute2: .CenterY))
        
        
        
        return indi
    }()
    
    func loadURL(str: String?){
        if let url = str{
            var ary = url.componentsSeparatedByString("/")
            let fileName = NSMutableString()
            
            
            
            for i in 0 ..< ary.count{
                fileName.appendString(ary[i])
            }
            
            let path = (fileName as String).imageCachePath()
            
            if NSFileManager.defaultManager().fileExistsAtPath(path){
                self.setImage(UIImage(contentsOfFile: path), forState: .Normal)
                
//                self.delegate?.swImageViewLoadFinished(self)
            }else{
                self.setImage(nil, forState: .Normal)
                
                indicator.startAnimating()
                indicator.hidden = false

                NSThread.detachNewThreadSelector("loadImage:", toTarget: self, withObject: str)
            }
        }
    }
    
    func loadImage(str: String){
        autoreleasepool { () -> () in
            let url = NSURL(string: str)
            let data = NSData(contentsOfURL: url!)
            
            if let d = data{
                let img = UIImage(data: d)
                
                
                if let image = img{
                    sw_dispatch_on_main_thread({ () -> Void in
                        self.setImage(image, forState: .Normal)
                        
                        var ary = str.componentsSeparatedByString("/")
                        let fileName = NSMutableString()
                        
                        
                        
                        for i in 0 ..< ary.count{
                            fileName.appendString(ary[i])
                        }
                        
                        let path = (fileName as String).imageCachePath()
                        
                        data?.writeToFile(path, atomically: false)
                        
//                        self.delegate?.swImageViewLoadFinished(self)
                    })
                }else{
                    self.indicator.stopAnimating()
                }
            }
            
        }
    }
    
    override func setImage(image: UIImage?, forState state: UIControlState) {
        super.setImage(image, forState: state)
        
        self.indicator.stopAnimating()
    }
}

extension UIView{
    func adoptAutoLayout(){
        if self.respondsToSelector("setTranslatesAutoresizingMaskIntoConstraints:"){
            self.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    func filled(v: UIView,mode: ConstraintFillMode){
        switch mode{
        case .Both:
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", views: ["v":v]))
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", views: ["v":v]))
        case .Width:
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v]|", views: ["v":v]))
        case .Height:
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v]|", views: ["v":v]))
        }
    }
    
    func addConstraints(format: String,views: [String:AnyObject]){
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, views: views))
    }
}

extension UIButton{
    class func customButton() -> UIButton{
        return self.init(type: .Custom)
    }
}

extension NSLayoutConstraint{
    class func constraintsWithVisualFormat(format: String, views: [String : AnyObject]) -> [NSLayoutConstraint]{
        return NSLayoutConstraint.constraintsWithVisualFormat(format, options: [], metrics: nil, views: views)
    }
    
    class func squareConstraint(view: UIView) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1.0, constant: 0)
    }
    
    class func heightConstraint(view: UIView,height: CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: height)
    }
    
    class func widthConstraint(view: UIView,width: CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: width)
    }
    
    class func sizeConstraints(view: UIView,width: CGFloat, height: CGFloat) -> [NSLayoutConstraint]{
        return [NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: width),NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 0, constant: height)]
    }
    
    class func equalConstraint(view1: UIView,attribute1: NSLayoutAttribute,view2: UIView?,attribute2: NSLayoutAttribute) -> NSLayoutConstraint{
        return NSLayoutConstraint.equalConstraint(view1, attribute1: attribute1, view2: view2, attribute2: attribute2, constant: 0)
    }
    
    class func equalConstraint(view1: UIView,attribute1: NSLayoutAttribute,view2: UIView?,attribute2: NSLayoutAttribute,constant: CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint.equalConstraint(view1,attribute1: attribute1,view2: view2,attribute2: attribute2,multiplier: 1.0,constant: constant)
    }
    
    class func equalConstraint(view1: UIView,attribute1: NSLayoutAttribute,view2: UIView?,attribute2: NSLayoutAttribute,multiplier: CGFloat,constant: CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view1, attribute: attribute1, relatedBy: .Equal, toItem: view2, attribute: attribute2, multiplier: multiplier, constant: constant)
    }
    
    class func ratioConstraint(view: UIView,ratio: CGFloat) -> NSLayoutConstraint{
        return NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: ratio, constant: 0)
    }
    
}
    //  MARK: - Classes
class SWTextView: UITextView{
    private var shouldDrawPlackholder = false
    var _placeholderColor = UIColor(white: 0.7, alpha: 1)
    
    var placeholderColor: UIColor?{
        get{
            return _placeholderColor
        }
        
        set{
            if newValue == nil{
                _placeholderColor = UIColor.clearColor()
            }else{
                _placeholderColor = newValue!
            }
        }
    }
    
    var placeholder: String?{
        didSet{
            _updateShouldDrawPlaceholder()
        }
    }
    
    override var text: String?{
        didSet{
            _updateShouldDrawPlaceholder()
        }
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        _initialize()
    }
    
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        if shouldDrawPlackholder{
            placeholderColor?.set()
            placeholder?.drawInRect(CGRectInset(self.bounds, 4, 4), withAttributes: (self.font == nil ? nil : [NSFontAttributeName:self.font!,NSForegroundColorAttributeName:placeholderColor!]))
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  MARK: - Private Functions
    private func _initialize(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "_textChanged:", name: UITextViewTextDidChangeNotification, object: self)
        
        
        shouldDrawPlackholder = false
    }
    
    private func _updateShouldDrawPlaceholder(){
        let prev = shouldDrawPlackholder
        shouldDrawPlackholder = self.placeholderColor != nil && self.placeholderColor != nil && (self.text?.length ?? 0) == 0
        if prev != shouldDrawPlackholder{
            self.setNeedsDisplay()
        }
    }
    
    func _textChanged(notice: NSNotification){
        self._updateShouldDrawPlaceholder()
    }
}
