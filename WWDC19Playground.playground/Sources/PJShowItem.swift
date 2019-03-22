import UIKit


public class PJShowItem: UIView {
    /// return new item.center
    var panGestureX: ((CGPoint) -> Void)?
    var panGestureEnd: (() -> Void)?
    var tapGestrueEnd: (() -> Void)?
    
    var endTop: CGFloat?
    var endBottom: CGFloat?
    var endLeft: CGFloat?
    var endRight: CGFloat?
    
    /// 移动开始时的位置
    var oldCenter: CGPoint?
    /// 底图
    var bgImage: UIImage? { didSet { didSetBgImgae() } }
    /// 当前在 x 轴上的位置
    var currentXIndex: Int?
    /// 当前在 y 轴上的位置
    var currentYIndex: Int?
    /// 之前在 x 轴上的位置
    var previousXIndex: Int?
    /// 之前在 y 轴上的位置
    var previousYIndex: Int?
    /// 是否需要移动
    var isMove: Bool = false {
        didSet {
            if isCopy {
                left -= width / 3 - 2.5
                return
            }
            right += width / 3 - 2.5
        }
    }
    
    var isBottomItem = false
    var isHelpItem = false
    private var isCopy: Bool = false
    private var previousRotation: CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    convenience init(frame: CGRect, isCopy: Bool) {
        self.init(frame: frame)
        self.isCopy = isCopy
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        let panGesture = UIPanGestureRecognizer(target: self, action: .pan)
        addGestureRecognizer(panGesture)
        
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: .doubleTap)
        doubleTapGesture.numberOfTapsRequired = 2
        addGestureRecognizer(doubleTapGesture)
    }
    
    private func didSetBgImgae() {
        let imageView = UIImageView(image: bgImage!)
        imageView.contentMode = .left
        imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        if isCopy {
            imageView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        addSubview(imageView)
    }
    
    @objc
    fileprivate func panGestrue(panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            layer.borderColor = UIColor.white.cgColor
            layer.borderWidth = 1.5
            
            oldCenter = self.center
        case .changed:
            let translation = panGesture.translation(in: superview)
            
            let final_centerX = center.x + translation.x
            let final_centerY = center.y + translation.y
            
            let final_right = final_centerX + width / 2
            let final_left = final_centerX - width / 2
            let final_top = final_centerY - height / 2
            let final_bottom = final_centerY + height / 2
            
            if endLeft != nil {
                if final_left < endLeft! {
                    left = endLeft!
                }
            }
            
            if endRight != nil {
                if final_right > endRight! {
                    right = endRight!
                }
            }
            
            if endTop != nil {
                if final_top < endTop! {
                    top = endTop!
                }
            }
            
            if endBottom != nil {
                if final_bottom > endBottom! {
                    bottom = endBottom!
                }
            }
            
            
            center = CGPoint(x: center.x + translation.x, y: center.y + translation.y)
            panGesture.setTranslation(.zero, in: superview)
            
            panGestureX?(center)
        case .ended:
            layer.borderWidth = 0
            panGestureEnd?()
        default: break
        }
    }
    
    @objc
    fileprivate func doubleTapGesture(tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            let ratation = CGFloat(Double.pi / 2.0)
            transform = CGAffineTransform(rotationAngle: previousRotation + ratation)
            previousRotation += ratation
            tapGestrueEnd?()
        }
    }
}


fileprivate extension Selector {
    static let pan = #selector(PJShowItem.panGestrue(panGesture:))
    static let doubleTap = #selector(PJShowItem.doubleTapGesture(tap:))
}
