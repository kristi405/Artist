import UIKit

final class AutosearchTimer {
    
    private enum Const {
        static let longAutosearchDelay: TimeInterval = 2.0
        static let shortAutosearchDelay: TimeInterval = 0.75
    }
    
    private let shortInterval: TimeInterval
    private let longInterval: TimeInterval
    private let callback: () -> Void
    private var shortTimer: Timer?
    private var longTimer: Timer?
    
    init(short: TimeInterval = Const.shortAutosearchDelay, long: TimeInterval = Const.longAutosearchDelay, callback: @escaping () -> Void) {
        self.shortInterval = short
        self.longInterval = long
        self.callback = callback
    }
    
    private func fire() {
        cancel()
        callback()
    }
    
    func activate() {
        shortTimer?.invalidate()
        shortTimer = Timer.scheduledTimer(withTimeInterval: shortInterval, repeats: false) {_ in
            self.fire()
        }
        if longTimer == nil {
            longTimer = Timer.scheduledTimer(withTimeInterval: longInterval, repeats: false) {_ in
                self.fire()
            }
        }
    }
    
    func cancel() {
        shortTimer?.invalidate()
        longTimer?.invalidate()
        shortTimer = nil
        longTimer = nil
    }
}
