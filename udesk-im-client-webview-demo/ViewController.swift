import UIKit
import WebKit

class ViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {
    var webView: WKWebView!

    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true; // 允许左滑回到聊天页面
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let udeskURL = URL(string: "https://udesk.udesk.cn/im_client/?language=zh-cn")
        let request = URLRequest(url: udeskURL!)
        webView.load(request)
    }
    

    /** 解决预览与下载问题 **/
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        if let frame = navigationAction.targetFrame,
           frame.isMainFrame {
            return nil
        }
        webView.load(navigationAction.request)
        return nil
    }

    @available(iOS 15, *)
    func webView(
            _ webView: WKWebView,
            requestMediaCapturePermissionFor origin: WKSecurityOrigin,
            initiatedByFrame frame: WKFrameInfo,
            type: WKMediaCaptureType,
            decisionHandler: @escaping (WKPermissionDecision) -> Void
    ) {
        if origin.host.range(of: "udesk\\.cn", options: .regularExpression, range: nil, locale: nil) != nil {
            decisionHandler(.grant) // 对于 udesk 的网页直接给予权限，不必询问
        } else {
            decisionHandler(.prompt)
        }
    }
}
