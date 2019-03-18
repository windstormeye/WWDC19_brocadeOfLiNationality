import UIKit
import PlaygroundSupport

class PJLineCollectionViewCell: UICollectionViewCell {
    //    var viewModel: ViewModel? {
    //        didSet { setViewModel(viewModel!) }
    //    }
    
    var viewModel: UIColor? {
        didSet { setViewModel(viewModel!) }
    }
    
    private func setViewModel(_ viewModel: UIColor) {
        backgroundColor = viewModel
    }
}

extension PJLineCollectionViewCell {
    struct ViewModel {
        var image: UIImage
    }
}
