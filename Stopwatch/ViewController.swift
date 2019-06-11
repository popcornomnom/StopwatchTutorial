
import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var startPause: UIButton! {
        didSet {
            startPause.setBackgroundColor(.green, for: .normal)
            startPause.setBackgroundColor(.yellow, for: .selected)
        }
    }
    @IBOutlet private weak var time: UILabel!

    private lazy var stopwatch = Stopwatch(timeUpdated: { [weak self] timeInterval in
        guard let strongSelf = self else { return }
        strongSelf.time.text = strongSelf.timeString(from: timeInterval)
    })
    
    deinit {
        stopwatch.stop()
    }
    
    @IBAction func toggle(_ sendler: UIButton) {
        sendler.isSelected = !sendler.isSelected
        stopwatch.toggle()
    }
    
    @IBAction func reset(_ sendler: UIButton) {
        stopwatch.stop()
        startPause.isSelected = false
    }
    
    private func timeString(from timeInterval: TimeInterval) -> String {
        let seconds = Int(timeInterval.truncatingRemainder(dividingBy: 60))
        let minutes = Int(timeInterval.truncatingRemainder(dividingBy: 60 * 60) / 60)
        let hours = Int(timeInterval / 3600)
        return String(format: "%.2d:%.2d:%.2d", hours, minutes, seconds)
    }
}

