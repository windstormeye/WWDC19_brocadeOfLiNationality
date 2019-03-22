import Foundation

class PJShowItemCreator {
    static let shared = PJShowItemCreator()
    
    // 目标
    var focusArr: [[Int]]? { return getFocusArr() }
    var brocadeType: PJHomeViewController.BrocadeType = .normal
    
    private func getFocusArr() -> [[Int]] {
        var fo = [[Int]]()
        
        switch brocadeType {
        case .normal:
            fo = [
                [1, 2, 3],
                [4, 5, 6],
                [7, 8, 9],
                [10, 11, 12],
                [13, 14, 15],
                [16, 17, 18],
                [19, 20, 21],
                [22, 23, 24],
                [25, 26, 27],
                [28, 29, 30],
                //                [1, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
                //                [0, 0, 0],
            ]
        case .small:
            fo = [
                [0, 1],
                [0, 2],
                [0, 0],
                [0, 0],
                [0, 0],
                [0, 0],
            ]
        case .big:
            fo = [
                [0, 1, 0, 0],
                [0, 2, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
                [0, 0, 0, 0],
            ]
        }
        
        return fo
    }
    
    func isWin(verifyItems: [[PJShowItem]]) -> Bool {
        guard let focusArr = focusArr else { return false }
        
        for x in 0..<focusArr.count {
            for y in 0..<verifyItems[x].count {
                let itemTag = verifyItems[x][y].tag
                guard focusArr[x][y] != 0 else { continue }
                
                if itemTag != focusArr[x][y] {
                    return false
                }
            }
        }
        return true
    }
}
