import UIKit
import WebKit

final class WebViewController: UIViewController {
    // MARK: Constants
    
    private enum Const {
        static let withDuration: CGFloat = 0.5
        static let alphaProgressView: CGFloat = 1
    }
    
    // MARK: IBOutlets
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: Public Properties
    
    var eventURL = ""
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchWebView()
        webView.addObserver(self,
                             forKeyPath: #keyPath(WKWebView.estimatedProgress),
                             options: .new,
                             context: nil)
        webView.navigationDelegate = self
        UIView.animate(withDuration: 3) {
            self.progressView.setProgress(1.0, animated: true)
        }
    }
    
    // MARK:  Override Methods
    
    // Installing the observer for loading webView
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView?.progress = Float(webView?.estimatedProgress ?? .zero)
        }
    }
    
    // MARK:  Private Methods
    
    // Send a request
    private func fetchWebView() {
        guard let url = URL(string: eventURL) else {return}
        let request = URLRequest(url: url)
        
        webView.load(request)
    }
    
    // Display progressView
    private func showProgressView() {
        UIView.animate(withDuration: TimeInterval(Const.withDuration), delay: .zero, options: .curveEaseInOut, animations: {
            self.progressView?.alpha = Const.alphaProgressView
        }, completion: nil)
    }
    
    // Hide progressView
    private func hideProgressView() {
        UIView.animate(withDuration: TimeInterval(Const.withDuration), delay: .zero, options: .curveEaseInOut, animations: {
            self.progressView?.alpha = .zero
        }, completion: nil)
    }
}


// MARK: - Extensions WKNavigationDelegate
extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        showProgressView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        hideProgressView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        hideProgressView()
    }
}
