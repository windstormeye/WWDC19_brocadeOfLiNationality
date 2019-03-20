import UIKit

class PJLineCollectionViewCell: UICollectionViewCell {
    var viewModel: UIImage? {
        didSet { setViewModel() }
    }
    
    private func setViewModel() {
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
