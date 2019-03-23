import UIKit
import AVFoundation
import PlaygroundSupport


public var brocadeType: PJHomeViewController.BrocadeType = .normal
public var brocadeBackgroundColor: UIColor = UIColor.bgColor()

public func start(_ gameType: PJHomeViewController.GameType) {
    let vc = PJHomeViewController()
    vc.brocadeType = brocadeType
    vc.gameType = gameType
    vc.brocadeBackgroundColor = brocadeBackgroundColor
    PlaygroundPage.current.liveView = vc
}
