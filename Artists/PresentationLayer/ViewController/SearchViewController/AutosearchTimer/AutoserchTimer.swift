import UIKit

final class AutosearchTimer {
    
    private enum Const {
        static let delay: TimeInterval = 2.0
    }

    private let interval: TimeInterval
    private let callback: () -> Void
    private var timer: Timer?
    
    init(interval: TimeInterval = Const.delay, callback: @escaping () -> Void) {
        self.interval = interval
        self.callback = callback
    }
    
    private func fire() {
        cancel()
        callback()
    }
    
    func activate() {
        if timer == nil {
            timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) {_ in
                self.fire()
            }
        }
    }
    
    func cancel() {
        timer?.invalidate()
        timer = nil
    }
}
