import UIKit
import PlaygroundSupport

public enum BrocadeType {
    case small
    case normal
    case big
}

public var brocadeType: BrocadeType = .normal
public var brocadeBackgroundColor: UIColor = UIColor.bgColor()

public func start(_ gameType: PJHomeViewController.GameType) {
    let vc = PJHomeViewController()
    vc.brocadeType = .normal
    vc.gameType = gameType
    vc.brocadeBackgroundColor = .bgColor()
    PlaygroundPage.current.liveView = vc
}
