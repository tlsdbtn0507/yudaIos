//
//  ViewController.swift
//  Yuda
//
//  Created by 신유수 on 11/30/24.
//

import UIKit
import WebKit

// UIColor 확장: HEX 코드를 UIColor로 변환
extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
// UIView 확장: 그라데이션 추가 기능
extension UIView {
    func applyGradient(colors: [UIColor], locations: [NSNumber]? = nil, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}

// WKWebView 확장: inputAccessoryView 제거를 위한 Swizzling
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
        
        // ViewController 배경에 그라데이션 설정
        view.applyGradient(
            colors: [
                UIColor(hex: "57F5FF"),  // rgba(87, 245, 255, 1)
                UIColor(hex: "00BFFF")   // rgba(0, 191, 255, 1)
            ],
            locations: [0.0, 1.0],
            startPoint: CGPoint(x: 0.5, y: 0),
            endPoint: CGPoint(x: 0.5, y: 1)
        )
        
        // WKWebView의 inputAccessoryView 제거를 위한 Swizzling 호출
        WKWebView.swizzleInputAccessoryView()
        
        // JavaScript 메시지 핸들러 설정
        let contentController = WKUserContentController()
        contentController.add(self, name: "nativeAlert") // 핸들러 이름 등록
        contentController.add(self, name: "nativeConfirm") // Confirm 핸들러 등록
        
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        webView = WKWebView(frame: .zero, configuration: config)
        webView.backgroundColor = .clear // 웹뷰의 기본 배경을 투명으로 설정
        webView.isOpaque = false // 배경 투명 설정
        
        // 웹뷰 추가
        view.addSubview(webView)
        
        // Auto Layout 설정
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 웹뷰 로드
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
        if message.name == "nativeConfirm", let messageBody = message.body as? String {
            DispatchQueue.main.async {
                self.showNativeConfirm(message: messageBody)
            }
        }
    }
    private func showNativeConfirm(message: String) {
        let alertController = UIAlertController(title: "Confirm", message: message, preferredStyle: .alert)

        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.webView.evaluateJavaScript("window.confirmCallback(true);", completionHandler: nil)
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel) { _ in
            self.webView.evaluateJavaScript("window.confirmCallback(false);", completionHandler: nil)
        }

        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}
