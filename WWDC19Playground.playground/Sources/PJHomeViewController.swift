import UIKit
import AVFoundation

public class PJHomeViewController: UIViewController, PJParticleAnimationable {
    
    var gameType: GameType = .guide
    var brocadeType: BrocadeType = .normal
    var brocadeBackgroundColor: UIColor = UIColor.bgColor()
    var audioPlayer:AVAudioPlayer = AVAudioPlayer()
    
    private var bottomView: PJShowBottonView?
    private var contentView: PJShowContentView?
    private var itemTag = 101
    
    public override func loadView() {
        view = UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 667))
        view.backgroundColor = brocadeBackgroundColor
        self.winLabel.isHidden = true
        
        //        startMusic()
                
        let contentView = PJShowContentView()
        contentView.gameType = gameType
        self.contentView = contentView
        view.addSubview(contentView)
        contentView.winComplate = {
            self.win()
        }
        
        switch brocadeType {
        case .normal: contentView.itemXCount = 3
        case .small: contentView.itemXCount = 2
        case .big: contentView.itemXCount = 4
        }
        contentView.frame = CGRect(x: 0, y: 0,
                                   width: view.width,
                                   height: view.height - 64)
        
        PJShowItemCreator.shared.brocadeType = brocadeType
        
        var imgs = [UIImage]()
        var imgIndexs = [Int]()
        
        if gameType == .guide {
            for itemY in 0..<contentView.itemYCont! {
                for itemX in 0..<contentView.itemXCount! {
                    let x = (contentView.itemW ?? 0) * CGFloat(itemX)
                    let y = (contentView.itemW ?? 0) * CGFloat(itemY)
                    var itemW = contentView.itemW
                    var itemH = itemW
                    
                    if itemY == contentView.itemYCont! - 1 {
                        itemW = contentView.itemW
                        itemH = CGFloat(20)
                    }
                    
                    if itemX == contentView.itemXCount! - 1 {
                        itemW = contentView.itemW! / 3 * 2 + 2
                    }
                    
                    let img = contentView.bgImageView?.image?.image(with: CGRect(x: x, y: y, width: itemW!, height: itemH!))
                    imgs.append(img!)
                    imgIndexs.append(itemY * contentView.itemXCount! + itemX)
                }
            }
            
            for i in 1..<imgs.count {
                let index = Int(arc4random()) % i
                if index != i {
                    imgs.swapAt(i, index)
                    imgIndexs.swapAt(i, index)
                }
            }
        } else {
            for index in 1...18 {
                let img = UIImage(named: "created_\(index)")
                imgs.append(img!)
                imgIndexs.append(index)
            }
        }
        
        
        contentView.undoAddItem = { itemTag in
            var itemIndex = 0
            for (index, item) in imgIndexs.enumerated() {
                if item == itemTag - 1 {
                    itemIndex = index
                    break
                }
            }
            
            if self.gameType == .guide {
                self.bottomView?.collectionView?.viewModelIndexs?.append(imgIndexs[itemIndex])
                self.bottomView?.viewModel?.append(imgs[itemIndex])
            }
        }
        
        
        let bottomView = PJShowBottonView(height: 64, longPressView: view)
        view.addSubview(bottomView)
        self.bottomView = bottomView
        bottomView.collectionView?.gameType = gameType
        bottomView.isHidden = true
        bottomView.layer.opacity = 0
        
        UIView.animate(withDuration: 2) {
            bottomView.isHidden = false
            bottomView.layer.opacity = 1
        }
        
        bottomView.collectionView?.viewModelIndexs = imgIndexs
        bottomView.viewModel = imgs
        bottomView.moveCell = { cellIndex, centerPoint in
            guard let tempItem = contentView.tempItem else { return }
            tempItem.center = CGPoint(x: centerPoint.x,
                                      y: centerPoint.y + bottomView.top)
        }
        bottomView.moveBegin = { cellIndex in
            guard contentView.itemXCount != nil else { return }
            
            let itemW = contentView.itemW
            // 刚开始的初始化先让其消失
            let moveItem = PJShowItem(frame: CGRect(x: -1000, y: -1000,
                                                    width: itemW!, height: itemW!))
            moveItem.gameType = self.gameType
            moveItem.endTop = contentView.endTop
            moveItem.endBottom = contentView.endBottom
            if self.gameType == .guide {
                moveItem.endBottom = screenHeight - 40
            }
            moveItem.endLeft = contentView.endLeft
            moveItem.endRight = contentView.endRight
            moveItem.bgImage = bottomView.viewModel![cellIndex]
            moveItem.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            moveItem.tag = bottomView.collectionView!.viewModelIndexs![cellIndex] + 1
            
            
            if [28, 29, 30].contains(moveItem.tag) {
                moveItem.isBottomItem = true
            }
            
            contentView.addSubview(moveItem)
            contentView.tempItem = moveItem
        }
        
        bottomView.moveEnd = {
            guard let tempItem = contentView.tempItem else { return }
            tempItem.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    private func win() {
        startParticleAnimation(CGPoint(x: screenWidth / 2, y: screenHeight - 10))
        self.winLabel.isHidden = false
        
        UIView.animate(withDuration: 0.25, animations: {
            self.bottomView!.top = screenHeight
        })
        
        contentView!.isHidden = true
        
        let finalManContentView = UIImageView(frame: CGRect(x: 0, y: 0,
                                                            width: screenWidth,
                                                            height: screenHeight - 64))
        finalManContentView.image = UIImage(named: "finalManContent")
        self.view.addSubview(finalManContentView)
        
        let finalMan = UIImageView(frame: CGRect(x: 0, y: 0,
                                                 width: finalManContentView.width * 0.85,
                                                 height: finalManContentView.width * 0.8 * 0.85))
        finalMan.center = self.view.center
        finalMan.image = UIImage(named: "finalMan")
        self.view.addSubview(finalMan)
        
        
        UIView.animate(withDuration: 0.5, animations: {
            finalMan.transform = CGAffineTransform(rotationAngle: 0.25)
        }) { (finished) in
            UIView.animate(withDuration: 0.5, animations: {
                finalMan.transform = CGAffineTransform(rotationAngle: -0.25)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.5, animations: {
                    finalMan.transform = CGAffineTransform(rotationAngle: 0)
                })
            })
        }
    }
    
    private func startMusic() {
        let session = AVAudioSession.sharedInstance()
        do{
            try session.setActive(true)
            let path = Bundle.main.path(forResource: "LiSong", ofType: "mp3")
            let soudUrl = URL(fileURLWithPath: path!)
            try audioPlayer = AVAudioPlayer(contentsOf: soudUrl)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1.0
            audioPlayer.numberOfLoops = -1
            audioPlayer.play()
        } catch{
            print(error)
        }
    }
    
    lazy var winLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: screenHeight - 64,
                                          width: screenWidth, height: 64))
        label.centerX = view.centerX
        label.font = UIFont.systemFont(ofSize: 40,
                                       weight: UIFont.Weight.light)
        label.text = "Dàlì shén"
        label.textAlignment = .center
        label.textColor = .white
        view.addSubview(label)
        return label
    }()
    
}

extension PJHomeViewController {
    public enum GameType {
        case create
        case guide
    }
    
    public enum BrocadeType {
        case small
        case normal
        case big
    }
    
    public enum SizeType {
        case rectangle
        case square
        case circular
    }
}
