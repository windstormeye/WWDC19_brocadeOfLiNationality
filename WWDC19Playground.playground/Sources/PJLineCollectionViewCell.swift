import UIKit

class PJLineCollectionViewCell: UICollectionViewCell {
    var viewModel: UIImage? {
        didSet { setViewModel() }
    }
    var index: Int?
    
    private func setViewModel() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.bgColor().cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 10
        layer.shadowOffset = CGSize.zero
        layer.shadowOpacity = 1
        
        if index != nil {
            let indexLabel = UILabel(frame: CGRect(x: width, y: -5, width: 22.5, height: 22.5))
            addSubview(indexLabel)
            indexLabel.text = "\(index!)"
            indexLabel.textAlignment = .center
            indexLabel.textColor = .white
            indexLabel.font = UIFont.systemFont(ofSize: 15)
            indexLabel.backgroundColor = .darkGray
            indexLabel.layer.cornerRadius = indexLabel.width / 2
            indexLabel.layer.masksToBounds = true
        }
        
        let img = UIImageView(image: viewModel)
        img.contentMode = .scaleAspectFit
        img.frame = CGRect(x: 0, y: 0, width: width, height: height)
        addSubview(img)
    }
    
    func clearSubView() {
        for view in subviews {
            view.removeFromSuperview()
        }
    }
}
