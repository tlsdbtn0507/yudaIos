//
//  ViewController.swift
//  Yuda
//
//  Created by 신유수 on 11/30/24.
//
import UIKit
import WebKit

extension WKWebView {
    private static var hasSwizzled = false

    static func swizzleInputAccessoryView() {
        guard !hasSwizzled else { return }

        hasSwizzled = true

        let selector = NSSelectorFromString("inputAccessoryView")
        guard let originalMethod = class_getInstanceMethod(WKWebView.self, selector) else { return }

        let block: @convention(block) (Any?) -> UIView? = { _ in return nil }
        let newImplementation = imp_implementationWithBlock(block)

        method_setImplementation(originalMethod, newImplementation)
    }
}

class ViewController: UIViewController, WKScriptMessageHandler {
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // WKWebView의 inputAccessoryView 제거를 위한 Swizzling 호출
        WKWebView.swizzleInputAccessoryView()

        // JavaScript 메시지 핸들러 설정
        let contentController = WKUserContentController()
        contentController.add(self, name: "nativeAlert") // 핸들러 이름 등록
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        
        
        view.addSubview(webView)
        
        // Auto Layout 설정
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        if let url = URL(string: "https://yourdiary.site") {
             webView.load(URLRequest(url: url))
         }
    }
    
    // WKScriptMessageHandler 필수 구현
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "nativeAlert", let messageBody = message.body as? String {
            DispatchQueue.main.async { // UI 작업을 메인 스레드에서 실행
                let alert = UIAlertController(title: "알림", message: messageBody, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
