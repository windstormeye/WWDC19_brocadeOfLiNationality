import UIKit


public class PJShowBottonView: UIView {
    
    var viewModel: [UIImage]? {
        didSet { collectionView?.viewModels = viewModel }
    }
    var moveCell: ((Int, CGPoint) -> Void)?
    var moveBegin: ((Int) -> Void)?
    var moveEnd: (() -> Void)?
    var collectionView: PJLineCollectionView?
    var longPressView: UIView?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(height: CGFloat, longPressView: UIView?) {
        self.init(frame: CGRect(x: 0, y: screenHeight - height,
                                width: screenWidth, height: height))
        self.longPressView = self
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .clear
        
        let effect = UIBlurEffect(style: .extraLight)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(effectView)
        
        PJInsertRoundingCorners(self)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        let itemW = 50
        let innerW = (screenWidth - 5 * 50) / 5
        collectionViewLayout.itemSize = CGSize(width: itemW , height: itemW)
        collectionViewLayout.minimumLineSpacing = innerW
        collectionViewLayout.minimumInteritemSpacing = 10
        collectionViewLayout.scrollDirection = .horizontal
        collectionViewLayout.sectionInset = UIEdgeInsets.init(top: 0, left: innerW / 2,
                                                              bottom: 0, right: innerW / 2)
        
        collectionView = PJLineCollectionView(frame: CGRect(x: 0, y: 0, width: width,
                                                            height: height),
                                              collectionViewLayout: collectionViewLayout,
                                              longPressView: longPressView)
        collectionView!.viewDelegate = self
        addSubview(collectionView!)
        
        collectionView!.moveCell = { [weak self] cellIndex, centerPoint in
            guard let self = `self` else { return }
            self.moveCell?(cellIndex, centerPoint)
        }
        
        collectionView?.moveBegin = { [weak self] cellIndex in
            guard let self = `self` else { return }
            self.moveBegin?(cellIndex)
        }
        
        collectionView?.moveEnd = { [weak self] in
            guard let self = `self` else { return }
            self.moveEnd?()
            self.viewModel = self.collectionView?.viewModels
        }
    }
}


extension PJShowBottonView: PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {
        
    }
}
