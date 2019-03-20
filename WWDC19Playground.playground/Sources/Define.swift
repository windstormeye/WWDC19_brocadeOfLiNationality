import UIKit

//let screenHeight = UIScreen.main.bounds.height
let screenHeight = CGFloat(667)
//let screenWidth = UIScreen.main.bounds.width
let screenWidth = CGFloat(375)

func fitWidth(_ width: CGFloat) -> CGFloat {
    return screenWidth / 375.0 * width
}

func fitHeiht(_ height: CGFloat) -> CGFloat {
    return screenHeight / 667.0 * height
}

extension UIColor {
    class func rgb(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1)
    }
    
    class func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat) -> UIColor {
        return UIColor(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
    
    class func bgColor() -> UIColor {
        return rgb(29, 36, 73)
    }
}

extension UIImage {
    /// 通过原图获取 rect 大小的图片
    func image(with rect: CGRect) -> UIImage {
        let scale = UIScreen.main.scale
        let x = rect.origin.x * scale
        let y = rect.origin.y * scale
        let w = rect.size.width * scale
        let h = rect.size.height * scale
        let finalRect = CGRect(x: x, y: y, width: w, height: h)
        
        let originImageRef = self.cgImage
        let finanImageRef = originImageRef!.cropping(to: finalRect)
        let finanImage = UIImage(cgImage: finanImageRef!, scale: scale, orientation: .up)
        
        return finanImage
    }
}

extension UIView {
    
    static private let PJSCREEN_SCALE = UIScreen.main.scale
    
    private func getPixintegral(pointValue: CGFloat) -> CGFloat {
        return round(pointValue * UIView.PJSCREEN_SCALE) / UIView.PJSCREEN_SCALE
    }
    
    public var x: CGFloat {
        get {
            return self.frame.origin.x
        }
        set(x) {
            self.frame = CGRect.init(
                x: getPixintegral(pointValue: x),
                y: self.y,
                width: self.width,
                height: self.height
            )
        }
    }
    
    public var y: CGFloat {
        get {
            return self.frame.origin.y
        }
        set(y) {
            self.frame = CGRect.init(
                x: self.x,
                y: getPixintegral(pointValue: y),
                width: self.width,
                height: self.height
            )
        }
    }
    
    public var width: CGFloat {
        get {
            return self.frame.size.width
        }
        set(width) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: getPixintegral(pointValue: width),
                height: self.height
            )
        }
    }
    
    public var height: CGFloat {
        get {
            return self.frame.size.height
        }
        set (height) {
            self.frame = CGRect.init(
                x: self.x,
                y: self.y,
                width: self.width,
                height: getPixintegral(pointValue: height)
            )
        }
    }
    
    public var bottom: CGFloat {
        get {
            return self.y + self.height
        }
        set(bottom) {
            self.y = bottom - self.height
        }
    }
    
    public var right: CGFloat {
        get {
            return self.x + self.width
        }
        set (right) {
            self.x = right - self.width
        }
    }
    
    public var left: CGFloat {
        get {
            return self.x
        }
        set(left) {
            self.x = left
        }
    }
    
    public var top: CGFloat {
        get {
            return self.y
        }
        set(top) {
            self.y = top
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        }
        set(centerX) {
            self.center = CGPoint.init(
                x: getPixintegral(pointValue: centerX),
                y: self.center.y
            )
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        }
        set (centerY) {
            self.center = CGPoint.init(x: self.center.x, y: getPixintegral(pointValue: centerY))
        }
    }
    
}


public func PJInsertRoundingCorners(_ view: UIView) {
    let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8.0, height: 8.0))
    let pathMaskLayer = CAShapeLayer()
    pathMaskLayer.frame = view.bounds
    pathMaskLayer.path = path.cgPath
    view.layer.mask = pathMaskLayer
}
