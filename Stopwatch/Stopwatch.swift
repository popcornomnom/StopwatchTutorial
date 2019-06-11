import Foundation

class Stopwatch {
    
    // MARK: Private Properties

    private let step: Double
    private var timer: Timer?
    
    //The time when counting was started
    private(set) var from: Date?
    //The time when counting was stopped
    private(set) var to: Date?

    // The time when user pause timer last one
    private var timeIntervalTimelapsFrom: TimeInterval?
    // The total time before user paused timer
    private var timerSavedTime: TimeInterval = 0

    typealias TimeUpdated = (_ time: Double)->Void
    let timeUpdated: TimeUpdated

    // MARK: Public Properties
    
    var isPaused: Bool {
        return timer == nil
    }
    
    //MARK: Initialization
    
    init(step: Double = 1.0, timeUpdated: @escaping TimeUpdated) {
        self.step = step
        self.timeUpdated = timeUpdated
    }
    
    deinit {
        print("⏱ Stopwatch successfully deinited")
        deinitTimer()
    }
    
    //MARK: Timer actions

    func toggle() {
        guard timer != nil else {
            initTimer()
            return
        }
        deinitTimer()
    }
    
    func stop() {
        deinitTimer()
        from = nil
        to = nil
        timerSavedTime = 0
        timeUpdated(0)
    }
    
    private func initTimer() {
        let action: (Timer)->Void = { [weak self] timer in
            guard let strongSelf = self else {
                return
            }
            let to = Date().timeIntervalSince1970
            let timeIntervalFrom = strongSelf.timeIntervalTimelapsFrom ?? to
            let time = strongSelf.timerSavedTime + (to - timeIntervalFrom)
            strongSelf.timeUpdated(round(time))
        }
        if from == nil {
            from = Date()
        }
        if timeIntervalTimelapsFrom == nil {
            timeIntervalTimelapsFrom = Date().timeIntervalSince1970
        }
        timer = Timer.scheduledTimer(withTimeInterval: step,
                                     repeats: true, block: action)
    }
    
    private func deinitTimer() {
        //Saving last timelaps
        if let timeIntervalTimelapsFrom = timeIntervalTimelapsFrom {
            let to = Date().timeIntervalSince1970
            timerSavedTime += to - timeIntervalTimelapsFrom
        }
        //Invalidating
        timer?.invalidate()
        timer = nil
        timeIntervalTimelapsFrom = nil
    }
}
