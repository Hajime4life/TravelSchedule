import SwiftUI
import WebKit

struct WebView: UIViewControllerRepresentable {
    let url: URL
    
    func makeUIViewController(context: Context) -> WKWebViewController {
        let webViewController = WKWebViewController()
        webViewController.url = url
        return webViewController
    }
    
    func updateUIViewController(_ uiViewController: WKWebViewController, context: Context) {
        if uiViewController.url != url {
            uiViewController.url = url
            uiViewController.loadWebView()
        }
    }
}

class WKWebViewController: UIViewController {
    var url: URL?
    private var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        loadWebView()
    }
    
    func loadWebView() {
        if let url = url {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
