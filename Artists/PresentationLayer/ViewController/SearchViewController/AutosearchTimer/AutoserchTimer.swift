import UIKit

final class AutosearchTimer {
    // MARK: Constants
    
    private enum Const {
        static let delay: TimeInterval = 2.5
    }
    
    // MARK: Private Properties
    
    private let interval: TimeInterval
    private let callback: () -> Void
    private var timer: Timer?
    
    // MARK: Initializers
    
    init(interval: TimeInterval = Const.delay, callback: @escaping () -> Void) {
        self.interval = interval
        self.callback = callback
    }
    
    // MARK: Private Methods
    
    private func fire() {
        cancel()
        callback()
    }
    
    // MARK: Public Methods
    
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
