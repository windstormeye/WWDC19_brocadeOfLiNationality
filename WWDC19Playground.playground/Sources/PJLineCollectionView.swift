import UIKit

class PJLineCollectionView: UICollectionView {
    let cellIdentifier = "PJLineCollectionViewCell"
    
    var viewDelegate: PJLineCollectionViewDelegate?
    var viewModelIndexs: [Int]?
    var viewModels: [UIImage]? { didSet { reloadData() }}
    var currentCellIndex: Int?
    var longPressView: UIView?
    
    var moveCell: ((Int, CGPoint) -> Void)?
    var moveBegin: ((Int) -> Void)?
    var moveEnd: (() -> Void)?
    
    var gameType: PJHomeViewController.GameType = .guide
    
    override init(frame: CGRect,
                  collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame,
                   collectionViewLayout: layout)
        initView()
    }
    
    convenience init(frame: CGRect,
                     collectionViewLayout layout: UICollectionViewLayout,
                     longPressView: UIView?) {
        self.init(frame: frame,
                  collectionViewLayout: layout)
        self.longPressView = longPressView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        backgroundColor = .clear
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        
        delegate = self
        dataSource = self
        
        let longPress = UILongPressGestureRecognizer(target: self,
                                                     action: .longPress)
        addGestureRecognizer(longPress)
        
        register(PJLineCollectionViewCell.self,
                 forCellWithReuseIdentifier: "PJLineCollectionViewCell")
    }
    
    // MARK: Actions
    @objc
    fileprivate func cellLongPress(longPressGesture: UILongPressGestureRecognizer) {
        switch longPressGesture.state {
        case .began:
            let cellIndexPath = self.indexPathForItem(at: longPressGesture.location(in: self))
            if cellIndexPath != nil {
                currentCellIndex = cellIndexPath!.row
                moveBegin?(currentCellIndex!)
                
                if gameType == .guide {
                    viewModelIndexs!.remove(at: currentCellIndex!)
                }
            }
            
        case .changed:
            guard let currentCellIndex = currentCellIndex else { return }
            guard let longPressView = longPressView else { return }
            
            moveCell?(currentCellIndex,
                      longPressGesture.location(in: longPressView))
            
        case .ended:
            if gameType == .guide {
                viewModels!.remove(at: currentCellIndex!)
                reloadData()
            }
            moveEnd?()
            
        default: break
        }
    }
}

extension PJLineCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension PJLineCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        guard let viewModels = viewModels else { return 0 }
        
        return viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PJLineCollectionViewCell",
                                                      for: indexPath) as! PJLineCollectionViewCell
        cell.clearSubView()
        if gameType == .guide {
            cell.index = viewModelIndexs![indexPath.row]
        }
        cell.viewModel = viewModels![indexPath.row]
        return cell
    }
}


fileprivate extension Selector {
    static let longPress = #selector(PJLineCollectionView.cellLongPress(longPressGesture:))
}

protocol PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int)
}

extension PJLineCollectionViewDelegate {
    func collectionViewCellLongPress(_ cellIndex: Int) {}
}

