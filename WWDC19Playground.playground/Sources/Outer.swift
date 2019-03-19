import UIKit
import PlaygroundSupport

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

public var brocadeType: BrocadeType = .normal
public var brocadeBackgroundColor: UIColor = UIColor.bgColor()
public var sizeType: SizeType = .rectangle

public func start(_ gameType: PJHomeViewController.GameType) {
    let vc = PJHomeViewController()
    vc.gameType = gameType
    PlaygroundPage.current.liveView = vc
}
