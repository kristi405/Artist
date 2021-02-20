import UIKit
import WebKit

final class WebViewController: UIViewController {
    
// MARK:  Properties
    private var progressView: UIProgressView?
    private var webView: WKWebView?
    var eventURL = ""
    
    enum Numbers: CGFloat {
        case topProgressView = 2
        case widthProgressView = 414
        case heightProgressView = 15
        case withDuration = 0.5
        case alphaProgressView = 1
    }
    
// MARK:  Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        let progressView = UIProgressView(frame: CGRect(x: .zero, y: Numbers.topProgressView.rawValue, width: Numbers.widthProgressView.rawValue, height: Numbers.heightProgressView.rawValue))
        progressView.backgroundColor = .white
        webView?.addSubview(progressView)
        self.progressView = progressView
        
        webView?.allowsBackForwardNavigationGestures = true
        webView?.addObserver(self,
                            forKeyPath: #keyPath(WKWebView.estimatedProgress),
                            options: .new,
                            context: nil)
        webView?.navigationDelegate = self
        fetchWebView()
    }
    
// MARK:  Business logic
    // Define webView
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        view = webView
    }
    
    // Send a request
    private func fetchWebView() {
        guard let url = URL(string: eventURL) else {return}
        let request = URLRequest(url: url)
        
        webView?.load(request)
    }
    
    // Installing the observer for loading webView
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        
        if keyPath == "estimatedProgress" {
            progressView?.progress = Float(webView?.estimatedProgress ?? .zero)
        }
    }
    
    // Display progressView
    private func showProgressView() {
        UIView.animate(withDuration: TimeInterval(Numbers.withDuration.rawValue), delay: .zero, options: .curveEaseInOut, animations: {
            self.progressView?.alpha = Numbers.alphaProgressView.rawValue
        }, completion: nil)
    }
    
    // Hide progressView
    private func hideProgressView() {
        UIView.animate(withDuration: TimeInterval(Numbers.withDuration.rawValue), delay: .zero, options: .curveEaseInOut, animations: {
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
