//
//  ViewController.swift
//  Yuda
//
//  Created by 신유수 on 11/30/24.
//
import UIKit
import WebKit // WebKit을 추가로 가져옵니다.

class ViewController: UIViewController, WKNavigationDelegate {

    var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // 웹뷰 초기화
        webView = WKWebView()
        webView.navigationDelegate = self
        view.addSubview(webView)

        // 웹뷰의 레이아웃 설정 (오토레이아웃 적용)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // URL 로드
        if let url = URL(string: "https://yourdiary.site") {
            webView.load(URLRequest(url: url))
        }
    }
}
